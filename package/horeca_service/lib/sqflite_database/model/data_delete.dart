class DataDelete {
  String? tableName;
  String? primaryKey;
  List<dynamic>? lstDeleteIds;
  String? whereCondition;

  DataDelete(
      {this.tableName,
      this.primaryKey,
      this.lstDeleteIds,
      this.whereCondition});

  factory DataDelete.fromJson(Map<String, dynamic> json) {
    return DataDelete(
        tableName: json['tableName'],
        primaryKey: json['primaryKey'],
        lstDeleteIds: json['lstDeleteIds'],
        whereCondition: json['whereCondition']);
  }

  factory DataDelete.fromMap(Map<dynamic, dynamic> map) {
    return DataDelete(
        tableName: map['tableName'],
        primaryKey: map['primaryKey'],
        lstDeleteIds: map['lstDeleteIds'],
        whereCondition: map['whereCondition']);
  }
}
