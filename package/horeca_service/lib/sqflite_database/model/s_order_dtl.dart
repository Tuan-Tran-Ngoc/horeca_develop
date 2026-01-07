import 'package:horeca_service/utils/json_utils.dart';

class OrderDetail {
  int? orderDetailId;
  int? orderDetailIdSync;
  int? orderId;
  int? productId;
  String? stockType;
  double? quantity;
  double? salesPrice;
  double? salesInPrice;
  double? totalAmount;
  double? cashBackAmount;
  double? collection;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  OrderDetail({
    this.orderDetailId,
    this.orderDetailIdSync,
    this.orderId,
    this.productId,
    this.stockType,
    this.quantity,
    this.salesPrice,
    this.salesInPrice,
    this.totalAmount,
    this.cashBackAmount,
    this.collection,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderDetailId: JsonUtils.toInt(json['order_dtl_id']),
      orderDetailIdSync: JsonUtils.toInt(json['order_dtl_id_sync']),
      orderId: JsonUtils.toInt(json['order_id']),
      productId: JsonUtils.toInt(json['product_id']),
      stockType: json['stock_type'],
      quantity: json['qty'],
      salesPrice: json['sales_price'],
      salesInPrice: json['sales_in_price'],
      totalAmount: json['total_amount'],
      cashBackAmount: json['cash_back_amount'],
      collection: json['collection'],
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }
  factory OrderDetail.fromMap(Map<dynamic, dynamic> map) {
    return OrderDetail(
      orderDetailId: map['order_dtl_id'],
      orderDetailIdSync: map['order_dtl_id_sync'],
      orderId: map['order_id'],
      productId: map['product_id'],
      stockType: map['stock_type'],
      quantity: map['qty'],
      salesPrice: map['sales_price'],
      salesInPrice: map['sales_in_price'],
      totalAmount: map['total_amount'],
      cashBackAmount: map['cash_back_amount'],
      collection: map['collection'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_dtl_id': orderDetailId,
      'order_dtl_id_sync': orderDetailIdSync,
      'order_id': orderId,
      'product_id': productId,
      'stock_type': stockType,
      'qty': quantity,
      'sales_price': salesPrice,
      'sales_in_price': salesInPrice,
      'total_amount': totalAmount,
      'cash_back_amount': cashBackAmount,
      'collection': collection,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_dtl_id': orderDetailId,
      'order_dtl_id_sync': orderDetailIdSync,
      'order_id': orderId,
      'product_id': productId,
      'stock_type': stockType,
      'qty': quantity,
      'sales_price': salesPrice,
      'sales_in_price': salesInPrice,
      'total_amount': totalAmount,
      'cash_back_amount': cashBackAmount,
      'collection': collection,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      'order_dtl_id': orderDetailId,
      'order_dtl_id_sync': orderDetailId,
      'order_id': orderId,
      'product_id': productId,
      'stock_type': stockType,
      'qty': quantity,
      'sales_price': salesPrice,
      'sales_in_price': salesInPrice,
      'total_amount': totalAmount,
      'cash_back_amount': cashBackAmount,
      'collection': collection,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
