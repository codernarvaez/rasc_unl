import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserModel {
  final int id;
  final String dni;
  final UserRoleType rol;
  final String name;
  final String lastName;
  final String email;
  final bool isActive;
  final DateTime? birthDate;

  UserModel({
    required this.id,
    required this.dni,
    this.rol = UserRoleType.COMPETITOR,
    required this.name,
    required this.lastName,
    required this.email,
    this.isActive = true,
    this.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

enum UserRoleType {
  ADMINISTRATOR,
  COMPETITOR,
}
