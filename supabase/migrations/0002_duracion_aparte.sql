-- Ronda — la duración de la junta se elige aparte
--
-- Hasta ahora una junta duraba exactamente tantos turnos como participantes
-- tuviera, y el esquema lo imponía con una restricción: cada participante
-- cobraba una vez y solo una.
--
-- Leonardo lo corrigió: en el mercado la duración se acuerda aparte. Una junta
-- semanal puede durar veinte semanas con diez personas, porque alguien toma dos
-- números, paga doble y cobra dos veces. Es común y es válido.
--
-- Lo que NO cambia: el pozo de cada turno sigue siendo el aporte por la
-- cantidad de participantes. Lo que cambia es quién lo recibe y cuántas veces.

-- ============================================================
-- 1. Un participante puede cobrar más de una vez
-- ============================================================

-- Esta era la restricción que lo impedía. Se cae.
alter table public.turnos
  drop constraint if exists turnos_junta_id_participante_id_key;

-- `(junta_id, numero)` sigue siendo única: dos turnos no pueden ser el mismo
-- número de vuelta. Eso no se toca.

comment on table public.turnos is
  'Una vuelta de la junta. La cantidad de turnos la elige la cabeza de junta y '
  'puede no coincidir con la cantidad de participantes: si hay más turnos que '
  'gente, alguien cobra más de una vez; si hay menos, alguien no cobra. La app '
  'lo advierte antes de generar el calendario.';
