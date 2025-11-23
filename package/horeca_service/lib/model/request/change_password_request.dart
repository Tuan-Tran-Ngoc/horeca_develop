import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_password_request.g.dart';

@JsonSerializable()
class ChangePasswordRequest extends Equatable {
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'currentPassword')
  final String? currentPassword;
  @JsonKey(name: 'newPassword')
  final String? newPassword;
  @JsonKey(name: 'confirmPassword')
  final String? confirmPassword;

  const ChangePasswordRequest(
      {this.username,
      this.currentPassword,
      this.newPassword,
      this.confirmPassword});

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);

  factory ChangePasswordRequest.fromMap(Map<String, dynamic> map) =>
      ChangePasswordRequest.fromJson(map);
  Map<String, dynamic> toMap() => toJson();

  @override
  List<Object?> get props =>
      [username, currentPassword, newPassword, confirmPassword];
}
