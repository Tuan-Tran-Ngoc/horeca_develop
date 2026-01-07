import 'package:horeca_service/utils/json_utils.dart';

class Product {
  int? productId;
  String? productCd;
  int? productTypeId;
  String? productName;
  double? priceCost;
  int? priority;
  int? categoryId;
  int? uomId;
  int? brandId;
  String? productImg;
  int? isSalable;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Product({
    required this.productId,
    required this.productCd,
    required this.productTypeId,
    required this.productName,
    required this.priceCost,
    required this.priority,
    required this.categoryId,
    required this.uomId,
    required this.brandId,
    required this.productImg,
    required this.isSalable,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.version,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: JsonUtils.toInt(json['product_id']),
      productCd: json['product_cd'],
      productTypeId: JsonUtils.toInt(json['product_type_id']),
      productName: json['product_name'],
      priceCost: json['price_cost'],
      priority: JsonUtils.toInt(json['priority']),
      categoryId: JsonUtils.toInt(json['category_id']),
      uomId: JsonUtils.toInt(json['uom_id']),
      brandId: JsonUtils.toInt(json['brand_id']),
      productImg: json['product_img'],
      isSalable: JsonUtils.toInt(json['is_salable']),
      status: json['status'],
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }
  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      productId: map['product_id'],
      productCd: map['product_cd'],
      productTypeId: map['product_type_id'],
      productName: map['product_name'],
      priceCost: map['price_cost'],
      priority: map['priority'],
      categoryId: map['category_id'],
      uomId: map['uom_id'],
      brandId: map['brand_id'],
      productImg: map['product_img'],
      isSalable: map['is_salable'],
      status: map['status'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_cd': productCd,
      'product_type_id': productTypeId,
      'product_name': productName,
      'price_cost': priceCost,
      'priority': priority,
      'category_id': categoryId,
      'uom_id': uomId,
      'brand_id': brandId,
      'product_img': productImg,
      'is_salable': isSalable,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_id': productId,
      'product_cd': productCd,
      'product_type_id': productTypeId,
      'product_name': productName,
      'price_cost': priceCost,
      'priority': priority,
      'category_id': categoryId,
      'uom_id': uomId,
      'brand_id': brandId,
      'product_img': productImg,
      'is_salable': isSalable,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
