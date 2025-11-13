// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class UserTable extends Table with TableInfo<UserTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UserTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> dni = GeneratedColumn<String>(
    'dni',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'COMPETITOR\''),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('1'),
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
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
  UserTable createAlias(String alias) {
    return UserTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final int id;
  final String dni;
  final String rol;
  final String name;
  final String lastName;
  final String email;
  final bool isActive;
  final DateTime? birthDate;
  const UserTableData({
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

  factory UserTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
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

  UserTableData copyWith({
    int? id,
    String? dni,
    String? rol,
    String? name,
    String? lastName,
    String? email,
    bool? isActive,
    Value<DateTime?> birthDate = const Value.absent(),
  }) => UserTableData(
    id: id ?? this.id,
    dni: dni ?? this.dni,
    rol: rol ?? this.rol,
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    isActive: isActive ?? this.isActive,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
  );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
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
    return (StringBuffer('UserTableData(')
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
      (other is UserTableData &&
          other.id == this.id &&
          other.dni == this.dni &&
          other.rol == this.rol &&
          other.name == this.name &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.isActive == this.isActive &&
          other.birthDate == this.birthDate);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
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
  static Insertable<UserTableData> custom({
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

class CompetenceTable extends Table
    with TableInfo<CompetenceTable, CompetenceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CompetenceTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> competitionDate =
      GeneratedColumn<DateTime>(
        'competition_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<int> nTurns = GeneratedColumn<int>(
    'n_turns',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> startCoordinates = GeneratedColumn<String>(
    'start_coordinates',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> finishCoordinates =
      GeneratedColumn<String>(
        'finish_coordinates',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    externalId,
    name,
    competitionDate,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompetenceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompetenceTableData(
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
      startCoordinates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_coordinates'],
      )!,
      finishCoordinates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finish_coordinates'],
      )!,
    );
  }

  @override
  CompetenceTable createAlias(String alias) {
    return CompetenceTable(attachedDatabase, alias);
  }
}

class CompetenceTableData extends DataClass
    implements Insertable<CompetenceTableData> {
  final int id;
  final String externalId;
  final String name;
  final DateTime? competitionDate;
  final int nTurns;
  final bool isActive;
  final String createdBy;
  final String startCoordinates;
  final String finishCoordinates;
  const CompetenceTableData({
    required this.id,
    required this.externalId,
    required this.name,
    this.competitionDate,
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
    map['n_turns'] = Variable<int>(nTurns);
    map['is_active'] = Variable<bool>(isActive);
    map['created_by'] = Variable<String>(createdBy);
    map['start_coordinates'] = Variable<String>(startCoordinates);
    map['finish_coordinates'] = Variable<String>(finishCoordinates);
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
      nTurns: Value(nTurns),
      isActive: Value(isActive),
      createdBy: Value(createdBy),
      startCoordinates: Value(startCoordinates),
      finishCoordinates: Value(finishCoordinates),
    );
  }

  factory CompetenceTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompetenceTableData(
      id: serializer.fromJson<int>(json['id']),
      externalId: serializer.fromJson<String>(json['externalId']),
      name: serializer.fromJson<String>(json['name']),
      competitionDate: serializer.fromJson<DateTime?>(json['competitionDate']),
      nTurns: serializer.fromJson<int>(json['nTurns']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      startCoordinates: serializer.fromJson<String>(json['startCoordinates']),
      finishCoordinates: serializer.fromJson<String>(json['finishCoordinates']),
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
      'nTurns': serializer.toJson<int>(nTurns),
      'isActive': serializer.toJson<bool>(isActive),
      'createdBy': serializer.toJson<String>(createdBy),
      'startCoordinates': serializer.toJson<String>(startCoordinates),
      'finishCoordinates': serializer.toJson<String>(finishCoordinates),
    };
  }

  CompetenceTableData copyWith({
    int? id,
    String? externalId,
    String? name,
    Value<DateTime?> competitionDate = const Value.absent(),
    int? nTurns,
    bool? isActive,
    String? createdBy,
    String? startCoordinates,
    String? finishCoordinates,
  }) => CompetenceTableData(
    id: id ?? this.id,
    externalId: externalId ?? this.externalId,
    name: name ?? this.name,
    competitionDate: competitionDate.present
        ? competitionDate.value
        : this.competitionDate,
    nTurns: nTurns ?? this.nTurns,
    isActive: isActive ?? this.isActive,
    createdBy: createdBy ?? this.createdBy,
    startCoordinates: startCoordinates ?? this.startCoordinates,
    finishCoordinates: finishCoordinates ?? this.finishCoordinates,
  );
  CompetenceTableData copyWithCompanion(CompetenceTableCompanion data) {
    return CompetenceTableData(
      id: data.id.present ? data.id.value : this.id,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      name: data.name.present ? data.name.value : this.name,
      competitionDate: data.competitionDate.present
          ? data.competitionDate.value
          : this.competitionDate,
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
    return (StringBuffer('CompetenceTableData(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('competitionDate: $competitionDate, ')
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
    nTurns,
    isActive,
    createdBy,
    startCoordinates,
    finishCoordinates,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompetenceTableData &&
          other.id == this.id &&
          other.externalId == this.externalId &&
          other.name == this.name &&
          other.competitionDate == this.competitionDate &&
          other.nTurns == this.nTurns &&
          other.isActive == this.isActive &&
          other.createdBy == this.createdBy &&
          other.startCoordinates == this.startCoordinates &&
          other.finishCoordinates == this.finishCoordinates);
}

class CompetenceTableCompanion extends UpdateCompanion<CompetenceTableData> {
  final Value<int> id;
  final Value<String> externalId;
  final Value<String> name;
  final Value<DateTime?> competitionDate;
  final Value<int> nTurns;
  final Value<bool> isActive;
  final Value<String> createdBy;
  final Value<String> startCoordinates;
  final Value<String> finishCoordinates;
  const CompetenceTableCompanion({
    this.id = const Value.absent(),
    this.externalId = const Value.absent(),
    this.name = const Value.absent(),
    this.competitionDate = const Value.absent(),
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
    this.nTurns = const Value.absent(),
    this.isActive = const Value.absent(),
    required String createdBy,
    required String startCoordinates,
    required String finishCoordinates,
  }) : externalId = Value(externalId),
       name = Value(name),
       createdBy = Value(createdBy),
       startCoordinates = Value(startCoordinates),
       finishCoordinates = Value(finishCoordinates);
  static Insertable<CompetenceTableData> custom({
    Expression<int>? id,
    Expression<String>? externalId,
    Expression<String>? name,
    Expression<DateTime>? competitionDate,
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
    Value<int>? nTurns,
    Value<bool>? isActive,
    Value<String>? createdBy,
    Value<String>? startCoordinates,
    Value<String>? finishCoordinates,
  }) {
    return CompetenceTableCompanion(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      competitionDate: competitionDate ?? this.competitionDate,
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
      map['start_coordinates'] = Variable<String>(startCoordinates.value);
    }
    if (finishCoordinates.present) {
      map['finish_coordinates'] = Variable<String>(finishCoordinates.value);
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
          ..write('nTurns: $nTurns, ')
          ..write('isActive: $isActive, ')
          ..write('createdBy: $createdBy, ')
          ..write('startCoordinates: $startCoordinates, ')
          ..write('finishCoordinates: $finishCoordinates')
          ..write(')'))
        .toString();
  }
}

class CompetitionRegistrationTable extends Table
    with
        TableInfo<
          CompetitionRegistrationTable,
          CompetitionRegistrationTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CompetitionRegistrationTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> registrationNumber = GeneratedColumn<int>(
    'registration_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> userDni = GeneratedColumn<String>(
    'user_dni',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> nTurns = GeneratedColumn<int>(
    'n_turns',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0'),
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompetitionRegistrationTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompetitionRegistrationTableData(
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
  CompetitionRegistrationTable createAlias(String alias) {
    return CompetitionRegistrationTable(attachedDatabase, alias);
  }
}

class CompetitionRegistrationTableData extends DataClass
    implements Insertable<CompetitionRegistrationTableData> {
  final int id;
  final String externalId;
  final int registrationNumber;
  final int time;
  final String userDni;
  final int nTurns;
  final int competenceId;
  const CompetitionRegistrationTableData({
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

  factory CompetitionRegistrationTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompetitionRegistrationTableData(
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

  CompetitionRegistrationTableData copyWith({
    int? id,
    String? externalId,
    int? registrationNumber,
    int? time,
    String? userDni,
    int? nTurns,
    int? competenceId,
  }) => CompetitionRegistrationTableData(
    id: id ?? this.id,
    externalId: externalId ?? this.externalId,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    time: time ?? this.time,
    userDni: userDni ?? this.userDni,
    nTurns: nTurns ?? this.nTurns,
    competenceId: competenceId ?? this.competenceId,
  );
  CompetitionRegistrationTableData copyWithCompanion(
    CompetitionRegistrationTableCompanion data,
  ) {
    return CompetitionRegistrationTableData(
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
    return (StringBuffer('CompetitionRegistrationTableData(')
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
      (other is CompetitionRegistrationTableData &&
          other.id == this.id &&
          other.externalId == this.externalId &&
          other.registrationNumber == this.registrationNumber &&
          other.time == this.time &&
          other.userDni == this.userDni &&
          other.nTurns == this.nTurns &&
          other.competenceId == this.competenceId);
}

class CompetitionRegistrationTableCompanion
    extends UpdateCompanion<CompetitionRegistrationTableData> {
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
  static Insertable<CompetitionRegistrationTableData> custom({
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

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final UserTable userTable = UserTable(this);
  late final CompetenceTable competenceTable = CompetenceTable(this);
  late final CompetitionRegistrationTable competitionRegistrationTable =
      CompetitionRegistrationTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userTable,
    competenceTable,
    competitionRegistrationTable,
  ];
  @override
  int get schemaVersion => 1;
}
