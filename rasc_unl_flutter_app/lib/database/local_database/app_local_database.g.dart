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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dniMeta = const VerificationMeta('dni');
  @override
  late final GeneratedColumn<String> dni = GeneratedColumn<String>(
    'dni',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    dni,
    rol,
    name,
    lastName,
    email,
    isActive,
    birthDate,
    createdAt,
    updatedAt,
    lastSyncedAt,
    needsSync,
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
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
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
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_id'],
      ),
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
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
  final int? remoteId;
  final String dni;
  final String rol;
  final String name;
  final String lastName;
  final String email;
  final bool isActive;
  final DateTime? birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final bool needsSync;
  const user_drift_model({
    required this.id,
    this.remoteId,
    required this.dni,
    required this.rol,
    required this.name,
    required this.lastName,
    required this.email,
    required this.isActive,
    this.birthDate,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['dni'] = Variable<String>(dni);
    map['rol'] = Variable<String>(rol);
    map['name'] = Variable<String>(name);
    map['last_name'] = Variable<String>(lastName);
    map['email'] = Variable<String>(email);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      dni: Value(dni),
      rol: Value(rol),
      name: Value(name),
      lastName: Value(lastName),
      email: Value(email),
      isActive: Value(isActive),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      needsSync: Value(needsSync),
    );
  }

  factory user_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return user_drift_model(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      dni: serializer.fromJson<String>(json['dni']),
      rol: serializer.fromJson<String>(json['rol']),
      name: serializer.fromJson<String>(json['name']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String>(json['email']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int?>(remoteId),
      'dni': serializer.toJson<String>(dni),
      'rol': serializer.toJson<String>(rol),
      'name': serializer.toJson<String>(name),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String>(email),
      'isActive': serializer.toJson<bool>(isActive),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  user_drift_model copyWith({
    int? id,
    Value<int?> remoteId = const Value.absent(),
    String? dni,
    String? rol,
    String? name,
    String? lastName,
    String? email,
    bool? isActive,
    Value<DateTime?> birthDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    bool? needsSync,
  }) => user_drift_model(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    dni: dni ?? this.dni,
    rol: rol ?? this.rol,
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    isActive: isActive ?? this.isActive,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  user_drift_model copyWithCompanion(UserTableCompanion data) {
    return user_drift_model(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      dni: data.dni.present ? data.dni.value : this.dni,
      rol: data.rol.present ? data.rol.value : this.rol,
      name: data.name.present ? data.name.value : this.name,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('user_drift_model(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('dni: $dni, ')
          ..write('rol: $rol, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('birthDate: $birthDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    dni,
    rol,
    name,
    lastName,
    email,
    isActive,
    birthDate,
    createdAt,
    updatedAt,
    lastSyncedAt,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is user_drift_model &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.dni == this.dni &&
          other.rol == this.rol &&
          other.name == this.name &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.isActive == this.isActive &&
          other.birthDate == this.birthDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.needsSync == this.needsSync);
}

class UserTableCompanion extends UpdateCompanion<user_drift_model> {
  final Value<int> id;
  final Value<int?> remoteId;
  final Value<String> dni;
  final Value<String> rol;
  final Value<String> name;
  final Value<String> lastName;
  final Value<String> email;
  final Value<bool> isActive;
  final Value<DateTime?> birthDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<bool> needsSync;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.dni = const Value.absent(),
    this.rol = const Value.absent(),
    this.name = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String dni,
    this.rol = const Value.absent(),
    required String name,
    required String lastName,
    required String email,
    this.isActive = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
  }) : dni = Value(dni),
       name = Value(name),
       lastName = Value(lastName),
       email = Value(email);
  static Insertable<user_drift_model> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<String>? dni,
    Expression<String>? rol,
    Expression<String>? name,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<bool>? isActive,
    Expression<DateTime>? birthDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<bool>? needsSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (dni != null) 'dni': dni,
      if (rol != null) 'rol': rol,
      if (name != null) 'name': name,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (isActive != null) 'is_active': isActive,
      if (birthDate != null) 'birth_date': birthDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (needsSync != null) 'needs_sync': needsSync,
    });
  }

  UserTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? remoteId,
    Value<String>? dni,
    Value<String>? rol,
    Value<String>? name,
    Value<String>? lastName,
    Value<String>? email,
    Value<bool>? isActive,
    Value<DateTime?>? birthDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastSyncedAt,
    Value<bool>? needsSync,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      dni: dni ?? this.dni,
      rol: rol ?? this.rol,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      needsSync: needsSync ?? this.needsSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('dni: $dni, ')
          ..write('rol: $rol, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('birthDate: $birthDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }
}

class $SessionTableTable extends SessionTable
    with TableInfo<$SessionTableTable, SessionDriftModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_table (id) ON DELETE CASCADE',
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
    'last_login_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tokenExpiresAtMeta = const VerificationMeta(
    'tokenExpiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> tokenExpiresAt =
      GeneratedColumn<DateTime>(
        'token_expires_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    dni,
    email,
    lastLoginAt,
    isActive,
    accessToken,
    refreshToken,
    tokenExpiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionDriftModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('dni')) {
      context.handle(
        _dniMeta,
        dni.isAcceptableOrUnknown(data['dni']!, _dniMeta),
      );
    } else if (isInserting) {
      context.missing(_dniMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('token_expires_at')) {
      context.handle(
        _tokenExpiresAtMeta,
        tokenExpiresAt.isAcceptableOrUnknown(
          data['token_expires_at']!,
          _tokenExpiresAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionDriftModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionDriftModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      dni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dni'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      ),
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      ),
      tokenExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}token_expires_at'],
      ),
    );
  }

  @override
  $SessionTableTable createAlias(String alias) {
    return $SessionTableTable(attachedDatabase, alias);
  }
}

