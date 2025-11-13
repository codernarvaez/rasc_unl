import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserModel {
  final int id;
  final String dni;
  @JsonKey(name: 'role')
  final String rol;
  @JsonKey(name: 'first_name')
  final String name;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'date_of_birth')
  final DateTime? birthDate;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.dni,
    this.rol = 'COMPETITOR',
    required this.name,
    required this.lastName,
    required this.email,
    this.isActive = true,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  bool get isAdministrator => rol == 'ADMINISTRATOR';
  bool get isCompetitor => rol == 'COMPETITOR';
}

enum UserRoleType {
  ADMINISTRATOR,
  COMPETITOR,
}
