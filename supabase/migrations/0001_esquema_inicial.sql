-- Ronda — esquema inicial
-- Postgres / Supabase. Ejecutar entero en el SQL editor del proyecto.
--
-- Premisa que define el modelo: la app la usa la cabeza de junta, sola.
-- No hay cuenta por participante. Una participante es una fila con nombre y
-- teléfono, no un usuario de auth. Por eso toda la autorización se reduce a
-- una sola pregunta: ¿esta junta es de quien está pidiendo la fila?
--
-- La generación del calendario de turnos NO vive aquí: es lógica de dominio en
-- Dart puro y es lo único que se testea. La base guarda e impide estados
-- imposibles; no decide.

-- ============================================================
-- 1. Tipos
-- ============================================================

create type public.frecuencia_junta as enum ('semanal', 'quincenal', 'mensual');
create type public.estado_junta     as enum ('borrador', 'activa', 'cerrada');
create type public.estado_turno     as enum ('pendiente', 'en_curso', 'completado');
create type public.estado_aporte    as enum ('pendiente', 'pagado');
create type public.metodo_pago      as enum ('efectivo', 'yape', 'plin', 'transferencia', 'otro');

-- ============================================================
-- 2. Utilidades
-- ============================================================

-- Toca actualizado_en en cada UPDATE.
create or replace function public.tocar_actualizado()
returns trigger
language plpgsql
as $$
begin
  new.actualizado_en := now();
  return new;
end;
$$;

-- Código de 6 caracteres que se dicta hablando: sin O, 0, I ni 1.
create or replace function public.generar_codigo()
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  alfabeto constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  candidato text;
begin
  loop
    candidato := '';
    for _ in 1..6 loop
      candidato := candidato || substr(alfabeto, 1 + floor(random() * length(alfabeto))::int, 1);
    end loop;
    exit when not exists (select 1 from public.juntas where codigo = candidato);
  end loop;
  return candidato;
end;
$$;

-- Primera carpeta de una ruta de storage como uuid, o null si no lo es.
create or replace function public.uuid_de_ruta(ruta text)
returns uuid
language plpgsql
immutable
as $$
begin
  return split_part(ruta, '/', 1)::uuid;
exception when others then
  return null;
end;
$$;

-- ============================================================
-- 3. Tablas
-- ============================================================