class SessionDriftModel extends DataClass
    implements Insertable<SessionDriftModel> {
  final int id;
  final int userId;
  final String dni;
  final String email;
  final DateTime lastLoginAt;
  final bool isActive;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiresAt;
  const SessionDriftModel({
    required this.id,
    required this.userId,
    required this.dni,
    required this.email,
    required this.lastLoginAt,
    required this.isActive,
    this.accessToken,
    this.refreshToken,
    this.tokenExpiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['dni'] = Variable<String>(dni);
    map['email'] = Variable<String>(email);
    map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    if (!nullToAbsent || tokenExpiresAt != null) {
      map['token_expires_at'] = Variable<DateTime>(tokenExpiresAt);
    }
    return map;
  }

  SessionTableCompanion toCompanion(bool nullToAbsent) {
    return SessionTableCompanion(
      id: Value(id),
      userId: Value(userId),
      dni: Value(dni),
      email: Value(email),
      lastLoginAt: Value(lastLoginAt),
      isActive: Value(isActive),
      accessToken: accessToken == null && nullToAbsent
          ? const Value.absent()
          : Value(accessToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
      tokenExpiresAt: tokenExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenExpiresAt),
    );
  }

  factory SessionDriftModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionDriftModel(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      dni: serializer.fromJson<String>(json['dni']),
      email: serializer.fromJson<String>(json['email']),
      lastLoginAt: serializer.fromJson<DateTime>(json['lastLoginAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      tokenExpiresAt: serializer.fromJson<DateTime?>(json['tokenExpiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'dni': serializer.toJson<String>(dni),
      'email': serializer.toJson<String>(email),
      'lastLoginAt': serializer.toJson<DateTime>(lastLoginAt),
      'isActive': serializer.toJson<bool>(isActive),
      'accessToken': serializer.toJson<String?>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'tokenExpiresAt': serializer.toJson<DateTime?>(tokenExpiresAt),
    };
  }

  SessionDriftModel copyWith({
    int? id,
    int? userId,
    String? dni,
    String? email,
    DateTime? lastLoginAt,
    bool? isActive,
    Value<String?> accessToken = const Value.absent(),
    Value<String?> refreshToken = const Value.absent(),
    Value<DateTime?> tokenExpiresAt = const Value.absent(),
  }) => SessionDriftModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    dni: dni ?? this.dni,
    email: email ?? this.email,
    lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    isActive: isActive ?? this.isActive,
    accessToken: accessToken.present ? accessToken.value : this.accessToken,
    refreshToken: refreshToken.present ? refreshToken.value : this.refreshToken,
    tokenExpiresAt: tokenExpiresAt.present
        ? tokenExpiresAt.value
        : this.tokenExpiresAt,
  );
  SessionDriftModel copyWithCompanion(SessionTableCompanion data) {
    return SessionDriftModel(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      dni: data.dni.present ? data.dni.value : this.dni,
      email: data.email.present ? data.email.value : this.email,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      tokenExpiresAt: data.tokenExpiresAt.present
          ? data.tokenExpiresAt.value
          : this.tokenExpiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionDriftModel(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dni: $dni, ')
          ..write('email: $email, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('isActive: $isActive, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    dni,
    email,
    lastLoginAt,
    isActive,
    accessToken,
    refreshToken,
    tokenExpiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionDriftModel &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.dni == this.dni &&
          other.email == this.email &&
          other.lastLoginAt == this.lastLoginAt &&
          other.isActive == this.isActive &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.tokenExpiresAt == this.tokenExpiresAt);
}

class SessionTableCompanion extends UpdateCompanion<SessionDriftModel> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> dni;
  final Value<String> email;
  final Value<DateTime> lastLoginAt;
  final Value<bool> isActive;
  final Value<String?> accessToken;
  final Value<String?> refreshToken;
  final Value<DateTime?> tokenExpiresAt;
  const SessionTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.dni = const Value.absent(),
    this.email = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
  });
  SessionTableCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String dni,
    required String email,
    this.lastLoginAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
  }) : userId = Value(userId),
       dni = Value(dni),
       email = Value(email);
  static Insertable<SessionDriftModel> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? dni,
    Expression<String>? email,
    Expression<DateTime>? lastLoginAt,
    Expression<bool>? isActive,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<DateTime>? tokenExpiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (dni != null) 'dni': dni,
      if (email != null) 'email': email,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (isActive != null) 'is_active': isActive,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (tokenExpiresAt != null) 'token_expires_at': tokenExpiresAt,
    });
  }

  SessionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? dni,
    Value<String>? email,
    Value<DateTime>? lastLoginAt,
    Value<bool>? isActive,
    Value<String?>? accessToken,
    Value<String?>? refreshToken,
    Value<DateTime?>? tokenExpiresAt,
  }) {
    return SessionTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dni: dni ?? this.dni,
      email: email ?? this.email,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (dni.present) {
      map['dni'] = Variable<String>(dni.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (tokenExpiresAt.present) {
      map['token_expires_at'] = Variable<DateTime>(tokenExpiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dni: $dni, ')
          ..write('email: $email, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('isActive: $isActive, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt')
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
  static const VerificationMeta _maxRegistrationsMeta = const VerificationMeta(
    'maxRegistrations',
  );
  @override
  late final GeneratedColumn<int> maxRegistrations = GeneratedColumn<int>(
    'max_registrations',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    maxRegistrations,
    isActive,
    isFinished,
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
    if (data.containsKey('max_registrations')) {
      context.handle(
        _maxRegistrationsMeta,
        maxRegistrations.isAcceptableOrUnknown(
          data['max_registrations']!,
          _maxRegistrationsMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
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
      maxRegistrations: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_registrations'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
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
  final int? maxRegistrations;
  final bool isActive;
  final bool isFinished;
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
    this.maxRegistrations,
    required this.isActive,
    required this.isFinished,
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
    if (!nullToAbsent || maxRegistrations != null) {
      map['max_registrations'] = Variable<int>(maxRegistrations);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_finished'] = Variable<bool>(isFinished);
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
      maxRegistrations: maxRegistrations == null && nullToAbsent
          ? const Value.absent()
          : Value(maxRegistrations),
      isActive: Value(isActive),
      isFinished: Value(isFinished),
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
      maxRegistrations: serializer.fromJson<int?>(json['maxRegistrations']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
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
      'maxRegistrations': serializer.toJson<int?>(maxRegistrations),
      'isActive': serializer.toJson<bool>(isActive),
      'isFinished': serializer.toJson<bool>(isFinished),
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
    Value<int?> maxRegistrations = const Value.absent(),
    bool? isActive,
    bool? isFinished,
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
    maxRegistrations: maxRegistrations.present
        ? maxRegistrations.value
        : this.maxRegistrations,
    isActive: isActive ?? this.isActive,
    isFinished: isFinished ?? this.isFinished,
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
      maxRegistrations: data.maxRegistrations.present
          ? data.maxRegistrations.value
          : this.maxRegistrations,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
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
          ..write('maxRegistrations: $maxRegistrations, ')
          ..write('isActive: $isActive, ')
          ..write('isFinished: $isFinished, ')
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
    maxRegistrations,
    isActive,
    isFinished,
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
          other.maxRegistrations == this.maxRegistrations &&
          other.isActive == this.isActive &&
          other.isFinished == this.isFinished &&
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
  final Value<int?> maxRegistrations;
  final Value<bool> isActive;
  final Value<bool> isFinished;
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
    this.maxRegistrations = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isFinished = const Value.absent(),
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
    this.maxRegistrations = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isFinished = const Value.absent(),
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
    Expression<int>? maxRegistrations,
    Expression<bool>? isActive,
    Expression<bool>? isFinished,
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
      if (maxRegistrations != null) 'max_registrations': maxRegistrations,
      if (isActive != null) 'is_active': isActive,
      if (isFinished != null) 'is_finished': isFinished,
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
    Value<int?>? maxRegistrations,
    Value<bool>? isActive,
    Value<bool>? isFinished,
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
      maxRegistrations: maxRegistrations ?? this.maxRegistrations,
      isActive: isActive ?? this.isActive,
      isFinished: isFinished ?? this.isFinished,
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
    if (maxRegistrations.present) {
      map['max_registrations'] = Variable<int>(maxRegistrations.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
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
          ..write('maxRegistrations: $maxRegistrations, ')
          ..write('isActive: $isActive, ')
          ..write('isFinished: $isFinished, ')
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>(
        'registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    }
    if (data.containsKey('registration_number')) {
      context.handle(
        _registrationNumberMeta,
        registrationNumber.isAcceptableOrUnknown(
          data['registration_number']!,
          _registrationNumberMeta,
        ),
      );
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
      ),
      registrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration_number'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      ),
      userDni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_dni'],
      )!,
      nTurns: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_turns'],
      ),
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
  final String? externalId;
  final String? registrationNumber;
  final int? time;
  final String userDni;
  final int? nTurns;
  final int competenceId;
  const competition_registration_drift_model({
    required this.id,
    this.externalId,
    this.registrationNumber,
    this.time,
    required this.userDni,
    this.nTurns,
    required this.competenceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || registrationNumber != null) {
      map['registration_number'] = Variable<String>(registrationNumber);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<int>(time);
    }
    map['user_dni'] = Variable<String>(userDni);
    if (!nullToAbsent || nTurns != null) {
      map['n_turns'] = Variable<int>(nTurns);
    }
    map['competence_id'] = Variable<int>(competenceId);
    return map;
  }

  CompetitionRegistrationTableCompanion toCompanion(bool nullToAbsent) {
    return CompetitionRegistrationTableCompanion(
      id: Value(id),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      registrationNumber: registrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationNumber),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      userDni: Value(userDni),
      nTurns: nTurns == null && nullToAbsent
          ? const Value.absent()
          : Value(nTurns),
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
      externalId: serializer.fromJson<String?>(json['externalId']),
      registrationNumber: serializer.fromJson<String?>(
        json['registrationNumber'],
      ),
      time: serializer.fromJson<int?>(json['time']),
      userDni: serializer.fromJson<String>(json['userDni']),
      nTurns: serializer.fromJson<int?>(json['nTurns']),
      competenceId: serializer.fromJson<int>(json['competenceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'externalId': serializer.toJson<String?>(externalId),
      'registrationNumber': serializer.toJson<String?>(registrationNumber),
      'time': serializer.toJson<int?>(time),
      'userDni': serializer.toJson<String>(userDni),
      'nTurns': serializer.toJson<int?>(nTurns),
      'competenceId': serializer.toJson<int>(competenceId),
    };
  }

  competition_registration_drift_model copyWith({
    int? id,
    Value<String?> externalId = const Value.absent(),
    Value<String?> registrationNumber = const Value.absent(),
    Value<int?> time = const Value.absent(),
    String? userDni,
    Value<int?> nTurns = const Value.absent(),
    int? competenceId,
  }) => competition_registration_drift_model(
    id: id ?? this.id,
    externalId: externalId.present ? externalId.value : this.externalId,
    registrationNumber: registrationNumber.present
        ? registrationNumber.value
        : this.registrationNumber,
    time: time.present ? time.value : this.time,
    userDni: userDni ?? this.userDni,
    nTurns: nTurns.present ? nTurns.value : this.nTurns,
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
  final Value<String?> externalId;
  final Value<String?> registrationNumber;
  final Value<int?> time;
  final Value<String> userDni;
  final Value<int?> nTurns;
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
    this.externalId = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.time = const Value.absent(),
    required String userDni,
    this.nTurns = const Value.absent(),
    required int competenceId,
  }) : userDni = Value(userDni),
       competenceId = Value(competenceId);
  static Insertable<competition_registration_drift_model> custom({
    Expression<int>? id,
    Expression<String>? externalId,
    Expression<String>? registrationNumber,
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
    Value<String?>? externalId,
    Value<String?>? registrationNumber,
    Value<int?>? time,
    Value<String>? userDni,
    Value<int?>? nTurns,
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
      map['registration_number'] = Variable<String>(registrationNumber.value);
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

class $CompetitionTimeRecordTableTable extends CompetitionTimeRecordTable
    with
        TableInfo<
          $CompetitionTimeRecordTableTable,
          competition_time_record_drift_model
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetitionTimeRecordTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>(
        'registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    registrationNumber,
    time,
    competenceId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competition_time_record_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<competition_time_record_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('registration_number')) {
      context.handle(
        _registrationNumberMeta,
        registrationNumber.isAcceptableOrUnknown(
          data['registration_number']!,
          _registrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  competition_time_record_drift_model map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return competition_time_record_drift_model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      registrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration_number'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      )!,
      competenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}competence_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CompetitionTimeRecordTableTable createAlias(String alias) {
    return $CompetitionTimeRecordTableTable(attachedDatabase, alias);
  }
}

class competition_time_record_drift_model extends DataClass
    implements Insertable<competition_time_record_drift_model> {
  final int id;
  final String? registrationNumber;
  final int time;
  final int competenceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const competition_time_record_drift_model({
    required this.id,
    this.registrationNumber,
    required this.time,
    required this.competenceId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || registrationNumber != null) {
      map['registration_number'] = Variable<String>(registrationNumber);
    }
    map['time'] = Variable<int>(time);
    map['competence_id'] = Variable<int>(competenceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CompetitionTimeRecordTableCompanion toCompanion(bool nullToAbsent) {
    return CompetitionTimeRecordTableCompanion(
      id: Value(id),
      registrationNumber: registrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationNumber),
      time: Value(time),
      competenceId: Value(competenceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory competition_time_record_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return competition_time_record_drift_model(
      id: serializer.fromJson<int>(json['id']),
      registrationNumber: serializer.fromJson<String?>(
        json['registrationNumber'],
      ),
      time: serializer.fromJson<int>(json['time']),
      competenceId: serializer.fromJson<int>(json['competenceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'registrationNumber': serializer.toJson<String?>(registrationNumber),
      'time': serializer.toJson<int>(time),
      'competenceId': serializer.toJson<int>(competenceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  competition_time_record_drift_model copyWith({
    int? id,
    Value<String?> registrationNumber = const Value.absent(),
    int? time,
    int? competenceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => competition_time_record_drift_model(
    id: id ?? this.id,
    registrationNumber: registrationNumber.present
        ? registrationNumber.value
        : this.registrationNumber,
    time: time ?? this.time,
    competenceId: competenceId ?? this.competenceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  competition_time_record_drift_model copyWithCompanion(
    CompetitionTimeRecordTableCompanion data,
  ) {
    return competition_time_record_drift_model(
      id: data.id.present ? data.id.value : this.id,
      registrationNumber: data.registrationNumber.present
          ? data.registrationNumber.value
          : this.registrationNumber,
      time: data.time.present ? data.time.value : this.time,
      competenceId: data.competenceId.present
          ? data.competenceId.value
          : this.competenceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('competition_time_record_drift_model(')
          ..write('id: $id, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('time: $time, ')
          ..write('competenceId: $competenceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    registrationNumber,
    time,
    competenceId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is competition_time_record_drift_model &&
          other.id == this.id &&
          other.registrationNumber == this.registrationNumber &&
          other.time == this.time &&
          other.competenceId == this.competenceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompetitionTimeRecordTableCompanion
    extends UpdateCompanion<competition_time_record_drift_model> {
  final Value<int> id;
  final Value<String?> registrationNumber;
  final Value<int> time;
  final Value<int> competenceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CompetitionTimeRecordTableCompanion({
    this.id = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.time = const Value.absent(),
    this.competenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompetitionTimeRecordTableCompanion.insert({
    this.id = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    required int time,
    required int competenceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : time = Value(time),
       competenceId = Value(competenceId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<competition_time_record_drift_model> custom({
    Expression<int>? id,
    Expression<String>? registrationNumber,
    Expression<int>? time,
    Expression<int>? competenceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (time != null) 'time': time,
      if (competenceId != null) 'competence_id': competenceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompetitionTimeRecordTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? registrationNumber,
    Value<int>? time,
    Value<int>? competenceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CompetitionTimeRecordTableCompanion(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      time: time ?? this.time,
      competenceId: competenceId ?? this.competenceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String>(registrationNumber.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (competenceId.present) {
      map['competence_id'] = Variable<int>(competenceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetitionTimeRecordTableCompanion(')
          ..write('id: $id, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('time: $time, ')
          ..write('competenceId: $competenceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppLocalDatabase extends GeneratedDatabase {
  _$AppLocalDatabase(QueryExecutor e) : super(e);
  $AppLocalDatabaseManager get managers => $AppLocalDatabaseManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $SessionTableTable sessionTable = $SessionTableTable(this);
  late final $CompetenceTableTable competenceTable = $CompetenceTableTable(
    this,
  );
  late final $CompetitionRegistrationTableTable competitionRegistrationTable =
      $CompetitionRegistrationTableTable(this);
  late final $CompetitionTimeRecordTableTable competitionTimeRecordTable =
      $CompetitionTimeRecordTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userTable,
    sessionTable,
    competenceTable,
    competitionRegistrationTable,
    competitionTimeRecordTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      Value<int?> remoteId,
      required String dni,
      Value<String> rol,
      required String name,
      required String lastName,
      required String email,
      Value<bool> isActive,
      Value<DateTime?> birthDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncedAt,
      Value<bool> needsSync,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      Value<int?> remoteId,
      Value<String> dni,
      Value<String> rol,
      Value<String> name,
      Value<String> lastName,
      Value<String> email,
      Value<bool> isActive,
      Value<DateTime?> birthDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncedAt,
      Value<bool> needsSync,
    });

final class $$UserTableTableReferences
    extends
        BaseReferences<_$AppLocalDatabase, $UserTableTable, user_drift_model> {
  $$UserTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionTableTable, List<SessionDriftModel>>
  _sessionTableRefsTable(_$AppLocalDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sessionTable,
        aliasName: $_aliasNameGenerator(
          db.userTable.id,
          db.sessionTable.userId,
        ),
      );

  $$SessionTableTableProcessedTableManager get sessionTableRefs {
    final manager = $$SessionTableTableTableManager(
      $_db,
      $_db.sessionTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<int> get remoteId => $composableBuilder(
    column: $table.remoteId,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionTableRefs(
    Expression<bool> Function($$SessionTableTableFilterComposer f) f,
  ) {
    final $$SessionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableTableFilterComposer(
            $db: $db,
            $table: $db.sessionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<int> get remoteId => $composableBuilder(
    column: $table.remoteId,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
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

  GeneratedColumn<int> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  Expression<T> sessionTableRefs<T extends Object>(
    Expression<T> Function($$SessionTableTableAnnotationComposer a) f,
  ) {
    final $$SessionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (user_drift_model, $$UserTableTableReferences),
          user_drift_model,
          PrefetchHooks Function({bool sessionTableRefs})
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
                Value<int?> remoteId = const Value.absent(),
                Value<String> dni = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                remoteId: remoteId,
                dni: dni,
                rol: rol,
                name: name,
                lastName: lastName,
                email: email,
                isActive: isActive,
                birthDate: birthDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
                needsSync: needsSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> remoteId = const Value.absent(),
                required String dni,
                Value<String> rol = const Value.absent(),
                required String name,
                required String lastName,
                required String email,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                remoteId: remoteId,
                dni: dni,
                rol: rol,
                name: name,
                lastName: lastName,
                email: email,
                isActive: isActive,
                birthDate: birthDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
                needsSync: needsSync,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionTableRefs) db.sessionTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionTableRefs)
                    await $_getPrefetchedData<
                      user_drift_model,
                      $UserTableTable,
                      SessionDriftModel
                    >(
                      currentTable: table,
                      referencedTable: $$UserTableTableReferences
                          ._sessionTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UserTableTableReferences(
                            db,
                            table,
                            p0,
                          ).sessionTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (user_drift_model, $$UserTableTableReferences),
      user_drift_model,
      PrefetchHooks Function({bool sessionTableRefs})
    >;
typedef $$SessionTableTableCreateCompanionBuilder =
    SessionTableCompanion Function({
      Value<int> id,
      required int userId,
      required String dni,
      required String email,
      Value<DateTime> lastLoginAt,
      Value<bool> isActive,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<DateTime?> tokenExpiresAt,
    });
typedef $$SessionTableTableUpdateCompanionBuilder =
    SessionTableCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> dni,
      Value<String> email,
      Value<DateTime> lastLoginAt,
      Value<bool> isActive,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<DateTime?> tokenExpiresAt,
    });

final class $$SessionTableTableReferences
    extends
        BaseReferences<
          _$AppLocalDatabase,
          $SessionTableTable,
          SessionDriftModel
        > {
  $$SessionTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserTableTable _userIdTable(_$AppLocalDatabase db) =>
      db.userTable.createAlias(
        $_aliasNameGenerator(db.sessionTable.userId, db.userTable.id),
      );

  $$UserTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UserTableTableTableManager(
      $_db,
      $_db.userTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionTableTableFilterComposer
    extends Composer<_$AppLocalDatabase, $SessionTableTable> {
  $$SessionTableTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserTableTableFilterComposer get userId {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableFilterComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $SessionTableTable> {
  $$SessionTableTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserTableTableOrderingComposer get userId {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableOrderingComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $SessionTableTable> {
  $$SessionTableTableAnnotationComposer({
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => column,
  );

  $$UserTableTableAnnotationComposer get userId {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableAnnotationComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $SessionTableTable,
          SessionDriftModel,
          $$SessionTableTableFilterComposer,
          $$SessionTableTableOrderingComposer,
          $$SessionTableTableAnnotationComposer,
          $$SessionTableTableCreateCompanionBuilder,
          $$SessionTableTableUpdateCompanionBuilder,
          (SessionDriftModel, $$SessionTableTableReferences),
          SessionDriftModel,
          PrefetchHooks Function({bool userId})
        > {
  $$SessionTableTableTableManager(
    _$AppLocalDatabase db,
    $SessionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> dni = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<DateTime> lastLoginAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<DateTime?> tokenExpiresAt = const Value.absent(),
              }) => SessionTableCompanion(
                id: id,
                userId: userId,
                dni: dni,
                email: email,
                lastLoginAt: lastLoginAt,
                isActive: isActive,
                accessToken: accessToken,
                refreshToken: refreshToken,
                tokenExpiresAt: tokenExpiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String dni,
                required String email,
                Value<DateTime> lastLoginAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<DateTime?> tokenExpiresAt = const Value.absent(),
              }) => SessionTableCompanion.insert(
                id: id,
                userId: userId,
                dni: dni,
                email: email,
                lastLoginAt: lastLoginAt,
                isActive: isActive,
                accessToken: accessToken,
                refreshToken: refreshToken,
                tokenExpiresAt: tokenExpiresAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$SessionTableTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$SessionTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $SessionTableTable,
      SessionDriftModel,
      $$SessionTableTableFilterComposer,
      $$SessionTableTableOrderingComposer,
      $$SessionTableTableAnnotationComposer,
      $$SessionTableTableCreateCompanionBuilder,
      $$SessionTableTableUpdateCompanionBuilder,
      (SessionDriftModel, $$SessionTableTableReferences),
      SessionDriftModel,
      PrefetchHooks Function({bool userId})
    >;
typedef $$CompetenceTableTableCreateCompanionBuilder =
    CompetenceTableCompanion Function({
      Value<int> id,
      required String externalId,
      required String name,
      Value<DateTime?> competitionDate,
      Value<DateTime?> competitionLimitForRegistrationDate,
      Value<int> nTurns,
      Value<int?> maxRegistrations,
      Value<bool> isActive,
      Value<bool> isFinished,
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
      Value<int?> maxRegistrations,
      Value<bool> isActive,
      Value<bool> isFinished,
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

  ColumnFilters<int> get maxRegistrations => $composableBuilder(
    column: $table.maxRegistrations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
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

  ColumnOrderings<int> get maxRegistrations => $composableBuilder(
    column: $table.maxRegistrations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
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

  GeneratedColumn<int> get maxRegistrations => $composableBuilder(
    column: $table.maxRegistrations,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

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
                Value<int?> maxRegistrations = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
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
                maxRegistrations: maxRegistrations,
                isActive: isActive,
                isFinished: isFinished,
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
                Value<int?> maxRegistrations = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
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
                maxRegistrations: maxRegistrations,
                isActive: isActive,
                isFinished: isFinished,
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
      Value<String?> externalId,
      Value<String?> registrationNumber,
      Value<int?> time,
      required String userDni,
      Value<int?> nTurns,
      required int competenceId,
    });
typedef $$CompetitionRegistrationTableTableUpdateCompanionBuilder =
    CompetitionRegistrationTableCompanion Function({
      Value<int> id,
      Value<String?> externalId,
      Value<String?> registrationNumber,
      Value<int?> time,
      Value<String> userDni,
      Value<int?> nTurns,
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

  ColumnFilters<String> get registrationNumber => $composableBuilder(
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

  ColumnOrderings<String> get registrationNumber => $composableBuilder(
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

  GeneratedColumn<String> get registrationNumber => $composableBuilder(
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
                Value<String?> externalId = const Value.absent(),
                Value<String?> registrationNumber = const Value.absent(),
                Value<int?> time = const Value.absent(),
                Value<String> userDni = const Value.absent(),
                Value<int?> nTurns = const Value.absent(),
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
                Value<String?> externalId = const Value.absent(),
                Value<String?> registrationNumber = const Value.absent(),
                Value<int?> time = const Value.absent(),
                required String userDni,
                Value<int?> nTurns = const Value.absent(),
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
typedef $$CompetitionTimeRecordTableTableCreateCompanionBuilder =
    CompetitionTimeRecordTableCompanion Function({
      Value<int> id,
      Value<String?> registrationNumber,
      required int time,
      required int competenceId,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$CompetitionTimeRecordTableTableUpdateCompanionBuilder =
    CompetitionTimeRecordTableCompanion Function({
      Value<int> id,
      Value<String?> registrationNumber,
      Value<int> time,
      Value<int> competenceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$CompetitionTimeRecordTableTableFilterComposer
    extends Composer<_$AppLocalDatabase, $CompetitionTimeRecordTableTable> {
  $$CompetitionTimeRecordTableTableFilterComposer({
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

  ColumnFilters<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get competenceId => $composableBuilder(
    column: $table.competenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompetitionTimeRecordTableTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $CompetitionTimeRecordTableTable> {
  $$CompetitionTimeRecordTableTableOrderingComposer({
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

  ColumnOrderings<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get competenceId => $composableBuilder(
    column: $table.competenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompetitionTimeRecordTableTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $CompetitionTimeRecordTableTable> {
  $$CompetitionTimeRecordTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get competenceId => $composableBuilder(
    column: $table.competenceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CompetitionTimeRecordTableTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $CompetitionTimeRecordTableTable,
          competition_time_record_drift_model,
          $$CompetitionTimeRecordTableTableFilterComposer,
          $$CompetitionTimeRecordTableTableOrderingComposer,
          $$CompetitionTimeRecordTableTableAnnotationComposer,
          $$CompetitionTimeRecordTableTableCreateCompanionBuilder,
          $$CompetitionTimeRecordTableTableUpdateCompanionBuilder,
          (
            competition_time_record_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $CompetitionTimeRecordTableTable,
              competition_time_record_drift_model
            >,
          ),
          competition_time_record_drift_model,
          PrefetchHooks Function()
        > {
  $$CompetitionTimeRecordTableTableTableManager(
    _$AppLocalDatabase db,
    $CompetitionTimeRecordTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetitionTimeRecordTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CompetitionTimeRecordTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompetitionTimeRecordTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> registrationNumber = const Value.absent(),
                Value<int> time = const Value.absent(),
                Value<int> competenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CompetitionTimeRecordTableCompanion(
                id: id,
                registrationNumber: registrationNumber,
                time: time,
                competenceId: competenceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> registrationNumber = const Value.absent(),
                required int time,
                required int competenceId,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => CompetitionTimeRecordTableCompanion.insert(
                id: id,
                registrationNumber: registrationNumber,
                time: time,
                competenceId: competenceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompetitionTimeRecordTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $CompetitionTimeRecordTableTable,
      competition_time_record_drift_model,
      $$CompetitionTimeRecordTableTableFilterComposer,
      $$CompetitionTimeRecordTableTableOrderingComposer,
      $$CompetitionTimeRecordTableTableAnnotationComposer,
      $$CompetitionTimeRecordTableTableCreateCompanionBuilder,
      $$CompetitionTimeRecordTableTableUpdateCompanionBuilder,
      (
        competition_time_record_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $CompetitionTimeRecordTableTable,
          competition_time_record_drift_model
        >,
      ),
      competition_time_record_drift_model,
      PrefetchHooks Function()
    >;

class $AppLocalDatabaseManager {
  final _$AppLocalDatabase _db;
  $AppLocalDatabaseManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$SessionTableTableTableManager get sessionTable =>
      $$SessionTableTableTableManager(_db, _db.sessionTable);
  $$CompetenceTableTableTableManager get competenceTable =>
      $$CompetenceTableTableTableManager(_db, _db.competenceTable);
  $$CompetitionRegistrationTableTableTableManager
  get competitionRegistrationTable =>
      $$CompetitionRegistrationTableTableTableManager(
        _db,
        _db.competitionRegistrationTable,
      );
  $$CompetitionTimeRecordTableTableTableManager
  get competitionTimeRecordTable =>
      $$CompetitionTimeRecordTableTableTableManager(
        _db,
        _db.competitionTimeRecordTable,
      );
}
