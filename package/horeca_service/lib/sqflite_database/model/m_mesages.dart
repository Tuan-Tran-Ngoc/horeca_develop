class Messages {
  int? messageId;
  String? languageCode;
  String? messageCode;
  String? messageString;
  String? countryCode;
  String? remark;
  String? moduleResource;
  int? reuseFlag;

  Messages({
    this.messageId,
    this.languageCode,
    this.messageCode,
    this.messageString,
    this.countryCode,
    this.remark,
    this.moduleResource,
    this.reuseFlag,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      messageId: json['message_id'],
      languageCode: json['language_code'],
      messageCode: json['message_code'],
      messageString: json['message_string'],
      countryCode: json['country_code'],
      remark: json['remark'],
      moduleResource: json['module_resource'],
      reuseFlag: json['reuse_flg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'language_code': languageCode,
      'message_code': messageCode,
      'message_string': messageString,
      'country_code': countryCode,
      'remark': remark,
      'module_resource': moduleResource,
      'reuse_flg': reuseFlag,
    };
  }

  factory Messages.fromMap(Map<dynamic, dynamic> map) {
    return Messages(
      messageId: map['message_id'],
      languageCode: map['language_code'],
      messageCode: map['message_code'],
      messageString: map['message_string'],
      countryCode: map['country_code'],
      remark: map['remark'],
      moduleResource: map['module_resource'],
      reuseFlag: map['reuse_flag'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_id': messageId,
      'language_code': languageCode,
      'message_code': messageCode,
      'message_string': messageString,
      'country_code': countryCode,
      'remark': remark,
      'module_resource': moduleResource,
      'reuse_flag': reuseFlag,
    };
  }
}
