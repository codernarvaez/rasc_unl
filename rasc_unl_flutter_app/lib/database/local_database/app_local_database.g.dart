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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MODERATOR'),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dni,
    role,
    firstName,
    lastName,
    email,
    birthDate,
    isActive,
    createdAt,
    updatedAt,
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
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
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
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class user_drift_model extends DataClass
    implements Insertable<user_drift_model> {
  final int id;
  final String dni;
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime? birthDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const user_drift_model({
    required this.id,
    required this.dni,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dni'] = Variable<String>(dni);
    map['role'] = Variable<String>(role);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      dni: Value(dni),
      role: Value(role),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email: Value(email),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      role: serializer.fromJson<String>(json['role']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String>(json['email']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dni': serializer.toJson<String>(dni),
      'role': serializer.toJson<String>(role),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String>(email),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  user_drift_model copyWith({
    int? id,
    String? dni,
    String? role,
    String? firstName,
    String? lastName,
    String? email,
    Value<DateTime?> birthDate = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => user_drift_model(
    id: id ?? this.id,
    dni: dni ?? this.dni,
    role: role ?? this.role,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  user_drift_model copyWithCompanion(UserTableCompanion data) {
    return user_drift_model(
      id: data.id.present ? data.id.value : this.id,
      dni: data.dni.present ? data.dni.value : this.dni,
      role: data.role.present ? data.role.value : this.role,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('user_drift_model(')
          ..write('id: $id, ')
          ..write('dni: $dni, ')
          ..write('role: $role, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('birthDate: $birthDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dni,
    role,
    firstName,
    lastName,
    email,
    birthDate,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is user_drift_model &&
          other.id == this.id &&
          other.dni == this.dni &&
          other.role == this.role &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.birthDate == this.birthDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserTableCompanion extends UpdateCompanion<user_drift_model> {
  final Value<int> id;
  final Value<String> dni;
  final Value<String> role;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> email;
  final Value<DateTime?> birthDate;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.dni = const Value.absent(),
    this.role = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String dni,
    this.role = const Value.absent(),
    required String firstName,
    required String lastName,
    required String email,
    this.birthDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : dni = Value(dni),
       firstName = Value(firstName),
       lastName = Value(lastName),
       email = Value(email);
  static Insertable<user_drift_model> custom({
    Expression<int>? id,
    Expression<String>? dni,
    Expression<String>? role,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<DateTime>? birthDate,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dni != null) 'dni': dni,
      if (role != null) 'role': role,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (birthDate != null) 'birth_date': birthDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserTableCompanion copyWith({
    Value<int>? id,
    Value<String>? dni,
    Value<String>? role,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? email,
    Value<DateTime?>? birthDate,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      isActive: isActive ?? this.isActive,
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
    if (dni.present) {
      map['dni'] = Variable<String>(dni.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('dni: $dni, ')
          ..write('role: $role, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('birthDate: $birthDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    competitionDate,
    isActive,
    isFinished,
    createdBy,
    createdAt,
    updatedAt,
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
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      competitionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}competition_date'],
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CompetenceTableTable createAlias(String alias) {
    return $CompetenceTableTable(attachedDatabase, alias);
  }
}

class competence_drift_model extends DataClass
    implements Insertable<competence_drift_model> {
  final int id;
  final String name;
  final DateTime? competitionDate;
  final bool isActive;
  final bool isFinished;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const competence_drift_model({
    required this.id,
    required this.name,
    this.competitionDate,
    required this.isActive,
    required this.isFinished,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || competitionDate != null) {
      map['competition_date'] = Variable<DateTime>(competitionDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_finished'] = Variable<bool>(isFinished);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CompetenceTableCompanion toCompanion(bool nullToAbsent) {
    return CompetenceTableCompanion(
      id: Value(id),
      name: Value(name),
      competitionDate: competitionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(competitionDate),
      isActive: Value(isActive),
      isFinished: Value(isFinished),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory competence_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return competence_drift_model(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      competitionDate: serializer.fromJson<DateTime?>(json['competitionDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'competitionDate': serializer.toJson<DateTime?>(competitionDate),
      'isActive': serializer.toJson<bool>(isActive),
      'isFinished': serializer.toJson<bool>(isFinished),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  competence_drift_model copyWith({
    int? id,
    String? name,
    Value<DateTime?> competitionDate = const Value.absent(),
    bool? isActive,
    bool? isFinished,
    String? createdBy,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => competence_drift_model(
    id: id ?? this.id,
    name: name ?? this.name,
    competitionDate: competitionDate.present
        ? competitionDate.value
        : this.competitionDate,
    isActive: isActive ?? this.isActive,
    isFinished: isFinished ?? this.isFinished,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  competence_drift_model copyWithCompanion(CompetenceTableCompanion data) {
    return competence_drift_model(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      competitionDate: data.competitionDate.present
          ? data.competitionDate.value
          : this.competitionDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('competence_drift_model(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('competitionDate: $competitionDate, ')
          ..write('isActive: $isActive, ')
          ..write('isFinished: $isFinished, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    competitionDate,
    isActive,
    isFinished,
    createdBy,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is competence_drift_model &&
          other.id == this.id &&
          other.name == this.name &&
          other.competitionDate == this.competitionDate &&
          other.isActive == this.isActive &&
          other.isFinished == this.isFinished &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompetenceTableCompanion extends UpdateCompanion<competence_drift_model> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> competitionDate;
  final Value<bool> isActive;
  final Value<bool> isFinished;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const CompetenceTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.competitionDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompetenceTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.competitionDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isFinished = const Value.absent(),
    required String createdBy,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       createdBy = Value(createdBy);
  static Insertable<competence_drift_model> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? competitionDate,
    Expression<bool>? isActive,
    Expression<bool>? isFinished,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (competitionDate != null) 'competition_date': competitionDate,
      if (isActive != null) 'is_active': isActive,
      if (isFinished != null) 'is_finished': isFinished,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompetenceTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime?>? competitionDate,
    Value<bool>? isActive,
    Value<bool>? isFinished,
    Value<String>? createdBy,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return CompetenceTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      competitionDate: competitionDate ?? this.competitionDate,
      isActive: isActive ?? this.isActive,
      isFinished: isFinished ?? this.isFinished,
      createdBy: createdBy ?? this.createdBy,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (competitionDate.present) {
      map['competition_date'] = Variable<DateTime>(competitionDate.value);
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
    return (StringBuffer('CompetenceTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('competitionDate: $competitionDate, ')
          ..write('isActive: $isActive, ')
          ..write('isFinished: $isFinished, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  static const VerificationMeta _dorsalNumberMeta = const VerificationMeta(
    'dorsalNumber',
  );
  @override
  late final GeneratedColumn<String> dorsalNumber = GeneratedColumn<String>(
    'dorsal_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nParticipantsMeta = const VerificationMeta(
    'nParticipants',
  );
  @override
  late final GeneratedColumn<int> nParticipants = GeneratedColumn<int>(
    'n_participants',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dorsalNumber,
    nParticipants,
    name,
    userDni,
    competenceId,
    createdAt,
    updatedAt,
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
    if (data.containsKey('dorsal_number')) {
      context.handle(
        _dorsalNumberMeta,
        dorsalNumber.isAcceptableOrUnknown(
          data['dorsal_number']!,
          _dorsalNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dorsalNumberMeta);
    }
    if (data.containsKey('n_participants')) {
      context.handle(
        _nParticipantsMeta,
        nParticipants.isAcceptableOrUnknown(
          data['n_participants']!,
          _nParticipantsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nParticipantsMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('user_dni')) {
      context.handle(
        _userDniMeta,
        userDni.isAcceptableOrUnknown(data['user_dni']!, _userDniMeta),
      );
    } else if (isInserting) {
      context.missing(_userDniMeta);
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
      dorsalNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dorsal_number'],
      )!,
      nParticipants: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_participants'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      userDni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_dni'],
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
      ),
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
  final String dorsalNumber;
  final int nParticipants;
  final String name;
  final String userDni;
  final int competenceId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const competition_registration_drift_model({
    required this.id,
    required this.dorsalNumber,
    required this.nParticipants,
    required this.name,
    required this.userDni,
    required this.competenceId,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dorsal_number'] = Variable<String>(dorsalNumber);
    map['n_participants'] = Variable<int>(nParticipants);
    map['name'] = Variable<String>(name);
    map['user_dni'] = Variable<String>(userDni);
    map['competence_id'] = Variable<int>(competenceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CompetitionRegistrationTableCompanion toCompanion(bool nullToAbsent) {
    return CompetitionRegistrationTableCompanion(
      id: Value(id),
      dorsalNumber: Value(dorsalNumber),
      nParticipants: Value(nParticipants),
      name: Value(name),
      userDni: Value(userDni),
      competenceId: Value(competenceId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory competition_registration_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return competition_registration_drift_model(
      id: serializer.fromJson<int>(json['id']),
      dorsalNumber: serializer.fromJson<String>(json['dorsalNumber']),
      nParticipants: serializer.fromJson<int>(json['nParticipants']),
      name: serializer.fromJson<String>(json['name']),
      userDni: serializer.fromJson<String>(json['userDni']),
      competenceId: serializer.fromJson<int>(json['competenceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dorsalNumber': serializer.toJson<String>(dorsalNumber),
      'nParticipants': serializer.toJson<int>(nParticipants),
      'name': serializer.toJson<String>(name),
      'userDni': serializer.toJson<String>(userDni),
      'competenceId': serializer.toJson<int>(competenceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  competition_registration_drift_model copyWith({
    int? id,
    String? dorsalNumber,
    int? nParticipants,
    String? name,
    String? userDni,
    int? competenceId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => competition_registration_drift_model(
    id: id ?? this.id,
    dorsalNumber: dorsalNumber ?? this.dorsalNumber,
    nParticipants: nParticipants ?? this.nParticipants,
    name: name ?? this.name,
    userDni: userDni ?? this.userDni,
    competenceId: competenceId ?? this.competenceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  competition_registration_drift_model copyWithCompanion(
    CompetitionRegistrationTableCompanion data,
  ) {
    return competition_registration_drift_model(
      id: data.id.present ? data.id.value : this.id,
      dorsalNumber: data.dorsalNumber.present
          ? data.dorsalNumber.value
          : this.dorsalNumber,
      nParticipants: data.nParticipants.present
          ? data.nParticipants.value
          : this.nParticipants,
      name: data.name.present ? data.name.value : this.name,
      userDni: data.userDni.present ? data.userDni.value : this.userDni,
      competenceId: data.competenceId.present
          ? data.competenceId.value
          : this.competenceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('competition_registration_drift_model(')
          ..write('id: $id, ')
          ..write('dorsalNumber: $dorsalNumber, ')
          ..write('nParticipants: $nParticipants, ')
          ..write('name: $name, ')
          ..write('userDni: $userDni, ')
          ..write('competenceId: $competenceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dorsalNumber,
    nParticipants,
    name,
    userDni,
    competenceId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is competition_registration_drift_model &&
          other.id == this.id &&
          other.dorsalNumber == this.dorsalNumber &&
          other.nParticipants == this.nParticipants &&
          other.name == this.name &&
          other.userDni == this.userDni &&
          other.competenceId == this.competenceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompetitionRegistrationTableCompanion
    extends UpdateCompanion<competition_registration_drift_model> {
  final Value<int> id;
  final Value<String> dorsalNumber;
  final Value<int> nParticipants;
  final Value<String> name;
  final Value<String> userDni;
  final Value<int> competenceId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const CompetitionRegistrationTableCompanion({
    this.id = const Value.absent(),
    this.dorsalNumber = const Value.absent(),
    this.nParticipants = const Value.absent(),
    this.name = const Value.absent(),
    this.userDni = const Value.absent(),
    this.competenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompetitionRegistrationTableCompanion.insert({
    this.id = const Value.absent(),
    required String dorsalNumber,
    required int nParticipants,
    required String name,
    required String userDni,
    required int competenceId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  }) : dorsalNumber = Value(dorsalNumber),
       nParticipants = Value(nParticipants),
       name = Value(name),
       userDni = Value(userDni),
       competenceId = Value(competenceId),
       createdAt = Value(createdAt);
  static Insertable<competition_registration_drift_model> custom({
    Expression<int>? id,
    Expression<String>? dorsalNumber,
    Expression<int>? nParticipants,
    Expression<String>? name,
    Expression<String>? userDni,
    Expression<int>? competenceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dorsalNumber != null) 'dorsal_number': dorsalNumber,
      if (nParticipants != null) 'n_participants': nParticipants,
      if (name != null) 'name': name,
      if (userDni != null) 'user_dni': userDni,
      if (competenceId != null) 'competence_id': competenceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompetitionRegistrationTableCompanion copyWith({
    Value<int>? id,
    Value<String>? dorsalNumber,
    Value<int>? nParticipants,
    Value<String>? name,
    Value<String>? userDni,
    Value<int>? competenceId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return CompetitionRegistrationTableCompanion(
      id: id ?? this.id,
      dorsalNumber: dorsalNumber ?? this.dorsalNumber,
      nParticipants: nParticipants ?? this.nParticipants,
      name: name ?? this.name,
      userDni: userDni ?? this.userDni,
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
    if (dorsalNumber.present) {
      map['dorsal_number'] = Variable<String>(dorsalNumber.value);
    }
    if (nParticipants.present) {
      map['n_participants'] = Variable<int>(nParticipants.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (userDni.present) {
      map['user_dni'] = Variable<String>(userDni.value);
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
    return (StringBuffer('CompetitionRegistrationTableCompanion(')
          ..write('id: $id, ')
          ..write('dorsalNumber: $dorsalNumber, ')
          ..write('nParticipants: $nParticipants, ')
          ..write('name: $name, ')
          ..write('userDni: $userDni, ')
          ..write('competenceId: $competenceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _competitionRegistrationIdMeta =
      const VerificationMeta('competitionRegistrationId');
  @override
  late final GeneratedColumn<int> competitionRegistrationId =
      GeneratedColumn<int>(
        'competition_registration_id',
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
    time,
    competitionRegistrationId,
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
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('competition_registration_id')) {
      context.handle(
        _competitionRegistrationIdMeta,
        competitionRegistrationId.isAcceptableOrUnknown(
          data['competition_registration_id']!,
          _competitionRegistrationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competitionRegistrationIdMeta);
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
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      )!,
      competitionRegistrationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}competition_registration_id'],
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
  final int time;
  final int competitionRegistrationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const competition_time_record_drift_model({
    required this.id,
    required this.time,
    required this.competitionRegistrationId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<int>(time);
    map['competition_registration_id'] = Variable<int>(
      competitionRegistrationId,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CompetitionTimeRecordTableCompanion toCompanion(bool nullToAbsent) {
    return CompetitionTimeRecordTableCompanion(
      id: Value(id),
      time: Value(time),
      competitionRegistrationId: Value(competitionRegistrationId),
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
      time: serializer.fromJson<int>(json['time']),
      competitionRegistrationId: serializer.fromJson<int>(
        json['competitionRegistrationId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<int>(time),
      'competitionRegistrationId': serializer.toJson<int>(
        competitionRegistrationId,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  competition_time_record_drift_model copyWith({
    int? id,
    int? time,
    int? competitionRegistrationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => competition_time_record_drift_model(
    id: id ?? this.id,
    time: time ?? this.time,
    competitionRegistrationId:
        competitionRegistrationId ?? this.competitionRegistrationId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  competition_time_record_drift_model copyWithCompanion(
    CompetitionTimeRecordTableCompanion data,
  ) {
    return competition_time_record_drift_model(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      competitionRegistrationId: data.competitionRegistrationId.present
          ? data.competitionRegistrationId.value
          : this.competitionRegistrationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('competition_time_record_drift_model(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('competitionRegistrationId: $competitionRegistrationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, time, competitionRegistrationId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is competition_time_record_drift_model &&
          other.id == this.id &&
          other.time == this.time &&
          other.competitionRegistrationId == this.competitionRegistrationId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompetitionTimeRecordTableCompanion
    extends UpdateCompanion<competition_time_record_drift_model> {
  final Value<int> id;
  final Value<int> time;
  final Value<int> competitionRegistrationId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CompetitionTimeRecordTableCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.competitionRegistrationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompetitionTimeRecordTableCompanion.insert({
    this.id = const Value.absent(),
    required int time,
    required int competitionRegistrationId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : time = Value(time),
       competitionRegistrationId = Value(competitionRegistrationId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<competition_time_record_drift_model> custom({
    Expression<int>? id,
    Expression<int>? time,
    Expression<int>? competitionRegistrationId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (competitionRegistrationId != null)
        'competition_registration_id': competitionRegistrationId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompetitionTimeRecordTableCompanion copyWith({
    Value<int>? id,
    Value<int>? time,
    Value<int>? competitionRegistrationId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CompetitionTimeRecordTableCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      competitionRegistrationId:
          competitionRegistrationId ?? this.competitionRegistrationId,
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
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (competitionRegistrationId.present) {
      map['competition_registration_id'] = Variable<int>(
        competitionRegistrationId.value,
      );
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
          ..write('time: $time, ')
          ..write('competitionRegistrationId: $competitionRegistrationId, ')
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
      required String dni,
      Value<String> role,
      required String firstName,
      required String lastName,
      required String email,
      Value<DateTime?> birthDate,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      Value<String> dni,
      Value<String> role,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> email,
      Value<DateTime?> birthDate,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
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

  ColumnFilters<String> get dni => $composableBuilder(
    column: $table.dni,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
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

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnOrderings<String> get dni => $composableBuilder(
    column: $table.dni,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
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

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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
                Value<String> dni = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                dni: dni,
                role: role,
                firstName: firstName,
                lastName: lastName,
                email: email,
                birthDate: birthDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dni,
                Value<String> role = const Value.absent(),
                required String firstName,
                required String lastName,
                required String email,
                Value<DateTime?> birthDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                dni: dni,
                role: role,
                firstName: firstName,
                lastName: lastName,
                email: email,
                birthDate: birthDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
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
      required String name,
      Value<DateTime?> competitionDate,
      Value<bool> isActive,
      Value<bool> isFinished,
      required String createdBy,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$CompetenceTableTableUpdateCompanionBuilder =
    CompetenceTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime?> competitionDate,
      Value<bool> isActive,
      Value<bool> isFinished,
      Value<String> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get competitionDate => $composableBuilder(
    column: $table.competitionDate,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get competitionDate => $composableBuilder(
    column: $table.competitionDate,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get competitionDate => $composableBuilder(
    column: $table.competitionDate,
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
                Value<String> name = const Value.absent(),
                Value<DateTime?> competitionDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CompetenceTableCompanion(
                id: id,
                name: name,
                competitionDate: competitionDate,
                isActive: isActive,
                isFinished: isFinished,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime?> competitionDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                required String createdBy,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CompetenceTableCompanion.insert(
                id: id,
                name: name,
                competitionDate: competitionDate,
                isActive: isActive,
                isFinished: isFinished,
                createdBy: createdBy,
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
      required String dorsalNumber,
      required int nParticipants,
      required String name,
      required String userDni,
      required int competenceId,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$CompetitionRegistrationTableTableUpdateCompanionBuilder =
    CompetitionRegistrationTableCompanion Function({
      Value<int> id,
      Value<String> dorsalNumber,
      Value<int> nParticipants,
      Value<String> name,
      Value<String> userDni,
      Value<int> competenceId,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
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

  ColumnFilters<String> get dorsalNumber => $composableBuilder(
    column: $table.dorsalNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nParticipants => $composableBuilder(
    column: $table.nParticipants,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userDni => $composableBuilder(
    column: $table.userDni,
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

  ColumnOrderings<String> get dorsalNumber => $composableBuilder(
    column: $table.dorsalNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nParticipants => $composableBuilder(
    column: $table.nParticipants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userDni => $composableBuilder(
    column: $table.userDni,
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

  GeneratedColumn<String> get dorsalNumber => $composableBuilder(
    column: $table.dorsalNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nParticipants => $composableBuilder(
    column: $table.nParticipants,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get userDni =>
      $composableBuilder(column: $table.userDni, builder: (column) => column);

  GeneratedColumn<int> get competenceId => $composableBuilder(
    column: $table.competenceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
                Value<String> dorsalNumber = const Value.absent(),
                Value<int> nParticipants = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> userDni = const Value.absent(),
                Value<int> competenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CompetitionRegistrationTableCompanion(
                id: id,
                dorsalNumber: dorsalNumber,
                nParticipants: nParticipants,
                name: name,
                userDni: userDni,
                competenceId: competenceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dorsalNumber,
                required int nParticipants,
                required String name,
                required String userDni,
                required int competenceId,
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CompetitionRegistrationTableCompanion.insert(
                id: id,
                dorsalNumber: dorsalNumber,
                nParticipants: nParticipants,
                name: name,
                userDni: userDni,
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
      required int time,
      required int competitionRegistrationId,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$CompetitionTimeRecordTableTableUpdateCompanionBuilder =
    CompetitionTimeRecordTableCompanion Function({
      Value<int> id,
      Value<int> time,
      Value<int> competitionRegistrationId,
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

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get competitionRegistrationId => $composableBuilder(
    column: $table.competitionRegistrationId,
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

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get competitionRegistrationId => $composableBuilder(
    column: $table.competitionRegistrationId,
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

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get competitionRegistrationId => $composableBuilder(
    column: $table.competitionRegistrationId,
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
                Value<int> time = const Value.absent(),
                Value<int> competitionRegistrationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CompetitionTimeRecordTableCompanion(
                id: id,
                time: time,
                competitionRegistrationId: competitionRegistrationId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int time,
                required int competitionRegistrationId,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => CompetitionTimeRecordTableCompanion.insert(
                id: id,
                time: time,
                competitionRegistrationId: competitionRegistrationId,
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