-- 3.1 Perfil de la cabeza de junta. Espejo de auth.users.
create table public.perfiles (
  id             uuid primary key references auth.users(id) on delete cascade,
  nombre         text not null default 'Sin nombre',
  telefono       text,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- 3.2 Junta.
create table public.juntas (
  id                     uuid primary key default gen_random_uuid(),
  cabeza_id              uuid not null references public.perfiles(id) on delete cascade,
  nombre                 text not null check (length(btrim(nombre)) between 1 and 60),
  codigo                 text not null unique default public.generar_codigo()
                           check (codigo ~ '^[A-Z0-9]{6}$'),
  monto_aporte_centavos  bigint not null check (monto_aporte_centavos > 0),
  frecuencia             public.frecuencia_junta not null,
  fecha_inicio           date not null,
  estado                 public.estado_junta not null default 'borrador',
  notas                  text,
  creado_en              timestamptz not null default now(),
  actualizado_en         timestamptz not null default now()
);

-- 3.3 Participante. No es un usuario: es una línea del cuaderno.
create table public.participantes (
  id             uuid primary key default gen_random_uuid(),
  junta_id       uuid not null references public.juntas(id) on delete cascade,
  nombre         text not null check (length(btrim(nombre)) between 1 and 60),
  telefono       text check (telefono ~ '^[0-9]{9}$'),
  orden_turno    int  not null check (orden_turno > 0),
  activo         boolean not null default true,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now(),
  -- diferible: reordenar la lista es un swap dentro de una transacción
  constraint participantes_orden_unico unique (junta_id, orden_turno)
    deferrable initially deferred,
  -- deja apuntar con clave compuesta desde turnos y aportes
  constraint participantes_id_junta unique (id, junta_id)
);

-- 3.4 Turno: quién cobra y cuándo. Una fila por vuelta de la ronda.
create table public.turnos (
  id               uuid primary key default gen_random_uuid(),
  junta_id         uuid not null references public.juntas(id) on delete cascade,
  participante_id  uuid not null,
  numero           int  not null check (numero > 0),
  fecha_programada date not null,
  fecha_entregado  date,
  estado           public.estado_turno not null default 'pendiente',
  creado_en        timestamptz not null default now(),
  actualizado_en   timestamptz not null default now(),
  unique (junta_id, numero),
  -- cada participante cobra exactamente una vez por ciclo
  unique (junta_id, participante_id),
  constraint turnos_id_junta unique (id, junta_id),
  -- el participante tiene que ser de ESTA junta, no de otra
  constraint turnos_participante_de_la_junta
    foreign key (participante_id, junta_id)
    references public.participantes(id, junta_id) on delete restrict,
  constraint turnos_entrega_coherente
    check ((estado = 'completado') = (fecha_entregado is not null))
);

-- 3.5 Aporte: lo que una participante pone en un turno.
create table public.aportes (
  id                  uuid primary key default gen_random_uuid(),
  junta_id            uuid not null references public.juntas(id) on delete cascade,
  turno_id            uuid not null,
  participante_id     uuid not null,
  monto_centavos      bigint not null check (monto_centavos >= 0),
  estado              public.estado_aporte not null default 'pendiente',
  metodo              public.metodo_pago,
  pagado_en           timestamptz,
  voucher_path        text,
  ocr_monto_centavos  bigint,
  ocr_fecha           date,
  nota                text,
  creado_en           timestamptz not null default now(),
  actualizado_en      timestamptz not null default now(),
  unique (turno_id, participante_id),
  constraint aportes_turno_de_la_junta
    foreign key (turno_id, junta_id)
    references public.turnos(id, junta_id) on delete cascade,
  constraint aportes_participante_de_la_junta
    foreign key (participante_id, junta_id)
    references public.participantes(id, junta_id) on delete restrict,
  constraint aportes_pago_coherente
    check ((estado = 'pagado') = (pagado_en is not null))
);

-- "Atrasado" no se guarda: se deriva de fecha_programada contra hoy.
-- Un estado guardado se queda viejo; uno derivado nunca miente.

-- ============================================================
-- 4. Índices
-- ============================================================

create index juntas_cabeza_idx        on public.juntas (cabeza_id);
create index participantes_junta_idx  on public.participantes (junta_id, orden_turno);
create index turnos_junta_idx         on public.turnos (junta_id, numero);
create index turnos_fecha_idx         on public.turnos (fecha_programada) where estado <> 'completado';
create index aportes_junta_idx        on public.aportes (junta_id);
create index aportes_turno_idx        on public.aportes (turno_id);
create index aportes_pendientes_idx   on public.aportes (junta_id) where estado = 'pendiente';

-- ============================================================
-- 5. Triggers
-- ============================================================

create trigger perfiles_tocar      before update on public.perfiles
  for each row execute function public.tocar_actualizado();
create trigger juntas_tocar        before update on public.juntas
  for each row execute function public.tocar_actualizado();
create trigger participantes_tocar before update on public.participantes
  for each row execute function public.tocar_actualizado();
create trigger turnos_tocar        before update on public.turnos
  for each row execute function public.tocar_actualizado();
create trigger aportes_tocar       before update on public.aportes
  for each row execute function public.tocar_actualizado();

-- Perfil automático al entrar con Google por primera vez.
create or replace function public.crear_perfil()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.perfiles (id, nombre)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'name',
      'Sin nombre'
    )
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger al_crear_usuario
  after insert on auth.users
  for each row execute function public.crear_perfil();

-- ============================================================
-- 6. RLS
-- ============================================================
-- Una sola pregunta, una sola función. Es SECURITY DEFINER a propósito:
-- lee juntas por fuera de RLS y evita la recursión de política contra política.
-- auth.uid() va envuelto en un subselect para que el planner lo evalúe una vez
-- por consulta y no una vez por fila.

create or replace function public.es_cabeza(p_junta uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1
    from public.juntas j
    where j.id = p_junta
      and j.cabeza_id = (select auth.uid())
  );
$$;

revoke execute on function public.es_cabeza(uuid) from public, anon;
grant  execute on function public.es_cabeza(uuid) to authenticated;
revoke execute on function public.generar_codigo() from public, anon;
grant  execute on function public.generar_codigo() to authenticated;

alter table public.perfiles      enable row level security;
alter table public.juntas        enable row level security;
alter table public.participantes enable row level security;
alter table public.turnos        enable row level security;
alter table public.aportes       enable row level security;

-- Sin políticas para anon: el anónimo no ve absolutamente nada.

-- 6.1 perfiles: cada quien el suyo. No se borra desde la app.
create policy perfiles_select on public.perfiles
  for select to authenticated using (id = (select auth.uid()));
create policy perfiles_insert on public.perfiles
  for insert to authenticated with check (id = (select auth.uid()));
create policy perfiles_update on public.perfiles
  for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

-- 6.2 juntas: las mías. cabeza_id no se puede reasignar a otro.
create policy juntas_select on public.juntas
  for select to authenticated using (cabeza_id = (select auth.uid()));
