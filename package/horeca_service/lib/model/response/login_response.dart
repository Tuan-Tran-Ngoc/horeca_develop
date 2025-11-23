import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends Equatable {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  @JsonKey(name: 'scope')
  final String? scope;
  @JsonKey(name: 'authenResponse')
  final AuthenResponse? authenResponse;

  const LoginResponse(this.accessToken, this.tokenType, this.refreshToken,
      this.expiresIn, this.authenResponse, this.scope);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  List<Object?> get props =>
      [accessToken, tokenType, refreshToken, expiresIn, authenResponse, scope];
}

@JsonSerializable()
class AuthenResponse extends Equatable {
  @JsonKey(name: 'resultCode')
  final String? resultCode;
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'errorInfo')
  final ErrorInfo? errorInfo;

  const AuthenResponse(
      this.resultCode, this.baPositionId, this.userName, this.errorInfo);

  factory AuthenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenResponseToJson(this);

  @override
  List<Object?> get props => [
        resultCode,
        baPositionId,
        userName,
        errorInfo,
      ];
}

@JsonSerializable()
class ErrorInfo extends Equatable {
  @JsonKey(name: 'errorCode')
  final String errorCode;
  @JsonKey(name: 'errorMessage')
  final String errorMessage;

  const ErrorInfo(this.errorCode, this.errorMessage);

  factory ErrorInfo.fromJson(Map<String, dynamic> json) =>
      _$ErrorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorInfoToJson(this);

  @override
  List<Object?> get props => [errorCode, errorMessage];
}
