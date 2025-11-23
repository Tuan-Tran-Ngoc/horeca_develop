// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      json['access_token'] as String?,
      json['token_type'] as String?,
      json['refresh_token'] as String?,
      json['expires_in'] as int?,
      json['authenResponse'] == null
          ? null
          : AuthenResponse.fromJson(
              json['authenResponse'] as Map<String, dynamic>),
      json['scope'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
      'scope': instance.scope,
      'authenResponse': instance.authenResponse,
    };

AuthenResponse _$AuthenResponseFromJson(Map<String, dynamic> json) =>
    AuthenResponse(
      json['resultCode'] as String?,
      json['baPositionId'] as int?,
      json['userName'] as String?,
      json['errorInfo'] == null
          ? null
          : ErrorInfo.fromJson(json['errorInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthenResponseToJson(AuthenResponse instance) =>
    <String, dynamic>{
      'resultCode': instance.resultCode,
      'baPositionId': instance.baPositionId,
      'userName': instance.userName,
      'errorInfo': instance.errorInfo,
    };

ErrorInfo _$ErrorInfoFromJson(Map<String, dynamic> json) => ErrorInfo(
      json['errorCode'] as String,
      json['errorMessage'] as String,
    );

Map<String, dynamic> _$ErrorInfoToJson(ErrorInfo instance) => <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
    };
