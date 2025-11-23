class ProductBranchMapping {
  int? productBranchMappingId;
  int? productId;
  int? branchId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  ProductBranchMapping(
      this.productBranchMappingId,
      this.productId,
      this.branchId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  ProductBranchMapping.fromJson(Map<String, dynamic> json) {
    productBranchMappingId = json['product_branch_mapping_id'];
    productId = json['product_id'];
    branchId = json['branch_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_branch_mapping_id'] = productBranchMappingId;
    data['product_id'] = productId;
    data['branch_id'] = branchId;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_branch_mapping_id': productBranchMappingId,
      'product_id': productId,
      'branch_id': branchId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  ProductBranchMapping.fromMap(Map<dynamic, dynamic> map) {
    productBranchMappingId = map['product_branch_mapping_id'];
    productId = map['product_id'];
    branchId = map['branch_id'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
