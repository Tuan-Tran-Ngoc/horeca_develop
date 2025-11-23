class Language {
  String? languageCode;
  String? countryCode;
  String? languageName;
  String? regionCode;

  Language(
      this.languageCode, this.countryCode, this.languageName, this.regionCode);

  Language.fromJson(Map<String, dynamic> json) {
    languageCode = json['language_code'];
    countryCode = json['country_code'];
    languageName = json['language_name'];
    regionCode = json['region_code'];
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'language_code': languageCode,
      'country_code': countryCode,
      'language_name': languageName,
      'region_code': regionCode
    };
  }

  Language.fromMap(Map<dynamic, dynamic> map) {
    languageCode = map['language_code'];
    countryCode = map['country_code'];
    languageName = map['language_name'];
    regionCode = map['region_code'];
  }
}
