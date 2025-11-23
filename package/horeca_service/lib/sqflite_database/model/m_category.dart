class MCategory {
  int? categoryId;
  String? categoryCode;
  String? categoryName;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  MCategory({
    this.categoryId,
    this.categoryCode,
    this.categoryName,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory MCategory.fromJson(Map<String, dynamic> json) {
    return MCategory(
      categoryId: json['category_id'],
      categoryCode: json['category_code'],
      categoryName: json['category_name'],
      status: json['status'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  factory MCategory.fromMap(Map<dynamic, dynamic> map) {
    return MCategory(
      categoryName: map['category_name'],
      categoryId: map['category_id'],
      categoryCode: map['category_code'],
      updatedBy: map['updated_by'],
      createdDate: map['created_date'],
      updatedDate: map['updated_date'],
      createdBy: map['created_by'],
      version: map['version'],
      status: map['status'],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category_name': categoryName,
      'category_id': categoryId,
      'updated_by': updatedBy,
      'category_code': categoryCode,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version,
      'status': status,
    };
  }
}
