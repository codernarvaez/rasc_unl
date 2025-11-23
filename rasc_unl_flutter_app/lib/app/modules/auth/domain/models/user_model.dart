import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserModel {
  final int id;
  final String dni;
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime? birthDate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.dni,
    this.role = 'MODERATOR',
    required this.firstName,
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
  
  bool get isAdministrator => role == 'ADMINISTRATOR';
  bool get isModerator => role == 'MODERATOR';
}

enum UserRoleType {
  ADMINISTRATOR,
  MODERATOR,
}