create policy juntas_insert on public.juntas
  for insert to authenticated with check (cabeza_id = (select auth.uid()));
create policy juntas_update on public.juntas
  for update to authenticated
  using (cabeza_id = (select auth.uid())) with check (cabeza_id = (select auth.uid()));
create policy juntas_delete on public.juntas
  for delete to authenticated using (cabeza_id = (select auth.uid()));

-- 6.3 participantes, turnos y aportes: cuelgan de la junta.
-- El WITH CHECK cierra el agujero de mover una fila a la junta de otro.
create policy participantes_select on public.participantes
  for select to authenticated using (public.es_cabeza(junta_id));
create policy participantes_insert on public.participantes
  for insert to authenticated with check (public.es_cabeza(junta_id));
create policy participantes_update on public.participantes
  for update to authenticated
  using (public.es_cabeza(junta_id)) with check (public.es_cabeza(junta_id));
create policy participantes_delete on public.participantes
  for delete to authenticated using (public.es_cabeza(junta_id));

create policy turnos_select on public.turnos
  for select to authenticated using (public.es_cabeza(junta_id));
create policy turnos_insert on public.turnos
  for insert to authenticated with check (public.es_cabeza(junta_id));
create policy turnos_update on public.turnos
  for update to authenticated
  using (public.es_cabeza(junta_id)) with check (public.es_cabeza(junta_id));
create policy turnos_delete on public.turnos
  for delete to authenticated using (public.es_cabeza(junta_id));

create policy aportes_select on public.aportes
  for select to authenticated using (public.es_cabeza(junta_id));
create policy aportes_insert on public.aportes
  for insert to authenticated with check (public.es_cabeza(junta_id));
create policy aportes_update on public.aportes
  for update to authenticated
  using (public.es_cabeza(junta_id)) with check (public.es_cabeza(junta_id));
create policy aportes_delete on public.aportes
  for delete to authenticated using (public.es_cabeza(junta_id));

-- ============================================================
-- 7. Permisos de tabla
-- ============================================================

revoke all on all tables in schema public from anon;
grant select, insert, update, delete
  on public.perfiles, public.juntas, public.participantes, public.turnos, public.aportes
  to authenticated;

-- ============================================================
-- 8. Storage de vouchers
-- ============================================================
-- Bucket privado. La ruta es <junta_id>/<aporte_id>.jpg: la primera carpeta es
-- la llave de autorización, así que la política es la misma pregunta de siempre.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('vouchers', 'vouchers', false, 5242880,
        array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

create policy vouchers_select on storage.objects
  for select to authenticated
  using (bucket_id = 'vouchers' and public.es_cabeza(public.uuid_de_ruta(name)));
create policy vouchers_insert on storage.objects
  for insert to authenticated
  with check (bucket_id = 'vouchers' and public.es_cabeza(public.uuid_de_ruta(name)));
create policy vouchers_update on storage.objects
  for update to authenticated
  using (bucket_id = 'vouchers' and public.es_cabeza(public.uuid_de_ruta(name)))
  with check (bucket_id = 'vouchers' and public.es_cabeza(public.uuid_de_ruta(name)));
create policy vouchers_delete on storage.objects
  for delete to authenticated
  using (bucket_id = 'vouchers' and public.es_cabeza(public.uuid_de_ruta(name)));

-- ============================================================
-- 9. Vista de la pantalla principal
-- ============================================================
-- security_invoker: la vista se lee con los permisos de quien pregunta, así que
-- hereda RLS en vez de saltárselo.

create view public.resumen_junta
with (security_invoker = true)
as
select
  j.id                          as junta_id,
  j.nombre,
  j.codigo,
  j.estado,
  j.monto_aporte_centavos,
  t_actual.numero               as turno_actual,
  t_actual.fecha_programada     as fecha_turno_actual,
  (select count(*) from public.participantes p
     where p.junta_id = j.id and p.activo)                        as participantes_activos,
  (select count(*) from public.turnos t
     where t.junta_id = j.id)                                     as turnos_totales,
  (select count(*) from public.turnos t
     where t.junta_id = j.id and t.estado = 'completado')          as turnos_completados,
  (select count(*) from public.aportes a
     where a.turno_id = t_actual.id and a.estado = 'pendiente')    as faltan_por_pagar,
  (select coalesce(sum(a.monto_centavos), 0) from public.aportes a
     where a.turno_id = t_actual.id and a.estado = 'pagado')       as recaudado_centavos
from public.juntas j
left join lateral (
  select t2.id, t2.numero, t2.fecha_programada
  from public.turnos t2
  where t2.junta_id = j.id and t2.estado <> 'completado'
  order by t2.numero
  limit 1
) t_actual on true;

grant select on public.resumen_junta to authenticated;
