import 'package:horeca_service/utils/json_utils.dart';

class AccountOffline {
  int? accountOfflineId;
  int? positionId;
  String? username;
  String? password;
  String? lastLogin;
  String? oauthString;
  String? updatedDate;

  AccountOffline(this.accountOfflineId, this.positionId, this.username,
      this.password, this.lastLogin, this.oauthString, this.updatedDate);

  AccountOffline.fromJson(Map<String, dynamic> json) {
    accountOfflineId = JsonUtils.toInt(json['account_offline_id']);
    positionId = JsonUtils.toInt(json['position_id']);
    username = json['username'];
    password = json['password'];
    lastLogin = json['last_login'];
    oauthString = json['oauth_string'];
    updatedDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_offline_id'] = accountOfflineId;
    data['position_id'] = positionId;
    data['username'] = username;
    data['password'] = password;
    data['last_login'] = lastLogin;
    data['oauth_string'] = oauthString;
    data['update_date'] = updatedDate;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account_offline_id': accountOfflineId,
      'position_id': positionId,
      'username': username,
      'password': password,
      'last_login': lastLogin,
      'oauth_string': oauthString,
      'update_date': updatedDate,
    };
  }

  AccountOffline.fromMap(Map<dynamic, dynamic> map) {
    accountOfflineId = JsonUtils.toInt(map['account_offline_id']);
    positionId = JsonUtils.toInt(map['position_id']);
    username = map['username'];
    password = map['password'];
    lastLogin = map['last_login'];
    oauthString = map['oauth_string'];
    updatedDate = map['update_date'];
  }
}
