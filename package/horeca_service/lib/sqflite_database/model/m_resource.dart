import 'package:horeca_service/sqflite_database/model/common_column.dart';

class Resource {
  int? resourceId;
  String? categoryCd;
  String? resourceCd;
  String? value1;
  String? value2;
  String? value3;
  String? value4;
  String? value5;
  String? resourceType;
  int? deleteFlg;

  Resource({
    this.resourceId,
    this.categoryCd,
    this.resourceCd,
    this.value1,
    this.value2,
    this.value3,
    this.value4,
    this.value5,
    this.resourceType,
    this.deleteFlg,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      resourceId: json['resource_id'],
      categoryCd: json['category_cd'],
      resourceCd: json['resource_cd'],
      value1: json['value1'],
      value2: json['value2'],
      value3: json['value3'],
      value4: json['value4'],
      value5: json['value5'],
      resourceType: json['resource_type'],
      deleteFlg: json['delete_flg'],
    );
  }

  factory Resource.fromMap(Map<dynamic, dynamic> map) {
    return Resource(
      resourceId: map[columnResourceId],
      categoryCd: map[columnCategoryCd] ?? '',
      resourceCd: map[columnResourceCd] ?? '',
      value1: map[columnValue1] ?? '',
      value2: map[columnValue2] ?? '',
      value3: map[columnValue3] ?? '',
      value4: map[columnValue4] ?? '',
      value5: map[columnValue5] ?? '',
      resourceType: map[columnResourceType] ?? '',
      deleteFlg: map[columnDeleteFlg] ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnResourceId: resourceId,
      columnCategoryCd: categoryCd,
      columnResourceCd: resourceCd,
      columnValue1: value1,
      columnValue2: value2,
      columnValue3: value3,
      columnValue4: value4,
      columnValue5: value5,
      columnResourceType: resourceType,
      columnDeleteFlg: deleteFlg,
    };
  }

  @override
  String toString() {
    return 'ResourceModel(resourceId: $resourceId, categoryCd: $categoryCd, resourceCd: $resourceCd, '
        'value1: $value1, value2: $value2, value3: $value3, value4: $value4, '
        'value5: $value5, resourceType: $resourceType, deleteFlg: $deleteFlg )';
  }
}
