// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_local_database.dart';

// ignore_for_file: type=lint
class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, user_drift_model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dniMeta = const VerificationMeta('dni');
  @override
  late final GeneratedColumn<String> dni = GeneratedColumn<String>(
    'dni',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  @override
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('COMPETITOR'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dni,
    rol,
    name,
    lastName,
    email,
    isActive,
    birthDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<user_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dni')) {
      context.handle(
        _dniMeta,
        dni.isAcceptableOrUnknown(data['dni']!, _dniMeta),
      );
    } else if (isInserting) {
      context.missing(_dniMeta);
    }
    if (data.containsKey('rol')) {
      context.handle(
        _rolMeta,
        rol.isAcceptableOrUnknown(data['rol']!, _rolMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  user_drift_model map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return user_drift_model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dni'],
      )!,
      rol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class user_drift_model extends DataClass
    implements Insertable<user_drift_model> {
  final int id;
  final String dni;
  final String rol;
  final String name;
  final String lastName;
  final String email;
  final bool isActive;
  final DateTime? birthDate;
  const user_drift_model({
    required this.id,
    required this.dni,
    required this.rol,
    required this.name,
    required this.lastName,
    required this.email,
    required this.isActive,
    this.birthDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dni'] = Variable<String>(dni);
    map['rol'] = Variable<String>(rol);
    map['name'] = Variable<String>(name);
    map['last_name'] = Variable<String>(lastName);
    map['email'] = Variable<String>(email);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      dni: Value(dni),
      rol: Value(rol),
      name: Value(name),
      lastName: Value(lastName),
      email: Value(email),
      isActive: Value(isActive),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
    );
  }

  factory user_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return user_drift_model(
      id: serializer.fromJson<int>(json['id']),
      dni: serializer.fromJson<String>(json['dni']),
      rol: serializer.fromJson<String>(json['rol']),
      name: serializer.fromJson<String>(json['name']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String>(json['email']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dni': serializer.toJson<String>(dni),
      'rol': serializer.toJson<String>(rol),
      'name': serializer.toJson<String>(name),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String>(email),
      'isActive': serializer.toJson<bool>(isActive),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
    };
  }

  user_drift_model copyWith({
    int? id,
    String? dni,
    String? rol,
    String? name,
    String? lastName,
    String? email,
    bool? isActive,
    Value<DateTime?> birthDate = const Value.absent(),
  }) => user_drift_model(
    id: id ?? this.id,
    dni: dni ?? this.dni,
    rol: rol ?? this.rol,
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    isActive: isActive ?? this.isActive,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
  );
  user_drift_model copyWithCompanion(UserTableCompanion data) {
    return user_drift_model(
      id: data.id.present ? data.id.value : this.id,
      dni: data.dni.present ? data.dni.value : this.dni,
      rol: data.rol.present ? data.rol.value : this.rol,
      name: data.name.present ? data.name.value : this.name,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('user_drift_model(')
          ..write('id: $id, ')
          ..write('dni: $dni, ')
          ..write('rol: $rol, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('birthDate: $birthDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dni, rol, name, lastName, email, isActive, birthDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is user_drift_model &&
          other.id == this.id &&
          other.dni == this.dni &&
          other.rol == this.rol &&
          other.name == this.name &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.isActive == this.isActive &&
          other.birthDate == this.birthDate);
}

class UserTableCompanion extends UpdateCompanion<user_drift_model> {
  final Value<int> id;
  final Value<String> dni;
  final Value<String> rol;
  final Value<String> name;
  final Value<String> lastName;
  final Value<String> email;
  final Value<bool> isActive;
  final Value<DateTime?> birthDate;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.dni = const Value.absent(),
    this.rol = const Value.absent(),
    this.name = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    this.birthDate = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String dni,
    this.rol = const Value.absent(),
    required String name,
    required String lastName,
    required String email,
    this.isActive = const Value.absent(),
    this.birthDate = const Value.absent(),
  }) : dni = Value(dni),
       name = Value(name),
       lastName = Value(lastName),
       email = Value(email);
  static Insertable<user_drift_model> custom({
    Expression<int>? id,
    Expression<String>? dni,
    Expression<String>? rol,
    Expression<String>? name,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<bool>? isActive,
    Expression<DateTime>? birthDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dni != null) 'dni': dni,
      if (rol != null) 'rol': rol,
      if (name != null) 'name': name,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (isActive != null) 'is_active': isActive,
      if (birthDate != null) 'birth_date': birthDate,
    });
  }

  UserTableCompanion copyWith({
    Value<int>? id,
    Value<String>? dni,
    Value<String>? rol,
    Value<String>? name,
    Value<String>? lastName,
    Value<String>? email,
    Value<bool>? isActive,
    Value<DateTime?>? birthDate,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      rol: rol ?? this.rol,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dni.present) {
      map['dni'] = Variable<String>(dni.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(rol.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('dni: $dni, ')
          ..write('rol: $rol, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('birthDate: $birthDate')
          ..write(')'))
        .toString();
  }
}

class $CompetenceTableTable extends CompetenceTable
    with TableInfo<$CompetenceTableTable, competence_drift_model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetenceTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _competitionDateMeta = const VerificationMeta(
    'competitionDate',
  );
  @override
  late final GeneratedColumn<DateTime> competitionDate =
      GeneratedColumn<DateTime>(
        'competition_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _competitionLimitForRegistrationDateMeta =
      const VerificationMeta('competitionLimitForRegistrationDate');
  @override
  late final GeneratedColumn<DateTime> competitionLimitForRegistrationDate =
      GeneratedColumn<DateTime>(
        'competition_limit_for_registration_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nTurnsMeta = const VerificationMeta('nTurns');
  @override
  late final GeneratedColumn<int> nTurns = GeneratedColumn<int>(
    'n_turns',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, List<double>>, String>
  startCoordinates =
      GeneratedColumn<String>(
        'start_coordinates',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Map<String, List<double>>>(
        $CompetenceTableTable.$converterstartCoordinates,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, List<double>>, String>
  finishCoordinates =
      GeneratedColumn<String>(
        'finish_coordinates',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Map<String, List<double>>>(
        $CompetenceTableTable.$converterfinishCoordinates,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    externalId,
    name,
    competitionDate,
    competitionLimitForRegistrationDate,
    nTurns,
    isActive,
    createdBy,
    startCoordinates,
    finishCoordinates,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competence_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<competence_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('competition_date')) {
      context.handle(
        _competitionDateMeta,
        competitionDate.isAcceptableOrUnknown(
          data['competition_date']!,
          _competitionDateMeta,
        ),
      );
    }
    if (data.containsKey('competition_limit_for_registration_date')) {
      context.handle(
        _competitionLimitForRegistrationDateMeta,
        competitionLimitForRegistrationDate.isAcceptableOrUnknown(
          data['competition_limit_for_registration_date']!,
          _competitionLimitForRegistrationDateMeta,
        ),
      );
    }
    if (data.containsKey('n_turns')) {
      context.handle(
        _nTurnsMeta,
        nTurns.isAcceptableOrUnknown(data['n_turns']!, _nTurnsMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  competence_drift_model map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return competence_drift_model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      competitionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}competition_date'],
      ),
      competitionLimitForRegistrationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}competition_limit_for_registration_date'],
      ),
      nTurns: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_turns'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      startCoordinates: $CompetenceTableTable.$converterstartCoordinates
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}start_coordinates'],
            )!,
          ),
      finishCoordinates: $CompetenceTableTable.$converterfinishCoordinates
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}finish_coordinates'],
            )!,
          ),
    );
  }

  @override
  $CompetenceTableTable createAlias(String alias) {
    return $CompetenceTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, List<double>>, String>
  $converterstartCoordinates = const CoordinatesMapConverter();
  static TypeConverter<Map<String, List<double>>, String>
  $converterfinishCoordinates = const CoordinatesMapConverter();
}

class competence_drift_model extends DataClass
    implements Insertable<competence_drift_model> {
  final int id;
  final String externalId;
  final String name;
  final DateTime? competitionDate;
  final DateTime? competitionLimitForRegistrationDate;
  final int nTurns;
  final bool isActive;
  final String createdBy;
  final Map<String, List<double>> startCoordinates;
  final Map<String, List<double>> finishCoordinates;
  const competence_drift_model({
    required this.id,
    required this.externalId,
    required this.name,
    this.competitionDate,
    this.competitionLimitForRegistrationDate,
    required this.nTurns,
    required this.isActive,
    required this.createdBy,
    required this.startCoordinates,
    required this.finishCoordinates,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['external_id'] = Variable<String>(externalId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || competitionDate != null) {
      map['competition_date'] = Variable<DateTime>(competitionDate);
    }
    if (!nullToAbsent || competitionLimitForRegistrationDate != null) {
      map['competition_limit_for_registration_date'] = Variable<DateTime>(
        competitionLimitForRegistrationDate,
      );
    }
    map['n_turns'] = Variable<int>(nTurns);
    map['is_active'] = Variable<bool>(isActive);
    map['created_by'] = Variable<String>(createdBy);
    {
      map['start_coordinates'] = Variable<String>(
        $CompetenceTableTable.$converterstartCoordinates.toSql(
          startCoordinates,
        ),
      );
    }
    {
      map['finish_coordinates'] = Variable<String>(
        $CompetenceTableTable.$converterfinishCoordinates.toSql(
          finishCoordinates,
        ),
      );
    }
    return map;
  }

  CompetenceTableCompanion toCompanion(bool nullToAbsent) {
    return CompetenceTableCompanion(
      id: Value(id),
      externalId: Value(externalId),
      name: Value(name),
      competitionDate: competitionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(competitionDate),
      competitionLimitForRegistrationDate:
          competitionLimitForRegistrationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(competitionLimitForRegistrationDate),
      nTurns: Value(nTurns),
      isActive: Value(isActive),
      createdBy: Value(createdBy),
      startCoordinates: Value(startCoordinates),
      finishCoordinates: Value(finishCoordinates),
    );
  }

  factory competence_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return competence_drift_model(
      id: serializer.fromJson<int>(json['id']),
      externalId: serializer.fromJson<String>(json['externalId']),
      name: serializer.fromJson<String>(json['name']),
      competitionDate: serializer.fromJson<DateTime?>(json['competitionDate']),
      competitionLimitForRegistrationDate: serializer.fromJson<DateTime?>(
        json['competitionLimitForRegistrationDate'],
      ),
      nTurns: serializer.fromJson<int>(json['nTurns']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      startCoordinates: serializer.fromJson<Map<String, List<double>>>(
        json['startCoordinates'],
      ),
      finishCoordinates: serializer.fromJson<Map<String, List<double>>>(
        json['finishCoordinates'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'externalId': serializer.toJson<String>(externalId),
      'name': serializer.toJson<String>(name),
      'competitionDate': serializer.toJson<DateTime?>(competitionDate),
      'competitionLimitForRegistrationDate': serializer.toJson<DateTime?>(
        competitionLimitForRegistrationDate,
      ),
      'nTurns': serializer.toJson<int>(nTurns),
      'isActive': serializer.toJson<bool>(isActive),
      'createdBy': serializer.toJson<String>(createdBy),
      'startCoordinates': serializer.toJson<Map<String, List<double>>>(
        startCoordinates,
      ),
      'finishCoordinates': serializer.toJson<Map<String, List<double>>>(
        finishCoordinates,
      ),
    };
  }

  competence_drift_model copyWith({
    int? id,
    String? externalId,
    String? name,
    Value<DateTime?> competitionDate = const Value.absent(),
    Value<DateTime?> competitionLimitForRegistrationDate = const Value.absent(),
    int? nTurns,
    bool? isActive,
    String? createdBy,
    Map<String, List<double>>? startCoordinates,
    Map<String, List<double>>? finishCoordinates,
  }) => competence_drift_model(
    id: id ?? this.id,
    externalId: externalId ?? this.externalId,
    name: name ?? this.name,
    competitionDate: competitionDate.present
        ? competitionDate.value
        : this.competitionDate,
    competitionLimitForRegistrationDate:
        competitionLimitForRegistrationDate.present
        ? competitionLimitForRegistrationDate.value
        : this.competitionLimitForRegistrationDate,
    nTurns: nTurns ?? this.nTurns,
    isActive: isActive ?? this.isActive,
    createdBy: createdBy ?? this.createdBy,
    startCoordinates: startCoordinates ?? this.startCoordinates,
    finishCoordinates: finishCoordinates ?? this.finishCoordinates,
  );
  competence_drift_model copyWithCompanion(CompetenceTableCompanion data) {
    return competence_drift_model(
      id: data.id.present ? data.id.value : this.id,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      name: data.name.present ? data.name.value : this.name,
      competitionDate: data.competitionDate.present
          ? data.competitionDate.value
          : this.competitionDate,
      competitionLimitForRegistrationDate:
          data.competitionLimitForRegistrationDate.present
          ? data.competitionLimitForRegistrationDate.value
          : this.competitionLimitForRegistrationDate,
      nTurns: data.nTurns.present ? data.nTurns.value : this.nTurns,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      startCoordinates: data.startCoordinates.present
          ? data.startCoordinates.value
          : this.startCoordinates,
      finishCoordinates: data.finishCoordinates.present
          ? data.finishCoordinates.value
          : this.finishCoordinates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('competence_drift_model(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('competitionDate: $competitionDate, ')
          ..write(
            'competitionLimitForRegistrationDate: $competitionLimitForRegistrationDate, ',
          )
          ..write('nTurns: $nTurns, ')
          ..write('isActive: $isActive, ')
          ..write('createdBy: $createdBy, ')
          ..write('startCoordinates: $startCoordinates, ')
          ..write('finishCoordinates: $finishCoordinates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    externalId,
    name,
    competitionDate,
    competitionLimitForRegistrationDate,
    nTurns,
    isActive,
    createdBy,
    startCoordinates,
    finishCoordinates,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is competence_drift_model &&
          other.id == this.id &&
          other.externalId == this.externalId &&
          other.name == this.name &&
          other.competitionDate == this.competitionDate &&
          other.competitionLimitForRegistrationDate ==
              this.competitionLimitForRegistrationDate &&
          other.nTurns == this.nTurns &&
          other.isActive == this.isActive &&
          other.createdBy == this.createdBy &&
          other.startCoordinates == this.startCoordinates &&
          other.finishCoordinates == this.finishCoordinates);
}

class CompetenceTableCompanion extends UpdateCompanion<competence_drift_model> {
  final Value<int> id;
  final Value<String> externalId;
  final Value<String> name;
  final Value<DateTime?> competitionDate;
  final Value<DateTime?> competitionLimitForRegistrationDate;
  final Value<int> nTurns;
  final Value<bool> isActive;
  final Value<String> createdBy;
  final Value<Map<String, List<double>>> startCoordinates;
  final Value<Map<String, List<double>>> finishCoordinates;
  const CompetenceTableCompanion({
    this.id = const Value.absent(),
    this.externalId = const Value.absent(),
    this.name = const Value.absent(),
    this.competitionDate = const Value.absent(),
    this.competitionLimitForRegistrationDate = const Value.absent(),
    this.nTurns = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.startCoordinates = const Value.absent(),
    this.finishCoordinates = const Value.absent(),
  });
  CompetenceTableCompanion.insert({
    this.id = const Value.absent(),
    required String externalId,
    required String name,
    this.competitionDate = const Value.absent(),
    this.competitionLimitForRegistrationDate = const Value.absent(),
    this.nTurns = const Value.absent(),
    this.isActive = const Value.absent(),
    required String createdBy,
    required Map<String, List<double>> startCoordinates,
    required Map<String, List<double>> finishCoordinates,
  }) : externalId = Value(externalId),
       name = Value(name),
       createdBy = Value(createdBy),
       startCoordinates = Value(startCoordinates),
       finishCoordinates = Value(finishCoordinates);
  static Insertable<competence_drift_model> custom({
    Expression<int>? id,
    Expression<String>? externalId,
    Expression<String>? name,
    Expression<DateTime>? competitionDate,
    Expression<DateTime>? competitionLimitForRegistrationDate,
    Expression<int>? nTurns,
    Expression<bool>? isActive,
    Expression<String>? createdBy,
    Expression<String>? startCoordinates,
    Expression<String>? finishCoordinates,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (externalId != null) 'external_id': externalId,
      if (name != null) 'name': name,
      if (competitionDate != null) 'competition_date': competitionDate,
      if (competitionLimitForRegistrationDate != null)
        'competition_limit_for_registration_date':
            competitionLimitForRegistrationDate,
      if (nTurns != null) 'n_turns': nTurns,
      if (isActive != null) 'is_active': isActive,
      if (createdBy != null) 'created_by': createdBy,
      if (startCoordinates != null) 'start_coordinates': startCoordinates,
      if (finishCoordinates != null) 'finish_coordinates': finishCoordinates,
    });
  }

  CompetenceTableCompanion copyWith({
    Value<int>? id,
    Value<String>? externalId,
    Value<String>? name,
    Value<DateTime?>? competitionDate,
    Value<DateTime?>? competitionLimitForRegistrationDate,
    Value<int>? nTurns,
    Value<bool>? isActive,
    Value<String>? createdBy,
    Value<Map<String, List<double>>>? startCoordinates,
    Value<Map<String, List<double>>>? finishCoordinates,
  }) {
    return CompetenceTableCompanion(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      competitionDate: competitionDate ?? this.competitionDate,
      competitionLimitForRegistrationDate:
          competitionLimitForRegistrationDate ??
          this.competitionLimitForRegistrationDate,
      nTurns: nTurns ?? this.nTurns,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      startCoordinates: startCoordinates ?? this.startCoordinates,
      finishCoordinates: finishCoordinates ?? this.finishCoordinates,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (competitionDate.present) {
      map['competition_date'] = Variable<DateTime>(competitionDate.value);
    }
    if (competitionLimitForRegistrationDate.present) {
      map['competition_limit_for_registration_date'] = Variable<DateTime>(
        competitionLimitForRegistrationDate.value,
      );
    }
    if (nTurns.present) {
      map['n_turns'] = Variable<int>(nTurns.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (startCoordinates.present) {
      map['start_coordinates'] = Variable<String>(
        $CompetenceTableTable.$converterstartCoordinates.toSql(
          startCoordinates.value,
        ),
      );
    }
    if (finishCoordinates.present) {
      map['finish_coordinates'] = Variable<String>(
        $CompetenceTableTable.$converterfinishCoordinates.toSql(
          finishCoordinates.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetenceTableCompanion(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('competitionDate: $competitionDate, ')
          ..write(
            'competitionLimitForRegistrationDate: $competitionLimitForRegistrationDate, ',
          )
          ..write('nTurns: $nTurns, ')
          ..write('isActive: $isActive, ')
          ..write('createdBy: $createdBy, ')
          ..write('startCoordinates: $startCoordinates, ')
          ..write('finishCoordinates: $finishCoordinates')
          ..write(')'))
        .toString();
  }
}

class $CompetitionRegistrationTableTable extends CompetitionRegistrationTable
    with
        TableInfo<
          $CompetitionRegistrationTableTable,
          competition_registration_drift_model
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetitionRegistrationTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<int> registrationNumber = GeneratedColumn<int>(
    'registration_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userDniMeta = const VerificationMeta(
    'userDni',
  );
  @override
  late final GeneratedColumn<String> userDni = GeneratedColumn<String>(
    'user_dni',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nTurnsMeta = const VerificationMeta('nTurns');
  @override
  late final GeneratedColumn<int> nTurns = GeneratedColumn<int>(
    'n_turns',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _competenceIdMeta = const VerificationMeta(
    'competenceId',
  );
  @override
  late final GeneratedColumn<int> competenceId = GeneratedColumn<int>(
    'competence_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    externalId,
    registrationNumber,
    time,
    userDni,
    nTurns,
    competenceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competition_registration_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<competition_registration_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('registration_number')) {
      context.handle(
        _registrationNumberMeta,
        registrationNumber.isAcceptableOrUnknown(
          data['registration_number']!,
          _registrationNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registrationNumberMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('user_dni')) {
      context.handle(
        _userDniMeta,
        userDni.isAcceptableOrUnknown(data['user_dni']!, _userDniMeta),
      );
    } else if (isInserting) {
      context.missing(_userDniMeta);
    }
    if (data.containsKey('n_turns')) {
      context.handle(
        _nTurnsMeta,
        nTurns.isAcceptableOrUnknown(data['n_turns']!, _nTurnsMeta),
      );
    }
    if (data.containsKey('competence_id')) {
      context.handle(
        _competenceIdMeta,
        competenceId.isAcceptableOrUnknown(
          data['competence_id']!,
          _competenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competenceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  competition_registration_drift_model map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return competition_registration_drift_model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      registrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}registration_number'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      )!,
      userDni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_dni'],
      )!,
      nTurns: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_turns'],
      )!,
      competenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}competence_id'],
      )!,
    );
  }

  @override
  $CompetitionRegistrationTableTable createAlias(String alias) {
    return $CompetitionRegistrationTableTable(attachedDatabase, alias);
  }
}

class competition_registration_drift_model extends DataClass
    implements Insertable<competition_registration_drift_model> {
  final int id;
  final String externalId;
  final int registrationNumber;
  final int time;
  final String userDni;
  final int nTurns;
  final int competenceId;
  const competition_registration_drift_model({
    required this.id,
    required this.externalId,
    required this.registrationNumber,
    required this.time,
    required this.userDni,
    required this.nTurns,
    required this.competenceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['external_id'] = Variable<String>(externalId);
    map['registration_number'] = Variable<int>(registrationNumber);
    map['time'] = Variable<int>(time);
    map['user_dni'] = Variable<String>(userDni);
    map['n_turns'] = Variable<int>(nTurns);
    map['competence_id'] = Variable<int>(competenceId);
    return map;
  }

  CompetitionRegistrationTableCompanion toCompanion(bool nullToAbsent) {
    return CompetitionRegistrationTableCompanion(
      id: Value(id),
      externalId: Value(externalId),
      registrationNumber: Value(registrationNumber),
      time: Value(time),
      userDni: Value(userDni),
      nTurns: Value(nTurns),
      competenceId: Value(competenceId),
    );
  }

  factory competition_registration_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return competition_registration_drift_model(
      id: serializer.fromJson<int>(json['id']),
      externalId: serializer.fromJson<String>(json['externalId']),
      registrationNumber: serializer.fromJson<int>(json['registrationNumber']),
      time: serializer.fromJson<int>(json['time']),
      userDni: serializer.fromJson<String>(json['userDni']),
      nTurns: serializer.fromJson<int>(json['nTurns']),
      competenceId: serializer.fromJson<int>(json['competenceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'externalId': serializer.toJson<String>(externalId),
      'registrationNumber': serializer.toJson<int>(registrationNumber),
      'time': serializer.toJson<int>(time),
      'userDni': serializer.toJson<String>(userDni),
      'nTurns': serializer.toJson<int>(nTurns),
      'competenceId': serializer.toJson<int>(competenceId),
    };
  }

  competition_registration_drift_model copyWith({
    int? id,
    String? externalId,
    int? registrationNumber,
    int? time,
    String? userDni,
    int? nTurns,
    int? competenceId,
  }) => competition_registration_drift_model(
    id: id ?? this.id,
    externalId: externalId ?? this.externalId,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    time: time ?? this.time,
    userDni: userDni ?? this.userDni,
    nTurns: nTurns ?? this.nTurns,
    competenceId: competenceId ?? this.competenceId,
  );
  competition_registration_drift_model copyWithCompanion(
    CompetitionRegistrationTableCompanion data,
  ) {
    return competition_registration_drift_model(
      id: data.id.present ? data.id.value : this.id,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      registrationNumber: data.registrationNumber.present
          ? data.registrationNumber.value
          : this.registrationNumber,
      time: data.time.present ? data.time.value : this.time,
      userDni: data.userDni.present ? data.userDni.value : this.userDni,
      nTurns: data.nTurns.present ? data.nTurns.value : this.nTurns,
      competenceId: data.competenceId.present
          ? data.competenceId.value
          : this.competenceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('competition_registration_drift_model(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('time: $time, ')
          ..write('userDni: $userDni, ')
          ..write('nTurns: $nTurns, ')
          ..write('competenceId: $competenceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    externalId,
    registrationNumber,
    time,
    userDni,
    nTurns,
    competenceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is competition_registration_drift_model &&
          other.id == this.id &&
          other.externalId == this.externalId &&
          other.registrationNumber == this.registrationNumber &&
          other.time == this.time &&
          other.userDni == this.userDni &&
          other.nTurns == this.nTurns &&
          other.competenceId == this.competenceId);
}

class CompetitionRegistrationTableCompanion
    extends UpdateCompanion<competition_registration_drift_model> {
  final Value<int> id;
  final Value<String> externalId;
  final Value<int> registrationNumber;
  final Value<int> time;
  final Value<String> userDni;
  final Value<int> nTurns;
  final Value<int> competenceId;
  const CompetitionRegistrationTableCompanion({
    this.id = const Value.absent(),
    this.externalId = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.time = const Value.absent(),
    this.userDni = const Value.absent(),
    this.nTurns = const Value.absent(),
    this.competenceId = const Value.absent(),
  });
  CompetitionRegistrationTableCompanion.insert({
    this.id = const Value.absent(),
    required String externalId,
    required int registrationNumber,
    this.time = const Value.absent(),
    required String userDni,
    this.nTurns = const Value.absent(),
    required int competenceId,
  }) : externalId = Value(externalId),
       registrationNumber = Value(registrationNumber),
       userDni = Value(userDni),
       competenceId = Value(competenceId);
  static Insertable<competition_registration_drift_model> custom({
    Expression<int>? id,
    Expression<String>? externalId,
    Expression<int>? registrationNumber,
    Expression<int>? time,
    Expression<String>? userDni,
    Expression<int>? nTurns,
    Expression<int>? competenceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (externalId != null) 'external_id': externalId,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (time != null) 'time': time,
      if (userDni != null) 'user_dni': userDni,
      if (nTurns != null) 'n_turns': nTurns,
      if (competenceId != null) 'competence_id': competenceId,
    });
  }

  CompetitionRegistrationTableCompanion copyWith({
    Value<int>? id,
    Value<String>? externalId,
    Value<int>? registrationNumber,
    Value<int>? time,
    Value<String>? userDni,
    Value<int>? nTurns,
    Value<int>? competenceId,
  }) {
    return CompetitionRegistrationTableCompanion(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      time: time ?? this.time,
      userDni: userDni ?? this.userDni,
      nTurns: nTurns ?? this.nTurns,
      competenceId: competenceId ?? this.competenceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<int>(registrationNumber.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (userDni.present) {
      map['user_dni'] = Variable<String>(userDni.value);
    }
    if (nTurns.present) {
      map['n_turns'] = Variable<int>(nTurns.value);
    }
    if (competenceId.present) {
      map['competence_id'] = Variable<int>(competenceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetitionRegistrationTableCompanion(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('time: $time, ')
          ..write('userDni: $userDni, ')
          ..write('nTurns: $nTurns, ')
          ..write('competenceId: $competenceId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppLocalDatabase extends GeneratedDatabase {
  _$AppLocalDatabase(QueryExecutor e) : super(e);
  $AppLocalDatabaseManager get managers => $AppLocalDatabaseManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $CompetenceTableTable competenceTable = $CompetenceTableTable(
    this,
  );
  late final $CompetitionRegistrationTableTable competitionRegistrationTable =
      $CompetitionRegistrationTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userTable,
    competenceTable,
    competitionRegistrationTable,
  ];
}

typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      required String dni,
      Value<String> rol,
      required String name,
      required String lastName,
      required String email,
      Value<bool> isActive,
      Value<DateTime?> birthDate,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      Value<String> dni,
      Value<String> rol,
      Value<String> name,
      Value<String> lastName,
      Value<String> email,
      Value<bool> isActive,
      Value<DateTime?> birthDate,
    });

class $$UserTableTableFilterComposer
    extends Composer<_$AppLocalDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer({
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

  ColumnFilters<String> get dni => $composableBuilder(
    column: $table.dni,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserTableTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer({
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

  ColumnOrderings<String> get dni => $composableBuilder(
    column: $table.dni,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dni =>
      $composableBuilder(column: $table.dni, builder: (column) => column);

  GeneratedColumn<String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);
}

class $$UserTableTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $UserTableTable,
          user_drift_model,
          $$UserTableTableFilterComposer,
          $$UserTableTableOrderingComposer,
          $$UserTableTableAnnotationComposer,
          $$UserTableTableCreateCompanionBuilder,
          $$UserTableTableUpdateCompanionBuilder,
          (
            user_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $UserTableTable,
              user_drift_model
            >,
          ),
          user_drift_model,
          PrefetchHooks Function()
        > {
  $$UserTableTableTableManager(_$AppLocalDatabase db, $UserTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dni = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                dni: dni,
                rol: rol,
                name: name,
                lastName: lastName,
                email: email,
                isActive: isActive,
                birthDate: birthDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dni,
                Value<String> rol = const Value.absent(),
                required String name,
                required String lastName,
                required String email,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                dni: dni,
                rol: rol,
                name: name,
                lastName: lastName,
                email: email,
                isActive: isActive,
                birthDate: birthDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $UserTableTable,
      user_drift_model,
      $$UserTableTableFilterComposer,
      $$UserTableTableOrderingComposer,
      $$UserTableTableAnnotationComposer,
      $$UserTableTableCreateCompanionBuilder,
      $$UserTableTableUpdateCompanionBuilder,
      (
        user_drift_model,
        BaseReferences<_$AppLocalDatabase, $UserTableTable, user_drift_model>,
      ),
      user_drift_model,
      PrefetchHooks Function()
    >;
typedef $$CompetenceTableTableCreateCompanionBuilder =
    CompetenceTableCompanion Function({
      Value<int> id,
      required String externalId,
      required String name,
      Value<DateTime?> competitionDate,
      Value<DateTime?> competitionLimitForRegistrationDate,
      Value<int> nTurns,
      Value<bool> isActive,
      required String createdBy,
      required Map<String, List<double>> startCoordinates,
      required Map<String, List<double>> finishCoordinates,
    });
typedef $$CompetenceTableTableUpdateCompanionBuilder =
    CompetenceTableCompanion Function({
      Value<int> id,
      Value<String> externalId,
      Value<String> name,
      Value<DateTime?> competitionDate,
      Value<DateTime?> competitionLimitForRegistrationDate,
      Value<int> nTurns,
      Value<bool> isActive,
      Value<String> createdBy,
      Value<Map<String, List<double>>> startCoordinates,
      Value<Map<String, List<double>>> finishCoordinates,
    });

class $$CompetenceTableTableFilterComposer
    extends Composer<_$AppLocalDatabase, $CompetenceTableTable> {
  $$CompetenceTableTableFilterComposer({
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

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get competitionDate => $composableBuilder(
    column: $table.competitionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get competitionLimitForRegistrationDate =>
      $composableBuilder(
        column: $table.competitionLimitForRegistrationDate,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get nTurns => $composableBuilder(
    column: $table.nTurns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, List<double>>,
    Map<String, List<double>>,
    String
  >
  get startCoordinates => $composableBuilder(
    column: $table.startCoordinates,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, List<double>>,
    Map<String, List<double>>,
    String
  >
  get finishCoordinates => $composableBuilder(
    column: $table.finishCoordinates,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$CompetenceTableTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $CompetenceTableTable> {
  $$CompetenceTableTableOrderingComposer({
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

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get competitionDate => $composableBuilder(
    column: $table.competitionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get competitionLimitForRegistrationDate =>
      $composableBuilder(
        column: $table.competitionLimitForRegistrationDate,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get nTurns => $composableBuilder(
    column: $table.nTurns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startCoordinates => $composableBuilder(
    column: $table.startCoordinates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finishCoordinates => $composableBuilder(
    column: $table.finishCoordinates,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompetenceTableTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $CompetenceTableTable> {
  $$CompetenceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get competitionDate => $composableBuilder(
    column: $table.competitionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get competitionLimitForRegistrationDate =>
      $composableBuilder(
        column: $table.competitionLimitForRegistrationDate,
        builder: (column) => column,
      );

  GeneratedColumn<int> get nTurns =>
      $composableBuilder(column: $table.nTurns, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, List<double>>, String>
  get startCoordinates => $composableBuilder(
    column: $table.startCoordinates,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, List<double>>, String>
  get finishCoordinates => $composableBuilder(
    column: $table.finishCoordinates,
    builder: (column) => column,
  );
}

class $$CompetenceTableTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $CompetenceTableTable,
          competence_drift_model,
          $$CompetenceTableTableFilterComposer,
          $$CompetenceTableTableOrderingComposer,
          $$CompetenceTableTableAnnotationComposer,
          $$CompetenceTableTableCreateCompanionBuilder,
          $$CompetenceTableTableUpdateCompanionBuilder,
          (
            competence_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $CompetenceTableTable,
              competence_drift_model
            >,
          ),
          competence_drift_model,
          PrefetchHooks Function()
        > {
  $$CompetenceTableTableTableManager(
    _$AppLocalDatabase db,
    $CompetenceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetenceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompetenceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompetenceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> competitionDate = const Value.absent(),
                Value<DateTime?> competitionLimitForRegistrationDate =
                    const Value.absent(),
                Value<int> nTurns = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<Map<String, List<double>>> startCoordinates =
                    const Value.absent(),
                Value<Map<String, List<double>>> finishCoordinates =
                    const Value.absent(),
              }) => CompetenceTableCompanion(
                id: id,
                externalId: externalId,
                name: name,
                competitionDate: competitionDate,
                competitionLimitForRegistrationDate:
                    competitionLimitForRegistrationDate,
                nTurns: nTurns,
                isActive: isActive,
                createdBy: createdBy,
                startCoordinates: startCoordinates,
                finishCoordinates: finishCoordinates,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String externalId,
                required String name,
                Value<DateTime?> competitionDate = const Value.absent(),
                Value<DateTime?> competitionLimitForRegistrationDate =
                    const Value.absent(),
                Value<int> nTurns = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required String createdBy,
                required Map<String, List<double>> startCoordinates,
                required Map<String, List<double>> finishCoordinates,
              }) => CompetenceTableCompanion.insert(
                id: id,
                externalId: externalId,
                name: name,
                competitionDate: competitionDate,
                competitionLimitForRegistrationDate:
                    competitionLimitForRegistrationDate,
                nTurns: nTurns,
                isActive: isActive,
                createdBy: createdBy,
                startCoordinates: startCoordinates,
                finishCoordinates: finishCoordinates,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompetenceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $CompetenceTableTable,
      competence_drift_model,
      $$CompetenceTableTableFilterComposer,
      $$CompetenceTableTableOrderingComposer,
      $$CompetenceTableTableAnnotationComposer,
      $$CompetenceTableTableCreateCompanionBuilder,
      $$CompetenceTableTableUpdateCompanionBuilder,
      (
        competence_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $CompetenceTableTable,
          competence_drift_model
        >,
      ),
      competence_drift_model,
      PrefetchHooks Function()
    >;
typedef $$CompetitionRegistrationTableTableCreateCompanionBuilder =
    CompetitionRegistrationTableCompanion Function({
      Value<int> id,
      required String externalId,
      required int registrationNumber,
      Value<int> time,
      required String userDni,
      Value<int> nTurns,
      required int competenceId,
    });
typedef $$CompetitionRegistrationTableTableUpdateCompanionBuilder =
    CompetitionRegistrationTableCompanion Function({
      Value<int> id,
      Value<String> externalId,
      Value<int> registrationNumber,
      Value<int> time,
      Value<String> userDni,
      Value<int> nTurns,
      Value<int> competenceId,
    });

class $$CompetitionRegistrationTableTableFilterComposer
    extends Composer<_$AppLocalDatabase, $CompetitionRegistrationTableTable> {
  $$CompetitionRegistrationTableTableFilterComposer({
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

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userDni => $composableBuilder(
    column: $table.userDni,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nTurns => $composableBuilder(
    column: $table.nTurns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get competenceId => $composableBuilder(
    column: $table.competenceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompetitionRegistrationTableTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $CompetitionRegistrationTableTable> {
  $$CompetitionRegistrationTableTableOrderingComposer({
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

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userDni => $composableBuilder(
    column: $table.userDni,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nTurns => $composableBuilder(
    column: $table.nTurns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get competenceId => $composableBuilder(
    column: $table.competenceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompetitionRegistrationTableTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $CompetitionRegistrationTableTable> {
  $$CompetitionRegistrationTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get userDni =>
      $composableBuilder(column: $table.userDni, builder: (column) => column);

  GeneratedColumn<int> get nTurns =>
      $composableBuilder(column: $table.nTurns, builder: (column) => column);

  GeneratedColumn<int> get competenceId => $composableBuilder(
    column: $table.competenceId,
    builder: (column) => column,
  );
}

class $$CompetitionRegistrationTableTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $CompetitionRegistrationTableTable,
          competition_registration_drift_model,
          $$CompetitionRegistrationTableTableFilterComposer,
          $$CompetitionRegistrationTableTableOrderingComposer,
          $$CompetitionRegistrationTableTableAnnotationComposer,
          $$CompetitionRegistrationTableTableCreateCompanionBuilder,
          $$CompetitionRegistrationTableTableUpdateCompanionBuilder,
          (
            competition_registration_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $CompetitionRegistrationTableTable,
              competition_registration_drift_model
            >,
          ),
          competition_registration_drift_model,
          PrefetchHooks Function()
        > {
  $$CompetitionRegistrationTableTableTableManager(
    _$AppLocalDatabase db,
    $CompetitionRegistrationTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetitionRegistrationTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CompetitionRegistrationTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompetitionRegistrationTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<int> registrationNumber = const Value.absent(),
                Value<int> time = const Value.absent(),
                Value<String> userDni = const Value.absent(),
                Value<int> nTurns = const Value.absent(),
                Value<int> competenceId = const Value.absent(),
              }) => CompetitionRegistrationTableCompanion(
                id: id,
                externalId: externalId,
                registrationNumber: registrationNumber,
                time: time,
                userDni: userDni,
                nTurns: nTurns,
                competenceId: competenceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String externalId,
                required int registrationNumber,
                Value<int> time = const Value.absent(),
                required String userDni,
                Value<int> nTurns = const Value.absent(),
                required int competenceId,
              }) => CompetitionRegistrationTableCompanion.insert(
                id: id,
                externalId: externalId,
                registrationNumber: registrationNumber,
                time: time,
                userDni: userDni,
                nTurns: nTurns,
                competenceId: competenceId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompetitionRegistrationTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $CompetitionRegistrationTableTable,
      competition_registration_drift_model,
      $$CompetitionRegistrationTableTableFilterComposer,
      $$CompetitionRegistrationTableTableOrderingComposer,
      $$CompetitionRegistrationTableTableAnnotationComposer,
      $$CompetitionRegistrationTableTableCreateCompanionBuilder,
      $$CompetitionRegistrationTableTableUpdateCompanionBuilder,
      (
        competition_registration_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $CompetitionRegistrationTableTable,
          competition_registration_drift_model
        >,
      ),
      competition_registration_drift_model,
      PrefetchHooks Function()
    >;

class $AppLocalDatabaseManager {
  final _$AppLocalDatabase _db;
  $AppLocalDatabaseManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$CompetenceTableTableTableManager get competenceTable =>
      $$CompetenceTableTableTableManager(_db, _db.competenceTable);
  $$CompetitionRegistrationTableTableTableManager
  get competitionRegistrationTable =>
      $$CompetitionRegistrationTableTableTableManager(
        _db,
        _db.competitionRegistrationTable,
      );
}
