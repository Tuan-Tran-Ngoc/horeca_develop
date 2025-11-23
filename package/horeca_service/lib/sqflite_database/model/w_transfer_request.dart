class TransferRequest {
  int? transferRequestId;
  String? transferCode;
  String? transferName;
  int? positionTransferId;
  int? positionTransferFromId;
  String? dateTransfer;
  String? typeTransfer;
  String? status;
  String? confirmedDate;
  int? reasonId;
  String? remark;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  TransferRequest({
    this.transferRequestId,
    this.transferCode,
    this.transferName,
    this.positionTransferId,
    this.positionTransferFromId,
    this.dateTransfer,
    this.typeTransfer,
    this.status,
    this.confirmedDate,
    this.reasonId,
    this.remark,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory TransferRequest.fromJson(Map<String, dynamic> json) {
    return TransferRequest(
      transferRequestId: json['transfer_request_id'],
      transferCode: json['transfer_code'],
      transferName: json['transfer_name'],
      positionTransferId: json['position_transfer_id'],
      positionTransferFromId: json['position_transfer_from_id'],
      dateTransfer: json['date_transfer'],
      typeTransfer: json['type_transfer'],
      status: json['status'],
      confirmedDate: json['confirmed_date'],
      reasonId: json['reason_id'],
      remark: json['remark'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  factory TransferRequest.fromMap(Map<dynamic, dynamic> map) {
    return TransferRequest(
      transferRequestId: map['transfer_request_id'],
      transferCode: map['transfer_code'],
      transferName: map['transfer_name'],
      positionTransferId: map['position_transfer_id'],
      positionTransferFromId: map['position_transfer_from_id'],
      dateTransfer: map['date_transfer'],
      typeTransfer: map['type_transfer'],
      status: map['status'],
      confirmedDate: map['confirmed_date'],
      reasonId: map['reason_id'],
      remark: map['remark'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transfer_request_id': transferRequestId,
      'transfer_code': transferCode,
      'transfer_name': transferName,
      'position_transfer_id': positionTransferId,
      'position_transfer_from_id': positionTransferFromId,
      'date_transfer': dateTransfer,
      'type_transfer': typeTransfer,
      'status': status,
      'confirmed_date': confirmedDate,
      'reason_id': reasonId,
      'remark': remark,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transfer_request_id': transferRequestId,
      'transfer_code': transferCode,
      'transfer_name': transferName,
      'position_transfer_id': positionTransferId,
      'position_transfer_from_id': positionTransferFromId,
      'date_transfer': dateTransfer,
      'type_transfer': typeTransfer,
      'status': status,
      'confirmed_date': confirmedDate,
      'reason_id': reasonId,
      'remark': remark,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
