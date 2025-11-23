class DiscountScheme {
  int? discountSchemeId;
  int? discountId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  DiscountScheme(this.discountSchemeId, this.discountId, this.createdBy,
      this.createdDate, this.updatedBy, this.updatedDate, this.version);

  DiscountScheme.fromJson(Map<String, dynamic> json) {
    discountSchemeId = json['discount_scheme_id'];
    discountId = json['discount_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'discount_scheme_id': discountSchemeId,
      'discount_id': discountId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }
}
