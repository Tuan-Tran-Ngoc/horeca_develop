import 'package:horeca_service/horeca_service.dart';

class ProductDto {
  int? productId;
  int? customerStockId;
  int? customerPriceId;
  String? productCd;
  int? productTypeId;
  String? typeName;
  String? productName;
  double? salesPrice;
  double? priceCustomer = 0;
  int? priority;
  int? categoryId;
  int? uomId;
  String? uomName;
  int? brandId;
  String? productImg;
  int? isSalable;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;
  double? quantity = 0;
  double? totalAmount;
  String? discountRate;
  double? priceCostDiscount;
  // params for discount program
  double? discountPercent;
  double? discountAmount;
  double? stockBalance;

  ProductDto(
      {this.productId,
      this.customerStockId,
      this.customerPriceId,
      this.productCd,
      this.productTypeId,
      this.typeName,
      this.productName,
      this.salesPrice,
      this.priceCustomer,
      this.priority,
      this.categoryId,
      this.uomId,
      this.uomName,
      this.brandId,
      this.productImg,
      this.isSalable,
      this.status,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version,
      this.quantity,
      this.totalAmount,
      this.discountRate,
      this.priceCostDiscount,
      this.discountPercent,
      this.discountAmount,
      this.stockBalance});

  factory ProductDto.convertDto(Product product) {
    return ProductDto(
        productId: product.productId,
        productCd: product.productCd,
        productTypeId: product.productTypeId,
        productName: product.productName,
        salesPrice: product.priceCost,
        priority: product.priority,
        categoryId: product.categoryId,
        uomId: product.uomId,
        brandId: product.brandId,
        productImg: product.productImg,
        isSalable: product.isSalable,
        status: product.status,
        createdBy: product.createdBy,
        createdDate: product.createdDate,
        updatedBy: product.updatedBy,
        updatedDate: product.updatedDate,
        version: product.version,
        quantity: 0);
  }

  factory ProductDto.fromMap(Map<dynamic, dynamic> map) {
    return ProductDto(
        productId: map['product_id'],
        customerStockId: map['customer_stock_id'],
        customerPriceId: map['customer_price_id'],
        productCd: map['product_cd'],
        productTypeId: map['product_type_id'],
        typeName: map['type_name'],
        productName: map['product_name'],
        salesPrice: map['price_cost'],
        priceCostDiscount: map['price_cost_discount'],
        priceCustomer: map['price_customer'] ?? 0,
        priority: map['priority'],
        categoryId: map['category_id'],
        uomId: map['uom_id'],
        uomName: map['uom_name'],
        brandId: map['brand_id'],
        productImg: map['product_img'],
        isSalable: map['is_salable'],
        status: map['status'],
        createdBy: map['created_by'],
        createdDate: map['created_date'],
        updatedBy: map['updated_by'],
        updatedDate: map['updated_date'],
        version: map['version'],
        quantity: map['quantity'] ?? 0,
        totalAmount: map['total_amount']);
  }

  factory ProductDto.copyWith(ProductDto obj) {
    return ProductDto(
        productId: obj.productId,
        customerStockId: obj.customerStockId,
        customerPriceId: obj.customerPriceId,
        productCd: obj.productCd,
        productTypeId: obj.productTypeId,
        typeName: obj.typeName,
        productName: obj.productName,
        salesPrice: obj.salesPrice,
        priceCostDiscount: obj.priceCostDiscount,
        priceCustomer: obj.priceCustomer,
        priority: obj.priority,
        categoryId: obj.categoryId,
        uomId: obj.uomId,
        uomName: obj.uomName,
        brandId: obj.brandId,
        productImg: obj.productImg,
        isSalable: obj.isSalable,
        status: obj.status,
        createdBy: obj.createdBy,
        createdDate: obj.createdDate,
        updatedBy: obj.updatedBy,
        updatedDate: obj.updatedDate,
        version: obj.version,
        quantity: obj.quantity,
        totalAmount: obj.totalAmount,
        stockBalance: obj.stockBalance);
  }
}
