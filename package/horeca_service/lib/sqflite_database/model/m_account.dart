class Account {
  int? accountId;
  String? username;
  String? password;
  int? accountNonExpired;
  int? accountNonLocked;
  int? credentialsNonExpired;
  int? accountRuleDefinitionId;
  int? forceChangePassword;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Account(
      this.accountId,
      this.username,
      this.password,
      this.accountNonExpired,
      this.accountNonLocked,
      this.credentialsNonExpired,
      this.accountRuleDefinitionId,
      this.forceChangePassword,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  Account.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    username = json['username'];
    password = json['password'];
    accountNonExpired = json['account_non_expired'] == true ? 1 : 0;
    accountNonLocked = json['account_non_locked'] == true ? 1 : 0;
    credentialsNonExpired = json['credentials_non_expired'] == true ? 1 : 0;
    accountRuleDefinitionId = json['account_rule_definition_id'];
    credentialsNonExpired = json['credentials_non_expired'] == true ? 1 : 0;
    forceChangePassword = json['force_change_password'] == true ? 1 : 0;
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_id'] = accountId;
    data['username'] = username;
    data['password'] = password;
    data['account_non_expired'] = accountNonExpired;
    data['account_rule_definition_id'] = accountRuleDefinitionId;
    data['force_change_password'] = forceChangePassword;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account_id': accountId,
      'username': username,
      'password': password,
      'account_non_expired': accountNonExpired,
      'account_rule_definition_id': accountRuleDefinitionId,
      'force_change_password': forceChangePassword,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  Account.fromMap(Map<dynamic, dynamic> map) {
    accountId = map['account_id'];
    username = map['username'];
    password = map['password'];
    accountNonExpired = map['account_non_expired'];
    accountRuleDefinitionId = map['account_rule_definition_id'];
    forceChangePassword = map['force_change_password'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
