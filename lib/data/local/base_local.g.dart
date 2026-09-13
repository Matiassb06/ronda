// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_local.dart';

// ignore_for_file: type=lint
class $JuntasLocalesTable extends JuntasLocales
    with TableInfo<$JuntasLocalesTable, JuntasLocale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JuntasLocalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cabezaIdMeta = const VerificationMeta(
    'cabezaId',
  );
  @override
  late final GeneratedColumn<String> cabezaId = GeneratedColumn<String>(
    'cabeza_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoAporteCentavosMeta =
      const VerificationMeta('montoAporteCentavos');
  @override
  late final GeneratedColumn<int> montoAporteCentavos = GeneratedColumn<int>(
    'monto_aporte_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frecuenciaMeta = const VerificationMeta(
    'frecuencia',
  );
  @override
  late final GeneratedColumn<String> frecuencia = GeneratedColumn<String>(
    'frecuencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cabezaId,
    nombre,
    codigo,
    montoAporteCentavos,
    frecuencia,
    fechaInicio,
    estado,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'juntas_locales';
  @override
  VerificationContext validateIntegrity(
    Insertable<JuntasLocale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cabeza_id')) {
      context.handle(
        _cabezaIdMeta,
        cabezaId.isAcceptableOrUnknown(data['cabeza_id']!, _cabezaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cabezaIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('monto_aporte_centavos')) {
      context.handle(
        _montoAporteCentavosMeta,
        montoAporteCentavos.isAcceptableOrUnknown(
          data['monto_aporte_centavos']!,
          _montoAporteCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoAporteCentavosMeta);
    }
    if (data.containsKey('frecuencia')) {
      context.handle(
        _frecuenciaMeta,
        frecuencia.isAcceptableOrUnknown(data['frecuencia']!, _frecuenciaMeta),
      );
    } else if (isInserting) {
      context.missing(_frecuenciaMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JuntasLocale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JuntasLocale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cabezaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cabeza_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      montoAporteCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_aporte_centavos'],
      )!,
      frecuencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frecuencia'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $JuntasLocalesTable createAlias(String alias) {
    return $JuntasLocalesTable(attachedDatabase, alias);
  }
}

class JuntasLocale extends DataClass implements Insertable<JuntasLocale> {
  final String id;
  final String cabezaId;
  final String nombre;
  final String codigo;
  final int montoAporteCentavos;
  final String frecuencia;
  final DateTime fechaInicio;
  final String estado;
  final DateTime actualizadoEn;
  const JuntasLocale({
    required this.id,
    required this.cabezaId,
    required this.nombre,
    required this.codigo,
    required this.montoAporteCentavos,
    required this.frecuencia,
    required this.fechaInicio,
    required this.estado,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cabeza_id'] = Variable<String>(cabezaId);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['monto_aporte_centavos'] = Variable<int>(montoAporteCentavos);
    map['frecuencia'] = Variable<String>(frecuencia);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    map['estado'] = Variable<String>(estado);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  JuntasLocalesCompanion toCompanion(bool nullToAbsent) {
    return JuntasLocalesCompanion(
      id: Value(id),
      cabezaId: Value(cabezaId),
      nombre: Value(nombre),
      codigo: Value(codigo),
      montoAporteCentavos: Value(montoAporteCentavos),
      frecuencia: Value(frecuencia),
      fechaInicio: Value(fechaInicio),
      estado: Value(estado),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory JuntasLocale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JuntasLocale(
      id: serializer.fromJson<String>(json['id']),
      cabezaId: serializer.fromJson<String>(json['cabezaId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      montoAporteCentavos: serializer.fromJson<int>(
        json['montoAporteCentavos'],
      ),
      frecuencia: serializer.fromJson<String>(json['frecuencia']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      estado: serializer.fromJson<String>(json['estado']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cabezaId': serializer.toJson<String>(cabezaId),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'montoAporteCentavos': serializer.toJson<int>(montoAporteCentavos),
      'frecuencia': serializer.toJson<String>(frecuencia),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'estado': serializer.toJson<String>(estado),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  JuntasLocale copyWith({
    String? id,
    String? cabezaId,
    String? nombre,
    String? codigo,
    int? montoAporteCentavos,
    String? frecuencia,
    DateTime? fechaInicio,
    String? estado,
    DateTime? actualizadoEn,
  }) => JuntasLocale(
    id: id ?? this.id,
    cabezaId: cabezaId ?? this.cabezaId,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    montoAporteCentavos: montoAporteCentavos ?? this.montoAporteCentavos,
    frecuencia: frecuencia ?? this.frecuencia,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    estado: estado ?? this.estado,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  JuntasLocale copyWithCompanion(JuntasLocalesCompanion data) {
    return JuntasLocale(
      id: data.id.present ? data.id.value : this.id,
      cabezaId: data.cabezaId.present ? data.cabezaId.value : this.cabezaId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      montoAporteCentavos: data.montoAporteCentavos.present
          ? data.montoAporteCentavos.value
          : this.montoAporteCentavos,
      frecuencia: data.frecuencia.present
          ? data.frecuencia.value
          : this.frecuencia,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      estado: data.estado.present ? data.estado.value : this.estado,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JuntasLocale(')
          ..write('id: $id, ')
          ..write('cabezaId: $cabezaId, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('montoAporteCentavos: $montoAporteCentavos, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('estado: $estado, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cabezaId,
    nombre,
    codigo,
    montoAporteCentavos,
    frecuencia,
    fechaInicio,
    estado,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JuntasLocale &&
          other.id == this.id &&
          other.cabezaId == this.cabezaId &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.montoAporteCentavos == this.montoAporteCentavos &&
          other.frecuencia == this.frecuencia &&
          other.fechaInicio == this.fechaInicio &&
          other.estado == this.estado &&
          other.actualizadoEn == this.actualizadoEn);
}

class JuntasLocalesCompanion extends UpdateCompanion<JuntasLocale> {
  final Value<String> id;
  final Value<String> cabezaId;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<int> montoAporteCentavos;
  final Value<String> frecuencia;
  final Value<DateTime> fechaInicio;
  final Value<String> estado;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const JuntasLocalesCompanion({
    this.id = const Value.absent(),
    this.cabezaId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.montoAporteCentavos = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.estado = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JuntasLocalesCompanion.insert({
    required String id,
    required String cabezaId,
    required String nombre,
    required String codigo,
    required int montoAporteCentavos,
    required String frecuencia,
    required DateTime fechaInicio,
    required String estado,
    required DateTime actualizadoEn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cabezaId = Value(cabezaId),
       nombre = Value(nombre),
       codigo = Value(codigo),
       montoAporteCentavos = Value(montoAporteCentavos),
       frecuencia = Value(frecuencia),
       fechaInicio = Value(fechaInicio),
       estado = Value(estado),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<JuntasLocale> custom({
    Expression<String>? id,
    Expression<String>? cabezaId,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<int>? montoAporteCentavos,
    Expression<String>? frecuencia,
    Expression<DateTime>? fechaInicio,
    Expression<String>? estado,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cabezaId != null) 'cabeza_id': cabezaId,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (montoAporteCentavos != null)
        'monto_aporte_centavos': montoAporteCentavos,
      if (frecuencia != null) 'frecuencia': frecuencia,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (estado != null) 'estado': estado,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JuntasLocalesCompanion copyWith({
    Value<String>? id,
    Value<String>? cabezaId,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<int>? montoAporteCentavos,
    Value<String>? frecuencia,
    Value<DateTime>? fechaInicio,
    Value<String>? estado,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return JuntasLocalesCompanion(
      id: id ?? this.id,
      cabezaId: cabezaId ?? this.cabezaId,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      montoAporteCentavos: montoAporteCentavos ?? this.montoAporteCentavos,
      frecuencia: frecuencia ?? this.frecuencia,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      estado: estado ?? this.estado,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cabezaId.present) {
      map['cabeza_id'] = Variable<String>(cabezaId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (montoAporteCentavos.present) {
      map['monto_aporte_centavos'] = Variable<int>(montoAporteCentavos.value);
    }
    if (frecuencia.present) {
      map['frecuencia'] = Variable<String>(frecuencia.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JuntasLocalesCompanion(')
          ..write('id: $id, ')
          ..write('cabezaId: $cabezaId, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('montoAporteCentavos: $montoAporteCentavos, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('estado: $estado, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParticipantesLocalesTable extends ParticipantesLocales
    with TableInfo<$ParticipantesLocalesTable, ParticipantesLocale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParticipantesLocalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juntaIdMeta = const VerificationMeta(
    'juntaId',
  );
  @override
  late final GeneratedColumn<String> juntaId = GeneratedColumn<String>(
    'junta_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ordenTurnoMeta = const VerificationMeta(
    'ordenTurno',
  );
  @override
  late final GeneratedColumn<int> ordenTurno = GeneratedColumn<int>(
    'orden_turno',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    juntaId,
    nombre,
    telefono,
    ordenTurno,
    activo,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'participantes_locales';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParticipantesLocale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('junta_id')) {
      context.handle(
        _juntaIdMeta,
        juntaId.isAcceptableOrUnknown(data['junta_id']!, _juntaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_juntaIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('orden_turno')) {
      context.handle(
        _ordenTurnoMeta,
        ordenTurno.isAcceptableOrUnknown(data['orden_turno']!, _ordenTurnoMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenTurnoMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParticipantesLocale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParticipantesLocale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      juntaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}junta_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      ordenTurno: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_turno'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $ParticipantesLocalesTable createAlias(String alias) {
    return $ParticipantesLocalesTable(attachedDatabase, alias);
  }
}

class ParticipantesLocale extends DataClass
    implements Insertable<ParticipantesLocale> {
  final String id;
  final String juntaId;
  final String nombre;
  final String? telefono;
  final int ordenTurno;
  final bool activo;
  final DateTime actualizadoEn;
  const ParticipantesLocale({
    required this.id,
    required this.juntaId,
    required this.nombre,
    this.telefono,
    required this.ordenTurno,
    required this.activo,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['junta_id'] = Variable<String>(juntaId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    map['orden_turno'] = Variable<int>(ordenTurno);
    map['activo'] = Variable<bool>(activo);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  ParticipantesLocalesCompanion toCompanion(bool nullToAbsent) {
    return ParticipantesLocalesCompanion(
      id: Value(id),
      juntaId: Value(juntaId),
      nombre: Value(nombre),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      ordenTurno: Value(ordenTurno),
      activo: Value(activo),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory ParticipantesLocale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParticipantesLocale(
      id: serializer.fromJson<String>(json['id']),
      juntaId: serializer.fromJson<String>(json['juntaId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      ordenTurno: serializer.fromJson<int>(json['ordenTurno']),
      activo: serializer.fromJson<bool>(json['activo']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'juntaId': serializer.toJson<String>(juntaId),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String?>(telefono),
      'ordenTurno': serializer.toJson<int>(ordenTurno),
      'activo': serializer.toJson<bool>(activo),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  ParticipantesLocale copyWith({
    String? id,
    String? juntaId,
    String? nombre,
    Value<String?> telefono = const Value.absent(),
    int? ordenTurno,
    bool? activo,
    DateTime? actualizadoEn,
  }) => ParticipantesLocale(
    id: id ?? this.id,
    juntaId: juntaId ?? this.juntaId,
    nombre: nombre ?? this.nombre,
    telefono: telefono.present ? telefono.value : this.telefono,
    ordenTurno: ordenTurno ?? this.ordenTurno,
    activo: activo ?? this.activo,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  ParticipantesLocale copyWithCompanion(ParticipantesLocalesCompanion data) {
    return ParticipantesLocale(
      id: data.id.present ? data.id.value : this.id,
      juntaId: data.juntaId.present ? data.juntaId.value : this.juntaId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      ordenTurno: data.ordenTurno.present
          ? data.ordenTurno.value
          : this.ordenTurno,
      activo: data.activo.present ? data.activo.value : this.activo,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantesLocale(')
          ..write('id: $id, ')
          ..write('juntaId: $juntaId, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('ordenTurno: $ordenTurno, ')
          ..write('activo: $activo, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    juntaId,
    nombre,
    telefono,
    ordenTurno,
    activo,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParticipantesLocale &&
          other.id == this.id &&
          other.juntaId == this.juntaId &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.ordenTurno == this.ordenTurno &&
          other.activo == this.activo &&
          other.actualizadoEn == this.actualizadoEn);
}

class ParticipantesLocalesCompanion
    extends UpdateCompanion<ParticipantesLocale> {
  final Value<String> id;
  final Value<String> juntaId;
  final Value<String> nombre;
  final Value<String?> telefono;
  final Value<int> ordenTurno;
  final Value<bool> activo;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const ParticipantesLocalesCompanion({
    this.id = const Value.absent(),
    this.juntaId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.ordenTurno = const Value.absent(),
    this.activo = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParticipantesLocalesCompanion.insert({
    required String id,
    required String juntaId,
    required String nombre,
    this.telefono = const Value.absent(),
    required int ordenTurno,
    this.activo = const Value.absent(),
    required DateTime actualizadoEn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       juntaId = Value(juntaId),
       nombre = Value(nombre),
       ordenTurno = Value(ordenTurno),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<ParticipantesLocale> custom({
    Expression<String>? id,
    Expression<String>? juntaId,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<int>? ordenTurno,
    Expression<bool>? activo,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (juntaId != null) 'junta_id': juntaId,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (ordenTurno != null) 'orden_turno': ordenTurno,
      if (activo != null) 'activo': activo,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParticipantesLocalesCompanion copyWith({
    Value<String>? id,
    Value<String>? juntaId,
    Value<String>? nombre,
    Value<String?>? telefono,
    Value<int>? ordenTurno,
    Value<bool>? activo,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return ParticipantesLocalesCompanion(
      id: id ?? this.id,
      juntaId: juntaId ?? this.juntaId,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      ordenTurno: ordenTurno ?? this.ordenTurno,
      activo: activo ?? this.activo,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (juntaId.present) {
      map['junta_id'] = Variable<String>(juntaId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (ordenTurno.present) {
      map['orden_turno'] = Variable<int>(ordenTurno.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantesLocalesCompanion(')
          ..write('id: $id, ')
          ..write('juntaId: $juntaId, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('ordenTurno: $ordenTurno, ')
          ..write('activo: $activo, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TurnosLocalesTable extends TurnosLocales
    with TableInfo<$TurnosLocalesTable, TurnosLocale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TurnosLocalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juntaIdMeta = const VerificationMeta(
    'juntaId',
  );
  @override
  late final GeneratedColumn<String> juntaId = GeneratedColumn<String>(
    'junta_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _participanteIdMeta = const VerificationMeta(
    'participanteId',
  );
  @override
  late final GeneratedColumn<String> participanteId = GeneratedColumn<String>(
    'participante_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaProgramadaMeta = const VerificationMeta(
    'fechaProgramada',
  );
  @override
  late final GeneratedColumn<DateTime> fechaProgramada =
      GeneratedColumn<DateTime>(
        'fecha_programada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    juntaId,
    participanteId,
    numero,
    fechaProgramada,
    estado,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'turnos_locales';
  @override
  VerificationContext validateIntegrity(
    Insertable<TurnosLocale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('junta_id')) {
      context.handle(
        _juntaIdMeta,
        juntaId.isAcceptableOrUnknown(data['junta_id']!, _juntaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_juntaIdMeta);
    }
    if (data.containsKey('participante_id')) {
      context.handle(
        _participanteIdMeta,
        participanteId.isAcceptableOrUnknown(
          data['participante_id']!,
          _participanteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participanteIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('fecha_programada')) {
      context.handle(
        _fechaProgramadaMeta,
        fechaProgramada.isAcceptableOrUnknown(
          data['fecha_programada']!,
          _fechaProgramadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaProgramadaMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TurnosLocale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TurnosLocale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      juntaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}junta_id'],
      )!,
      participanteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participante_id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
      fechaProgramada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_programada'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $TurnosLocalesTable createAlias(String alias) {
    return $TurnosLocalesTable(attachedDatabase, alias);
  }
}

class TurnosLocale extends DataClass implements Insertable<TurnosLocale> {
  final String id;
  final String juntaId;
  final String participanteId;
  final int numero;
  final DateTime fechaProgramada;
  final String estado;
  final DateTime actualizadoEn;
  const TurnosLocale({
    required this.id,
    required this.juntaId,
    required this.participanteId,
    required this.numero,
    required this.fechaProgramada,
    required this.estado,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['junta_id'] = Variable<String>(juntaId);
    map['participante_id'] = Variable<String>(participanteId);
    map['numero'] = Variable<int>(numero);
    map['fecha_programada'] = Variable<DateTime>(fechaProgramada);
    map['estado'] = Variable<String>(estado);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  TurnosLocalesCompanion toCompanion(bool nullToAbsent) {
    return TurnosLocalesCompanion(
      id: Value(id),
      juntaId: Value(juntaId),
      participanteId: Value(participanteId),
      numero: Value(numero),
      fechaProgramada: Value(fechaProgramada),
      estado: Value(estado),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory TurnosLocale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TurnosLocale(
      id: serializer.fromJson<String>(json['id']),
      juntaId: serializer.fromJson<String>(json['juntaId']),
      participanteId: serializer.fromJson<String>(json['participanteId']),
      numero: serializer.fromJson<int>(json['numero']),
      fechaProgramada: serializer.fromJson<DateTime>(json['fechaProgramada']),
      estado: serializer.fromJson<String>(json['estado']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'juntaId': serializer.toJson<String>(juntaId),
      'participanteId': serializer.toJson<String>(participanteId),
      'numero': serializer.toJson<int>(numero),
      'fechaProgramada': serializer.toJson<DateTime>(fechaProgramada),
      'estado': serializer.toJson<String>(estado),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  TurnosLocale copyWith({
    String? id,
    String? juntaId,
    String? participanteId,
    int? numero,
    DateTime? fechaProgramada,
    String? estado,
    DateTime? actualizadoEn,
  }) => TurnosLocale(
    id: id ?? this.id,
    juntaId: juntaId ?? this.juntaId,
    participanteId: participanteId ?? this.participanteId,
    numero: numero ?? this.numero,
    fechaProgramada: fechaProgramada ?? this.fechaProgramada,
    estado: estado ?? this.estado,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  TurnosLocale copyWithCompanion(TurnosLocalesCompanion data) {
    return TurnosLocale(
      id: data.id.present ? data.id.value : this.id,
      juntaId: data.juntaId.present ? data.juntaId.value : this.juntaId,
      participanteId: data.participanteId.present
          ? data.participanteId.value
          : this.participanteId,
      numero: data.numero.present ? data.numero.value : this.numero,
      fechaProgramada: data.fechaProgramada.present
          ? data.fechaProgramada.value
          : this.fechaProgramada,
      estado: data.estado.present ? data.estado.value : this.estado,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TurnosLocale(')
          ..write('id: $id, ')
          ..write('juntaId: $juntaId, ')
          ..write('participanteId: $participanteId, ')
          ..write('numero: $numero, ')
          ..write('fechaProgramada: $fechaProgramada, ')
          ..write('estado: $estado, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    juntaId,
    participanteId,
    numero,
    fechaProgramada,
    estado,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TurnosLocale &&
          other.id == this.id &&
          other.juntaId == this.juntaId &&
          other.participanteId == this.participanteId &&
          other.numero == this.numero &&
          other.fechaProgramada == this.fechaProgramada &&
          other.estado == this.estado &&
          other.actualizadoEn == this.actualizadoEn);
}

class TurnosLocalesCompanion extends UpdateCompanion<TurnosLocale> {
  final Value<String> id;
  final Value<String> juntaId;
  final Value<String> participanteId;
  final Value<int> numero;
  final Value<DateTime> fechaProgramada;
  final Value<String> estado;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const TurnosLocalesCompanion({
    this.id = const Value.absent(),
    this.juntaId = const Value.absent(),
    this.participanteId = const Value.absent(),
    this.numero = const Value.absent(),
    this.fechaProgramada = const Value.absent(),
    this.estado = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TurnosLocalesCompanion.insert({
    required String id,
    required String juntaId,
    required String participanteId,
    required int numero,
    required DateTime fechaProgramada,
    required String estado,
    required DateTime actualizadoEn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       juntaId = Value(juntaId),
       participanteId = Value(participanteId),
       numero = Value(numero),
       fechaProgramada = Value(fechaProgramada),
       estado = Value(estado),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<TurnosLocale> custom({
    Expression<String>? id,
    Expression<String>? juntaId,
    Expression<String>? participanteId,
    Expression<int>? numero,
    Expression<DateTime>? fechaProgramada,
    Expression<String>? estado,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (juntaId != null) 'junta_id': juntaId,
      if (participanteId != null) 'participante_id': participanteId,
      if (numero != null) 'numero': numero,
      if (fechaProgramada != null) 'fecha_programada': fechaProgramada,
      if (estado != null) 'estado': estado,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TurnosLocalesCompanion copyWith({
    Value<String>? id,
    Value<String>? juntaId,
    Value<String>? participanteId,
    Value<int>? numero,
    Value<DateTime>? fechaProgramada,
    Value<String>? estado,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return TurnosLocalesCompanion(
      id: id ?? this.id,
      juntaId: juntaId ?? this.juntaId,
      participanteId: participanteId ?? this.participanteId,
      numero: numero ?? this.numero,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      estado: estado ?? this.estado,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (juntaId.present) {
      map['junta_id'] = Variable<String>(juntaId.value);
    }
    if (participanteId.present) {
      map['participante_id'] = Variable<String>(participanteId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (fechaProgramada.present) {
      map['fecha_programada'] = Variable<DateTime>(fechaProgramada.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TurnosLocalesCompanion(')
          ..write('id: $id, ')
          ..write('juntaId: $juntaId, ')
          ..write('participanteId: $participanteId, ')
          ..write('numero: $numero, ')
          ..write('fechaProgramada: $fechaProgramada, ')
          ..write('estado: $estado, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AportesLocalesTable extends AportesLocales
    with TableInfo<$AportesLocalesTable, AportesLocale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AportesLocalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juntaIdMeta = const VerificationMeta(
    'juntaId',
  );
  @override
  late final GeneratedColumn<String> juntaId = GeneratedColumn<String>(
    'junta_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnoIdMeta = const VerificationMeta(
    'turnoId',
  );
  @override
  late final GeneratedColumn<String> turnoId = GeneratedColumn<String>(
    'turno_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _participanteIdMeta = const VerificationMeta(
    'participanteId',
  );
  @override
  late final GeneratedColumn<String> participanteId = GeneratedColumn<String>(
    'participante_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  @override
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pagadoEnMeta = const VerificationMeta(
    'pagadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> pagadoEn = GeneratedColumn<DateTime>(
    'pagado_en',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voucherPathMeta = const VerificationMeta(
    'voucherPath',
  );
  @override
  late final GeneratedColumn<String> voucherPath = GeneratedColumn<String>(
    'voucher_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    juntaId,
    turnoId,
    participanteId,
    montoCentavos,
    estado,
    pagadoEn,
    voucherPath,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'aportes_locales';
  @override
  VerificationContext validateIntegrity(
    Insertable<AportesLocale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('junta_id')) {
      context.handle(
        _juntaIdMeta,
        juntaId.isAcceptableOrUnknown(data['junta_id']!, _juntaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_juntaIdMeta);
    }
    if (data.containsKey('turno_id')) {
      context.handle(
        _turnoIdMeta,
        turnoId.isAcceptableOrUnknown(data['turno_id']!, _turnoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_turnoIdMeta);
    }
    if (data.containsKey('participante_id')) {
      context.handle(
        _participanteIdMeta,
        participanteId.isAcceptableOrUnknown(
          data['participante_id']!,
          _participanteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participanteIdMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('pagado_en')) {
      context.handle(
        _pagadoEnMeta,
        pagadoEn.isAcceptableOrUnknown(data['pagado_en']!, _pagadoEnMeta),
      );
    }
    if (data.containsKey('voucher_path')) {
      context.handle(
        _voucherPathMeta,
        voucherPath.isAcceptableOrUnknown(
          data['voucher_path']!,
          _voucherPathMeta,
        ),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AportesLocale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AportesLocale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      juntaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}junta_id'],
      )!,
      turnoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}turno_id'],
      )!,
      participanteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participante_id'],
      )!,
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      pagadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pagado_en'],
      ),
      voucherPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voucher_path'],
      ),
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $AportesLocalesTable createAlias(String alias) {
    return $AportesLocalesTable(attachedDatabase, alias);
  }
}

class AportesLocale extends DataClass implements Insertable<AportesLocale> {
  final String id;
  final String juntaId;
  final String turnoId;
  final String participanteId;
  final int montoCentavos;
  final String estado;
  final DateTime? pagadoEn;
  final String? voucherPath;
  final DateTime actualizadoEn;
  const AportesLocale({
    required this.id,
    required this.juntaId,
    required this.turnoId,
    required this.participanteId,
    required this.montoCentavos,
    required this.estado,
    this.pagadoEn,
    this.voucherPath,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['junta_id'] = Variable<String>(juntaId);
    map['turno_id'] = Variable<String>(turnoId);
    map['participante_id'] = Variable<String>(participanteId);
    map['monto_centavos'] = Variable<int>(montoCentavos);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || pagadoEn != null) {
      map['pagado_en'] = Variable<DateTime>(pagadoEn);
    }
    if (!nullToAbsent || voucherPath != null) {
      map['voucher_path'] = Variable<String>(voucherPath);
    }
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  AportesLocalesCompanion toCompanion(bool nullToAbsent) {
    return AportesLocalesCompanion(
      id: Value(id),
      juntaId: Value(juntaId),
      turnoId: Value(turnoId),
      participanteId: Value(participanteId),
      montoCentavos: Value(montoCentavos),
      estado: Value(estado),
      pagadoEn: pagadoEn == null && nullToAbsent
          ? const Value.absent()
          : Value(pagadoEn),
      voucherPath: voucherPath == null && nullToAbsent
          ? const Value.absent()
          : Value(voucherPath),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory AportesLocale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AportesLocale(
      id: serializer.fromJson<String>(json['id']),
      juntaId: serializer.fromJson<String>(json['juntaId']),
      turnoId: serializer.fromJson<String>(json['turnoId']),
      participanteId: serializer.fromJson<String>(json['participanteId']),
      montoCentavos: serializer.fromJson<int>(json['montoCentavos']),
      estado: serializer.fromJson<String>(json['estado']),
      pagadoEn: serializer.fromJson<DateTime?>(json['pagadoEn']),
      voucherPath: serializer.fromJson<String?>(json['voucherPath']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'juntaId': serializer.toJson<String>(juntaId),
      'turnoId': serializer.toJson<String>(turnoId),
      'participanteId': serializer.toJson<String>(participanteId),
      'montoCentavos': serializer.toJson<int>(montoCentavos),
      'estado': serializer.toJson<String>(estado),
      'pagadoEn': serializer.toJson<DateTime?>(pagadoEn),
      'voucherPath': serializer.toJson<String?>(voucherPath),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  AportesLocale copyWith({
    String? id,
    String? juntaId,
    String? turnoId,
    String? participanteId,
    int? montoCentavos,
    String? estado,
    Value<DateTime?> pagadoEn = const Value.absent(),
    Value<String?> voucherPath = const Value.absent(),
    DateTime? actualizadoEn,
  }) => AportesLocale(
    id: id ?? this.id,
    juntaId: juntaId ?? this.juntaId,
    turnoId: turnoId ?? this.turnoId,
    participanteId: participanteId ?? this.participanteId,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    estado: estado ?? this.estado,
    pagadoEn: pagadoEn.present ? pagadoEn.value : this.pagadoEn,
    voucherPath: voucherPath.present ? voucherPath.value : this.voucherPath,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  AportesLocale copyWithCompanion(AportesLocalesCompanion data) {
    return AportesLocale(
      id: data.id.present ? data.id.value : this.id,
      juntaId: data.juntaId.present ? data.juntaId.value : this.juntaId,
      turnoId: data.turnoId.present ? data.turnoId.value : this.turnoId,
      participanteId: data.participanteId.present
          ? data.participanteId.value
          : this.participanteId,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      estado: data.estado.present ? data.estado.value : this.estado,
      pagadoEn: data.pagadoEn.present ? data.pagadoEn.value : this.pagadoEn,
      voucherPath: data.voucherPath.present
          ? data.voucherPath.value
          : this.voucherPath,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AportesLocale(')
          ..write('id: $id, ')
          ..write('juntaId: $juntaId, ')
          ..write('turnoId: $turnoId, ')
          ..write('participanteId: $participanteId, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('estado: $estado, ')
          ..write('pagadoEn: $pagadoEn, ')
          ..write('voucherPath: $voucherPath, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    juntaId,
    turnoId,
    participanteId,
    montoCentavos,
    estado,
    pagadoEn,
    voucherPath,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AportesLocale &&
          other.id == this.id &&
          other.juntaId == this.juntaId &&
          other.turnoId == this.turnoId &&
          other.participanteId == this.participanteId &&
          other.montoCentavos == this.montoCentavos &&
          other.estado == this.estado &&
          other.pagadoEn == this.pagadoEn &&
          other.voucherPath == this.voucherPath &&
          other.actualizadoEn == this.actualizadoEn);
}

class AportesLocalesCompanion extends UpdateCompanion<AportesLocale> {
  final Value<String> id;
  final Value<String> juntaId;
  final Value<String> turnoId;
  final Value<String> participanteId;
  final Value<int> montoCentavos;
  final Value<String> estado;
  final Value<DateTime?> pagadoEn;
  final Value<String?> voucherPath;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const AportesLocalesCompanion({
    this.id = const Value.absent(),
    this.juntaId = const Value.absent(),
    this.turnoId = const Value.absent(),
    this.participanteId = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.estado = const Value.absent(),
    this.pagadoEn = const Value.absent(),
    this.voucherPath = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AportesLocalesCompanion.insert({
    required String id,
    required String juntaId,
    required String turnoId,
    required String participanteId,
    required int montoCentavos,
    required String estado,
    this.pagadoEn = const Value.absent(),
    this.voucherPath = const Value.absent(),
    required DateTime actualizadoEn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       juntaId = Value(juntaId),
       turnoId = Value(turnoId),
       participanteId = Value(participanteId),
       montoCentavos = Value(montoCentavos),
       estado = Value(estado),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<AportesLocale> custom({
    Expression<String>? id,
    Expression<String>? juntaId,
    Expression<String>? turnoId,
    Expression<String>? participanteId,
    Expression<int>? montoCentavos,
    Expression<String>? estado,
    Expression<DateTime>? pagadoEn,
    Expression<String>? voucherPath,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (juntaId != null) 'junta_id': juntaId,
      if (turnoId != null) 'turno_id': turnoId,
      if (participanteId != null) 'participante_id': participanteId,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (estado != null) 'estado': estado,
      if (pagadoEn != null) 'pagado_en': pagadoEn,
      if (voucherPath != null) 'voucher_path': voucherPath,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AportesLocalesCompanion copyWith({
    Value<String>? id,
    Value<String>? juntaId,
    Value<String>? turnoId,
    Value<String>? participanteId,
    Value<int>? montoCentavos,
    Value<String>? estado,
    Value<DateTime?>? pagadoEn,
    Value<String?>? voucherPath,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return AportesLocalesCompanion(
      id: id ?? this.id,
      juntaId: juntaId ?? this.juntaId,
      turnoId: turnoId ?? this.turnoId,
      participanteId: participanteId ?? this.participanteId,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      estado: estado ?? this.estado,
      pagadoEn: pagadoEn ?? this.pagadoEn,
      voucherPath: voucherPath ?? this.voucherPath,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (juntaId.present) {
      map['junta_id'] = Variable<String>(juntaId.value);
    }
    if (turnoId.present) {
      map['turno_id'] = Variable<String>(turnoId.value);
    }
    if (participanteId.present) {
      map['participante_id'] = Variable<String>(participanteId.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (pagadoEn.present) {
      map['pagado_en'] = Variable<DateTime>(pagadoEn.value);
    }
    if (voucherPath.present) {
      map['voucher_path'] = Variable<String>(voucherPath.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AportesLocalesCompanion(')
          ..write('id: $id, ')
          ..write('juntaId: $juntaId, ')
          ..write('turnoId: $turnoId, ')
          ..write('participanteId: $participanteId, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('estado: $estado, ')
          ..write('pagadoEn: $pagadoEn, ')
          ..write('voucherPath: $voucherPath, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CambiosPendientesTable extends CambiosPendientes
    with TableInfo<$CambiosPendientesTable, CambiosPendiente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CambiosPendientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tablaMeta = const VerificationMeta('tabla');
  @override
  late final GeneratedColumn<String> tabla = GeneratedColumn<String>(
    'tabla',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filaIdMeta = const VerificationMeta('filaId');
  @override
  late final GeneratedColumn<String> filaId = GeneratedColumn<String>(
    'fila_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operacionMeta = const VerificationMeta(
    'operacion',
  );
  @override
  late final GeneratedColumn<String> operacion = GeneratedColumn<String>(
    'operacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datosMeta = const VerificationMeta('datos');
  @override
  late final GeneratedColumn<String> datos = GeneratedColumn<String>(
    'datos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intentosMeta = const VerificationMeta(
    'intentos',
  );
  @override
  late final GeneratedColumn<int> intentos = GeneratedColumn<int>(
    'intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ultimoErrorMeta = const VerificationMeta(
    'ultimoError',
  );
  @override
  late final GeneratedColumn<String> ultimoError = GeneratedColumn<String>(
    'ultimo_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tabla,
    filaId,
    operacion,
    datos,
    creadoEn,
    intentos,
    ultimoError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cambios_pendientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CambiosPendiente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tabla')) {
      context.handle(
        _tablaMeta,
        tabla.isAcceptableOrUnknown(data['tabla']!, _tablaMeta),
      );
    } else if (isInserting) {
      context.missing(_tablaMeta);
    }
    if (data.containsKey('fila_id')) {
      context.handle(
        _filaIdMeta,
        filaId.isAcceptableOrUnknown(data['fila_id']!, _filaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_filaIdMeta);
    }
    if (data.containsKey('operacion')) {
      context.handle(
        _operacionMeta,
        operacion.isAcceptableOrUnknown(data['operacion']!, _operacionMeta),
      );
    } else if (isInserting) {
      context.missing(_operacionMeta);
    }
    if (data.containsKey('datos')) {
      context.handle(
        _datosMeta,
        datos.isAcceptableOrUnknown(data['datos']!, _datosMeta),
      );
    } else if (isInserting) {
      context.missing(_datosMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('intentos')) {
      context.handle(
        _intentosMeta,
        intentos.isAcceptableOrUnknown(data['intentos']!, _intentosMeta),
      );
    }
    if (data.containsKey('ultimo_error')) {
      context.handle(
        _ultimoErrorMeta,
        ultimoError.isAcceptableOrUnknown(
          data['ultimo_error']!,
          _ultimoErrorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CambiosPendiente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CambiosPendiente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tabla: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tabla'],
      )!,
      filaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fila_id'],
      )!,
      operacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operacion'],
      )!,
      datos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datos'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      intentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intentos'],
      )!,
      ultimoError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ultimo_error'],
      ),
    );
  }

  @override
  $CambiosPendientesTable createAlias(String alias) {
    return $CambiosPendientesTable(attachedDatabase, alias);
  }
}

class CambiosPendiente extends DataClass
    implements Insertable<CambiosPendiente> {
  final int id;

  /// Nombre de la tabla en Postgres: juntas, participantes, turnos, aportes.
  final String tabla;
  final String filaId;

  /// `insertar`, `actualizar` o `borrar`.
  final String operacion;

  /// El cuerpo que se manda, ya en JSON con los nombres de Postgres.
  final String datos;
  final DateTime creadoEn;
  final int intentos;
  final String? ultimoError;
  const CambiosPendiente({
    required this.id,
    required this.tabla,
    required this.filaId,
    required this.operacion,
    required this.datos,
    required this.creadoEn,
    required this.intentos,
    this.ultimoError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tabla'] = Variable<String>(tabla);
    map['fila_id'] = Variable<String>(filaId);
    map['operacion'] = Variable<String>(operacion);
    map['datos'] = Variable<String>(datos);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['intentos'] = Variable<int>(intentos);
    if (!nullToAbsent || ultimoError != null) {
      map['ultimo_error'] = Variable<String>(ultimoError);
    }
    return map;
  }

  CambiosPendientesCompanion toCompanion(bool nullToAbsent) {
    return CambiosPendientesCompanion(
      id: Value(id),
      tabla: Value(tabla),
      filaId: Value(filaId),
      operacion: Value(operacion),
      datos: Value(datos),
      creadoEn: Value(creadoEn),
      intentos: Value(intentos),
      ultimoError: ultimoError == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimoError),
    );
  }

  factory CambiosPendiente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CambiosPendiente(
      id: serializer.fromJson<int>(json['id']),
      tabla: serializer.fromJson<String>(json['tabla']),
      filaId: serializer.fromJson<String>(json['filaId']),
      operacion: serializer.fromJson<String>(json['operacion']),
      datos: serializer.fromJson<String>(json['datos']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      intentos: serializer.fromJson<int>(json['intentos']),
      ultimoError: serializer.fromJson<String?>(json['ultimoError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tabla': serializer.toJson<String>(tabla),
      'filaId': serializer.toJson<String>(filaId),
      'operacion': serializer.toJson<String>(operacion),
      'datos': serializer.toJson<String>(datos),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'intentos': serializer.toJson<int>(intentos),
      'ultimoError': serializer.toJson<String?>(ultimoError),
    };
  }

  CambiosPendiente copyWith({
    int? id,
    String? tabla,
    String? filaId,
    String? operacion,
    String? datos,
    DateTime? creadoEn,
    int? intentos,
    Value<String?> ultimoError = const Value.absent(),
  }) => CambiosPendiente(
    id: id ?? this.id,
    tabla: tabla ?? this.tabla,
    filaId: filaId ?? this.filaId,
    operacion: operacion ?? this.operacion,
    datos: datos ?? this.datos,
    creadoEn: creadoEn ?? this.creadoEn,
    intentos: intentos ?? this.intentos,
    ultimoError: ultimoError.present ? ultimoError.value : this.ultimoError,
  );
  CambiosPendiente copyWithCompanion(CambiosPendientesCompanion data) {
    return CambiosPendiente(
      id: data.id.present ? data.id.value : this.id,
      tabla: data.tabla.present ? data.tabla.value : this.tabla,
      filaId: data.filaId.present ? data.filaId.value : this.filaId,
      operacion: data.operacion.present ? data.operacion.value : this.operacion,
      datos: data.datos.present ? data.datos.value : this.datos,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      intentos: data.intentos.present ? data.intentos.value : this.intentos,
      ultimoError: data.ultimoError.present
          ? data.ultimoError.value
          : this.ultimoError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CambiosPendiente(')
          ..write('id: $id, ')
          ..write('tabla: $tabla, ')
          ..write('filaId: $filaId, ')
          ..write('operacion: $operacion, ')
          ..write('datos: $datos, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('intentos: $intentos, ')
          ..write('ultimoError: $ultimoError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tabla,
    filaId,
    operacion,
    datos,
    creadoEn,
    intentos,
    ultimoError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CambiosPendiente &&
          other.id == this.id &&
          other.tabla == this.tabla &&
          other.filaId == this.filaId &&
          other.operacion == this.operacion &&
          other.datos == this.datos &&
          other.creadoEn == this.creadoEn &&
          other.intentos == this.intentos &&
          other.ultimoError == this.ultimoError);
}

class CambiosPendientesCompanion extends UpdateCompanion<CambiosPendiente> {
  final Value<int> id;
  final Value<String> tabla;
  final Value<String> filaId;
  final Value<String> operacion;
  final Value<String> datos;
  final Value<DateTime> creadoEn;
  final Value<int> intentos;
  final Value<String?> ultimoError;
  const CambiosPendientesCompanion({
    this.id = const Value.absent(),
    this.tabla = const Value.absent(),
    this.filaId = const Value.absent(),
    this.operacion = const Value.absent(),
    this.datos = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.intentos = const Value.absent(),
    this.ultimoError = const Value.absent(),
  });
  CambiosPendientesCompanion.insert({
    this.id = const Value.absent(),
    required String tabla,
    required String filaId,
    required String operacion,
    required String datos,
    required DateTime creadoEn,
    this.intentos = const Value.absent(),
    this.ultimoError = const Value.absent(),
  }) : tabla = Value(tabla),
       filaId = Value(filaId),
       operacion = Value(operacion),
       datos = Value(datos),
       creadoEn = Value(creadoEn);
  static Insertable<CambiosPendiente> custom({
    Expression<int>? id,
    Expression<String>? tabla,
    Expression<String>? filaId,
    Expression<String>? operacion,
    Expression<String>? datos,
    Expression<DateTime>? creadoEn,
    Expression<int>? intentos,
    Expression<String>? ultimoError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tabla != null) 'tabla': tabla,
      if (filaId != null) 'fila_id': filaId,
      if (operacion != null) 'operacion': operacion,
      if (datos != null) 'datos': datos,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (intentos != null) 'intentos': intentos,
      if (ultimoError != null) 'ultimo_error': ultimoError,
    });
  }

  CambiosPendientesCompanion copyWith({
    Value<int>? id,
    Value<String>? tabla,
    Value<String>? filaId,
    Value<String>? operacion,
    Value<String>? datos,
    Value<DateTime>? creadoEn,
    Value<int>? intentos,
    Value<String?>? ultimoError,
  }) {
    return CambiosPendientesCompanion(
      id: id ?? this.id,
      tabla: tabla ?? this.tabla,
      filaId: filaId ?? this.filaId,
      operacion: operacion ?? this.operacion,
      datos: datos ?? this.datos,
      creadoEn: creadoEn ?? this.creadoEn,
      intentos: intentos ?? this.intentos,
      ultimoError: ultimoError ?? this.ultimoError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tabla.present) {
      map['tabla'] = Variable<String>(tabla.value);
    }
    if (filaId.present) {
      map['fila_id'] = Variable<String>(filaId.value);
    }
    if (operacion.present) {
      map['operacion'] = Variable<String>(operacion.value);
    }
    if (datos.present) {
      map['datos'] = Variable<String>(datos.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (intentos.present) {
      map['intentos'] = Variable<int>(intentos.value);
    }
    if (ultimoError.present) {
      map['ultimo_error'] = Variable<String>(ultimoError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CambiosPendientesCompanion(')
          ..write('id: $id, ')
          ..write('tabla: $tabla, ')
          ..write('filaId: $filaId, ')
          ..write('operacion: $operacion, ')
          ..write('datos: $datos, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('intentos: $intentos, ')
          ..write('ultimoError: $ultimoError')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseLocal extends GeneratedDatabase {
  _$BaseLocal(QueryExecutor e) : super(e);
  $BaseLocalManager get managers => $BaseLocalManager(this);
  late final $JuntasLocalesTable juntasLocales = $JuntasLocalesTable(this);
  late final $ParticipantesLocalesTable participantesLocales =
      $ParticipantesLocalesTable(this);
  late final $TurnosLocalesTable turnosLocales = $TurnosLocalesTable(this);
  late final $AportesLocalesTable aportesLocales = $AportesLocalesTable(this);
  late final $CambiosPendientesTable cambiosPendientes =
      $CambiosPendientesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    juntasLocales,
    participantesLocales,
    turnosLocales,
    aportesLocales,
    cambiosPendientes,
  ];
}

typedef $$JuntasLocalesTableCreateCompanionBuilder =
    JuntasLocalesCompanion Function({
      required String id,
      required String cabezaId,
      required String nombre,
      required String codigo,
      required int montoAporteCentavos,
      required String frecuencia,
      required DateTime fechaInicio,
      required String estado,
      required DateTime actualizadoEn,
      Value<int> rowid,
    });
typedef $$JuntasLocalesTableUpdateCompanionBuilder =
    JuntasLocalesCompanion Function({
      Value<String> id,
      Value<String> cabezaId,
      Value<String> nombre,
      Value<String> codigo,
      Value<int> montoAporteCentavos,
      Value<String> frecuencia,
      Value<DateTime> fechaInicio,
      Value<String> estado,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$JuntasLocalesTableFilterComposer
    extends Composer<_$BaseLocal, $JuntasLocalesTable> {
  $$JuntasLocalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cabezaId => $composableBuilder(
    column: $table.cabezaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoAporteCentavos => $composableBuilder(
    column: $table.montoAporteCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JuntasLocalesTableOrderingComposer
    extends Composer<_$BaseLocal, $JuntasLocalesTable> {
  $$JuntasLocalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cabezaId => $composableBuilder(
    column: $table.cabezaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoAporteCentavos => $composableBuilder(
    column: $table.montoAporteCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JuntasLocalesTableAnnotationComposer
    extends Composer<_$BaseLocal, $JuntasLocalesTable> {
  $$JuntasLocalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cabezaId =>
      $composableBuilder(column: $table.cabezaId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<int> get montoAporteCentavos => $composableBuilder(
    column: $table.montoAporteCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$JuntasLocalesTableTableManager
    extends
        RootTableManager<
          _$BaseLocal,
          $JuntasLocalesTable,
          JuntasLocale,
          $$JuntasLocalesTableFilterComposer,
          $$JuntasLocalesTableOrderingComposer,
          $$JuntasLocalesTableAnnotationComposer,
          $$JuntasLocalesTableCreateCompanionBuilder,
          $$JuntasLocalesTableUpdateCompanionBuilder,
          (
            JuntasLocale,
            BaseReferences<_$BaseLocal, $JuntasLocalesTable, JuntasLocale>,
          ),
          JuntasLocale,
          PrefetchHooks Function()
        > {
  $$JuntasLocalesTableTableManager(_$BaseLocal db, $JuntasLocalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JuntasLocalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JuntasLocalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JuntasLocalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cabezaId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<int> montoAporteCentavos = const Value.absent(),
                Value<String> frecuencia = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JuntasLocalesCompanion(
                id: id,
                cabezaId: cabezaId,
                nombre: nombre,
                codigo: codigo,
                montoAporteCentavos: montoAporteCentavos,
                frecuencia: frecuencia,
                fechaInicio: fechaInicio,
                estado: estado,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cabezaId,
                required String nombre,
                required String codigo,
                required int montoAporteCentavos,
                required String frecuencia,
                required DateTime fechaInicio,
                required String estado,
                required DateTime actualizadoEn,
                Value<int> rowid = const Value.absent(),
              }) => JuntasLocalesCompanion.insert(
                id: id,
                cabezaId: cabezaId,
                nombre: nombre,
                codigo: codigo,
                montoAporteCentavos: montoAporteCentavos,
                frecuencia: frecuencia,
                fechaInicio: fechaInicio,
                estado: estado,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JuntasLocalesTable, JuntasLocale>(table),
                  BaseReferences<
                    _$BaseLocal,
                    $JuntasLocalesTable,
                    JuntasLocale
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JuntasLocalesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocal,
      $JuntasLocalesTable,
      JuntasLocale,
      $$JuntasLocalesTableFilterComposer,
      $$JuntasLocalesTableOrderingComposer,
      $$JuntasLocalesTableAnnotationComposer,
      $$JuntasLocalesTableCreateCompanionBuilder,
      $$JuntasLocalesTableUpdateCompanionBuilder,
      (
        JuntasLocale,
        BaseReferences<_$BaseLocal, $JuntasLocalesTable, JuntasLocale>,
      ),
      JuntasLocale,
      PrefetchHooks Function()
    >;
typedef $$ParticipantesLocalesTableCreateCompanionBuilder =
    ParticipantesLocalesCompanion Function({
      required String id,
      required String juntaId,
      required String nombre,
      Value<String?> telefono,
      required int ordenTurno,
      Value<bool> activo,
      required DateTime actualizadoEn,
      Value<int> rowid,
    });
typedef $$ParticipantesLocalesTableUpdateCompanionBuilder =
    ParticipantesLocalesCompanion Function({
      Value<String> id,
      Value<String> juntaId,
      Value<String> nombre,
      Value<String?> telefono,
      Value<int> ordenTurno,
      Value<bool> activo,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$ParticipantesLocalesTableFilterComposer
    extends Composer<_$BaseLocal, $ParticipantesLocalesTable> {
  $$ParticipantesLocalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get juntaId => $composableBuilder(
    column: $table.juntaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordenTurno => $composableBuilder(
    column: $table.ordenTurno,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParticipantesLocalesTableOrderingComposer
    extends Composer<_$BaseLocal, $ParticipantesLocalesTable> {
  $$ParticipantesLocalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get juntaId => $composableBuilder(
    column: $table.juntaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordenTurno => $composableBuilder(
    column: $table.ordenTurno,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParticipantesLocalesTableAnnotationComposer
    extends Composer<_$BaseLocal, $ParticipantesLocalesTable> {
  $$ParticipantesLocalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get juntaId =>
      $composableBuilder(column: $table.juntaId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<int> get ordenTurno => $composableBuilder(
    column: $table.ordenTurno,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$ParticipantesLocalesTableTableManager
    extends
        RootTableManager<
          _$BaseLocal,
          $ParticipantesLocalesTable,
          ParticipantesLocale,
          $$ParticipantesLocalesTableFilterComposer,
          $$ParticipantesLocalesTableOrderingComposer,
          $$ParticipantesLocalesTableAnnotationComposer,
          $$ParticipantesLocalesTableCreateCompanionBuilder,
          $$ParticipantesLocalesTableUpdateCompanionBuilder,
          (
            ParticipantesLocale,
            BaseReferences<
              _$BaseLocal,
              $ParticipantesLocalesTable,
              ParticipantesLocale
            >,
          ),
          ParticipantesLocale,
          PrefetchHooks Function()
        > {
  $$ParticipantesLocalesTableTableManager(
    _$BaseLocal db,
    $ParticipantesLocalesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParticipantesLocalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParticipantesLocalesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ParticipantesLocalesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> juntaId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<int> ordenTurno = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParticipantesLocalesCompanion(
                id: id,
                juntaId: juntaId,
                nombre: nombre,
                telefono: telefono,
                ordenTurno: ordenTurno,
                activo: activo,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String juntaId,
                required String nombre,
                Value<String?> telefono = const Value.absent(),
                required int ordenTurno,
                Value<bool> activo = const Value.absent(),
                required DateTime actualizadoEn,
                Value<int> rowid = const Value.absent(),
              }) => ParticipantesLocalesCompanion.insert(
                id: id,
                juntaId: juntaId,
                nombre: nombre,
                telefono: telefono,
                ordenTurno: ordenTurno,
                activo: activo,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ParticipantesLocalesTable, ParticipantesLocale>(
                    table,
                  ),
                  BaseReferences<
                    _$BaseLocal,
                    $ParticipantesLocalesTable,
                    ParticipantesLocale
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParticipantesLocalesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocal,
      $ParticipantesLocalesTable,
      ParticipantesLocale,
      $$ParticipantesLocalesTableFilterComposer,
      $$ParticipantesLocalesTableOrderingComposer,
      $$ParticipantesLocalesTableAnnotationComposer,
      $$ParticipantesLocalesTableCreateCompanionBuilder,
      $$ParticipantesLocalesTableUpdateCompanionBuilder,
      (
        ParticipantesLocale,
        BaseReferences<
          _$BaseLocal,
          $ParticipantesLocalesTable,
          ParticipantesLocale
        >,
      ),
      ParticipantesLocale,
      PrefetchHooks Function()
    >;
typedef $$TurnosLocalesTableCreateCompanionBuilder =
    TurnosLocalesCompanion Function({
      required String id,
      required String juntaId,
      required String participanteId,
      required int numero,
      required DateTime fechaProgramada,
      required String estado,
      required DateTime actualizadoEn,
      Value<int> rowid,
    });
typedef $$TurnosLocalesTableUpdateCompanionBuilder =
    TurnosLocalesCompanion Function({
      Value<String> id,
      Value<String> juntaId,
      Value<String> participanteId,
      Value<int> numero,
      Value<DateTime> fechaProgramada,
      Value<String> estado,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$TurnosLocalesTableFilterComposer
    extends Composer<_$BaseLocal, $TurnosLocalesTable> {
  $$TurnosLocalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get juntaId => $composableBuilder(
    column: $table.juntaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get participanteId => $composableBuilder(
    column: $table.participanteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TurnosLocalesTableOrderingComposer
    extends Composer<_$BaseLocal, $TurnosLocalesTable> {
  $$TurnosLocalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get juntaId => $composableBuilder(
    column: $table.juntaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get participanteId => $composableBuilder(
    column: $table.participanteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TurnosLocalesTableAnnotationComposer
    extends Composer<_$BaseLocal, $TurnosLocalesTable> {
  $$TurnosLocalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get juntaId =>
      $composableBuilder(column: $table.juntaId, builder: (column) => column);

  GeneratedColumn<String> get participanteId => $composableBuilder(
    column: $table.participanteId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaProgramada => $composableBuilder(
    column: $table.fechaProgramada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$TurnosLocalesTableTableManager
    extends
        RootTableManager<
          _$BaseLocal,
          $TurnosLocalesTable,
          TurnosLocale,
          $$TurnosLocalesTableFilterComposer,
          $$TurnosLocalesTableOrderingComposer,
          $$TurnosLocalesTableAnnotationComposer,
          $$TurnosLocalesTableCreateCompanionBuilder,
          $$TurnosLocalesTableUpdateCompanionBuilder,
          (
            TurnosLocale,
            BaseReferences<_$BaseLocal, $TurnosLocalesTable, TurnosLocale>,
          ),
          TurnosLocale,
          PrefetchHooks Function()
        > {
  $$TurnosLocalesTableTableManager(_$BaseLocal db, $TurnosLocalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TurnosLocalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TurnosLocalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TurnosLocalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> juntaId = const Value.absent(),
                Value<String> participanteId = const Value.absent(),
                Value<int> numero = const Value.absent(),
                Value<DateTime> fechaProgramada = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TurnosLocalesCompanion(
                id: id,
                juntaId: juntaId,
                participanteId: participanteId,
                numero: numero,
                fechaProgramada: fechaProgramada,
                estado: estado,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String juntaId,
                required String participanteId,
                required int numero,
                required DateTime fechaProgramada,
                required String estado,
                required DateTime actualizadoEn,
                Value<int> rowid = const Value.absent(),
              }) => TurnosLocalesCompanion.insert(
                id: id,
                juntaId: juntaId,
                participanteId: participanteId,
                numero: numero,
                fechaProgramada: fechaProgramada,
                estado: estado,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TurnosLocalesTable, TurnosLocale>(table),
                  BaseReferences<
                    _$BaseLocal,
                    $TurnosLocalesTable,
                    TurnosLocale
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TurnosLocalesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocal,
      $TurnosLocalesTable,
      TurnosLocale,
      $$TurnosLocalesTableFilterComposer,
      $$TurnosLocalesTableOrderingComposer,
      $$TurnosLocalesTableAnnotationComposer,
      $$TurnosLocalesTableCreateCompanionBuilder,
      $$TurnosLocalesTableUpdateCompanionBuilder,
      (
        TurnosLocale,
        BaseReferences<_$BaseLocal, $TurnosLocalesTable, TurnosLocale>,
      ),
      TurnosLocale,
      PrefetchHooks Function()
    >;
typedef $$AportesLocalesTableCreateCompanionBuilder =
    AportesLocalesCompanion Function({
      required String id,
      required String juntaId,
      required String turnoId,
      required String participanteId,
      required int montoCentavos,
      required String estado,
      Value<DateTime?> pagadoEn,
      Value<String?> voucherPath,
      required DateTime actualizadoEn,
      Value<int> rowid,
    });
typedef $$AportesLocalesTableUpdateCompanionBuilder =
    AportesLocalesCompanion Function({
      Value<String> id,
      Value<String> juntaId,
      Value<String> turnoId,
      Value<String> participanteId,
      Value<int> montoCentavos,
      Value<String> estado,
      Value<DateTime?> pagadoEn,
      Value<String?> voucherPath,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$AportesLocalesTableFilterComposer
    extends Composer<_$BaseLocal, $AportesLocalesTable> {
  $$AportesLocalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get juntaId => $composableBuilder(
    column: $table.juntaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get turnoId => $composableBuilder(
    column: $table.turnoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get participanteId => $composableBuilder(
    column: $table.participanteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pagadoEn => $composableBuilder(
    column: $table.pagadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voucherPath => $composableBuilder(
    column: $table.voucherPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AportesLocalesTableOrderingComposer
    extends Composer<_$BaseLocal, $AportesLocalesTable> {
  $$AportesLocalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get juntaId => $composableBuilder(
    column: $table.juntaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get turnoId => $composableBuilder(
    column: $table.turnoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get participanteId => $composableBuilder(
    column: $table.participanteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pagadoEn => $composableBuilder(
    column: $table.pagadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voucherPath => $composableBuilder(
    column: $table.voucherPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AportesLocalesTableAnnotationComposer
    extends Composer<_$BaseLocal, $AportesLocalesTable> {
  $$AportesLocalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get juntaId =>
      $composableBuilder(column: $table.juntaId, builder: (column) => column);

  GeneratedColumn<String> get turnoId =>
      $composableBuilder(column: $table.turnoId, builder: (column) => column);

  GeneratedColumn<String> get participanteId => $composableBuilder(
    column: $table.participanteId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get pagadoEn =>
      $composableBuilder(column: $table.pagadoEn, builder: (column) => column);

  GeneratedColumn<String> get voucherPath => $composableBuilder(
    column: $table.voucherPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$AportesLocalesTableTableManager
    extends
        RootTableManager<
          _$BaseLocal,
          $AportesLocalesTable,
          AportesLocale,
          $$AportesLocalesTableFilterComposer,
          $$AportesLocalesTableOrderingComposer,
          $$AportesLocalesTableAnnotationComposer,
          $$AportesLocalesTableCreateCompanionBuilder,
          $$AportesLocalesTableUpdateCompanionBuilder,
          (
            AportesLocale,
            BaseReferences<_$BaseLocal, $AportesLocalesTable, AportesLocale>,
          ),
          AportesLocale,
          PrefetchHooks Function()
        > {
  $$AportesLocalesTableTableManager(_$BaseLocal db, $AportesLocalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AportesLocalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AportesLocalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AportesLocalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> juntaId = const Value.absent(),
                Value<String> turnoId = const Value.absent(),
                Value<String> participanteId = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime?> pagadoEn = const Value.absent(),
                Value<String?> voucherPath = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AportesLocalesCompanion(
                id: id,
                juntaId: juntaId,
                turnoId: turnoId,
                participanteId: participanteId,
                montoCentavos: montoCentavos,
                estado: estado,
                pagadoEn: pagadoEn,
                voucherPath: voucherPath,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String juntaId,
                required String turnoId,
                required String participanteId,
                required int montoCentavos,
                required String estado,
                Value<DateTime?> pagadoEn = const Value.absent(),
                Value<String?> voucherPath = const Value.absent(),
                required DateTime actualizadoEn,
                Value<int> rowid = const Value.absent(),
              }) => AportesLocalesCompanion.insert(
                id: id,
                juntaId: juntaId,
                turnoId: turnoId,
                participanteId: participanteId,
                montoCentavos: montoCentavos,
                estado: estado,
                pagadoEn: pagadoEn,
                voucherPath: voucherPath,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AportesLocalesTable, AportesLocale>(table),
                  BaseReferences<
                    _$BaseLocal,
                    $AportesLocalesTable,
                    AportesLocale
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AportesLocalesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocal,
      $AportesLocalesTable,
      AportesLocale,
      $$AportesLocalesTableFilterComposer,
      $$AportesLocalesTableOrderingComposer,
      $$AportesLocalesTableAnnotationComposer,
      $$AportesLocalesTableCreateCompanionBuilder,
      $$AportesLocalesTableUpdateCompanionBuilder,
      (
        AportesLocale,
        BaseReferences<_$BaseLocal, $AportesLocalesTable, AportesLocale>,
      ),
      AportesLocale,
      PrefetchHooks Function()
    >;
typedef $$CambiosPendientesTableCreateCompanionBuilder =
    CambiosPendientesCompanion Function({
      Value<int> id,
      required String tabla,
      required String filaId,
      required String operacion,
      required String datos,
      required DateTime creadoEn,
      Value<int> intentos,
      Value<String?> ultimoError,
    });
typedef $$CambiosPendientesTableUpdateCompanionBuilder =
    CambiosPendientesCompanion Function({
      Value<int> id,
      Value<String> tabla,
      Value<String> filaId,
      Value<String> operacion,
      Value<String> datos,
      Value<DateTime> creadoEn,
      Value<int> intentos,
      Value<String?> ultimoError,
    });

class $$CambiosPendientesTableFilterComposer
    extends Composer<_$BaseLocal, $CambiosPendientesTable> {
  $$CambiosPendientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tabla => $composableBuilder(
    column: $table.tabla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filaId => $composableBuilder(
    column: $table.filaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operacion => $composableBuilder(
    column: $table.operacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datos => $composableBuilder(
    column: $table.datos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intentos => $composableBuilder(
    column: $table.intentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ultimoError => $composableBuilder(
    column: $table.ultimoError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CambiosPendientesTableOrderingComposer
    extends Composer<_$BaseLocal, $CambiosPendientesTable> {
  $$CambiosPendientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tabla => $composableBuilder(
    column: $table.tabla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filaId => $composableBuilder(
    column: $table.filaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operacion => $composableBuilder(
    column: $table.operacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datos => $composableBuilder(
    column: $table.datos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intentos => $composableBuilder(
    column: $table.intentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ultimoError => $composableBuilder(
    column: $table.ultimoError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CambiosPendientesTableAnnotationComposer
    extends Composer<_$BaseLocal, $CambiosPendientesTable> {
  $$CambiosPendientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tabla =>
      $composableBuilder(column: $table.tabla, builder: (column) => column);

  GeneratedColumn<String> get filaId =>
      $composableBuilder(column: $table.filaId, builder: (column) => column);

  GeneratedColumn<String> get operacion =>
      $composableBuilder(column: $table.operacion, builder: (column) => column);

  GeneratedColumn<String> get datos =>
      $composableBuilder(column: $table.datos, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<int> get intentos =>
      $composableBuilder(column: $table.intentos, builder: (column) => column);

  GeneratedColumn<String> get ultimoError => $composableBuilder(
    column: $table.ultimoError,
    builder: (column) => column,
  );
}

class $$CambiosPendientesTableTableManager
    extends
        RootTableManager<
          _$BaseLocal,
          $CambiosPendientesTable,
          CambiosPendiente,
          $$CambiosPendientesTableFilterComposer,
          $$CambiosPendientesTableOrderingComposer,
          $$CambiosPendientesTableAnnotationComposer,
          $$CambiosPendientesTableCreateCompanionBuilder,
          $$CambiosPendientesTableUpdateCompanionBuilder,
          (
            CambiosPendiente,
            BaseReferences<
              _$BaseLocal,
              $CambiosPendientesTable,
              CambiosPendiente
            >,
          ),
          CambiosPendiente,
          PrefetchHooks Function()
        > {
  $$CambiosPendientesTableTableManager(
    _$BaseLocal db,
    $CambiosPendientesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CambiosPendientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CambiosPendientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CambiosPendientesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tabla = const Value.absent(),
                Value<String> filaId = const Value.absent(),
                Value<String> operacion = const Value.absent(),
                Value<String> datos = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> intentos = const Value.absent(),
                Value<String?> ultimoError = const Value.absent(),
              }) => CambiosPendientesCompanion(
                id: id,
                tabla: tabla,
                filaId: filaId,
                operacion: operacion,
                datos: datos,
                creadoEn: creadoEn,
                intentos: intentos,
                ultimoError: ultimoError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tabla,
                required String filaId,
                required String operacion,
                required String datos,
                required DateTime creadoEn,
                Value<int> intentos = const Value.absent(),
                Value<String?> ultimoError = const Value.absent(),
              }) => CambiosPendientesCompanion.insert(
                id: id,
                tabla: tabla,
                filaId: filaId,
                operacion: operacion,
                datos: datos,
                creadoEn: creadoEn,
                intentos: intentos,
                ultimoError: ultimoError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CambiosPendientesTable, CambiosPendiente>(table),
                  BaseReferences<
                    _$BaseLocal,
                    $CambiosPendientesTable,
                    CambiosPendiente
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CambiosPendientesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocal,
      $CambiosPendientesTable,
      CambiosPendiente,
      $$CambiosPendientesTableFilterComposer,
      $$CambiosPendientesTableOrderingComposer,
      $$CambiosPendientesTableAnnotationComposer,
      $$CambiosPendientesTableCreateCompanionBuilder,
      $$CambiosPendientesTableUpdateCompanionBuilder,
      (
        CambiosPendiente,
        BaseReferences<_$BaseLocal, $CambiosPendientesTable, CambiosPendiente>,
      ),
      CambiosPendiente,
      PrefetchHooks Function()
    >;

class $BaseLocalManager {
  final _$BaseLocal _db;
  $BaseLocalManager(this._db);
  $$JuntasLocalesTableTableManager get juntasLocales =>
      $$JuntasLocalesTableTableManager(_db, _db.juntasLocales);
  $$ParticipantesLocalesTableTableManager get participantesLocales =>
      $$ParticipantesLocalesTableTableManager(_db, _db.participantesLocales);
  $$TurnosLocalesTableTableManager get turnosLocales =>
      $$TurnosLocalesTableTableManager(_db, _db.turnosLocales);
  $$AportesLocalesTableTableManager get aportesLocales =>
      $$AportesLocalesTableTableManager(_db, _db.aportesLocales);
  $$CambiosPendientesTableTableManager get cambiosPendientes =>
      $$CambiosPendientesTableTableManager(_db, _db.cambiosPendientes);
}
