class TransferDtl {
  int? transferDtlId;
  int? transferRequestId;
  int? productId;
  double? transferQty;
  bool? isGood;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  TransferDtl({
    this.transferDtlId,
    this.transferRequestId,
    this.productId,
    this.transferQty,
    this.isGood,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory TransferDtl.fromJson(Map<String, dynamic> json) {
    return TransferDtl(
      transferDtlId: json['transfer_dtl_id'],
      transferRequestId: json['transfer_request_id'],
      productId: json['product_id'],
      transferQty: json['transfer_qty'],
      isGood: json['is_good'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  factory TransferDtl.fromMap(Map<dynamic, dynamic> map) {
    return TransferDtl(
      transferDtlId: map['transfer_dtl_id'],
      transferRequestId: map['transfer_request_id'],
      productId: map['product_id'],
      transferQty: map['transfer_qty'],
      isGood: map['is_good'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transfer_dtl_id': transferDtlId,
      'transfer_request_id': transferRequestId,
      'product_id': productId,
      'transfer_qty': transferQty,
      'is_good': isGood,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transfer_dtl_id': transferDtlId,
      'transfer_request_id': transferRequestId,
      'product_id': productId,
      'transfer_qty': transferQty,
      'is_good': isGood,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
