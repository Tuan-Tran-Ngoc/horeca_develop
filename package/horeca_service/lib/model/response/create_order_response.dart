import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_order_response.g.dart';

@JsonSerializable()
class CreateOrderResponse extends Equatable {
  @JsonKey(name: 'orderId')
  final int? orderId;
  @JsonKey(name: 'orderCd')
  final String? orderCd;
  @JsonKey(name: 'tabletOrderId')
  final int? tabletOrderId;
  @JsonKey(name: 'supPositionId')
  final int? supPositionId;
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'cityLeaderPositionId')
  final int? cityLeaderPositionId;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'customerId')
  final int? customerId;
  @JsonKey(name: 'customerVisitId')
  final int? customerVisitId;
  @JsonKey(name: 'horecaStatus')
  final String? horecaStatus;
  @JsonKey(name: 'orderType')
  final String? orderType;
  @JsonKey(name: 'errorFlg')
  final dynamic errorFlg;
  @JsonKey(name: 'errorString')
  final String? errorString;
  @JsonKey(name: 'poNo')
  final String? poNo;
  @JsonKey(name: 'sapOrderNo')
  final String? sapOrderNo;
  @JsonKey(name: 'lstDelivery')
  final List<SAPDelivery>? lstDelivery;
  @JsonKey(name: 'lstSAPDetail')
  final List<SAPDetail>? lstSAPDetail;
  @JsonKey(name: 'orderDtls')
  final List<OrderDtlResponse>? orderDtls;
  @JsonKey(name: 'orderDiscountResults')
  final List<OrderDiscountResponse>? orderDiscountResults;
  @JsonKey(name: 'orderPromotionResults')
  final List<OrderPromotionResponse>? orderPromotionResults;

  const CreateOrderResponse({
    this.orderId,
    this.orderCd,
    this.tabletOrderId,
    this.supPositionId,
    this.baPositionId,
    this.cityLeaderPositionId,
    this.status,
    this.customerId,
    this.customerVisitId,
    this.horecaStatus,
    this.orderType,
    this.errorFlg,
    this.errorString,
    this.poNo,
    this.sapOrderNo,
    this.lstDelivery,
    this.lstSAPDetail,
    this.orderDtls,
    this.orderDiscountResults,
    this.orderPromotionResults,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);

  @override
  List<Object?> get props => [
        orderId,
        orderCd,
        tabletOrderId,
        supPositionId,
        baPositionId,
        cityLeaderPositionId,
        status,
        customerId,
        customerVisitId,
        horecaStatus,
        orderType,
        errorFlg,
        errorString,
        poNo,
        sapOrderNo,
        lstDelivery,
        lstSAPDetail,
        orderDtls,
        orderDiscountResults,
        orderPromotionResults,
      ];
}

@JsonSerializable()
class OrderDtlResponse extends Equatable {
  @JsonKey(name: 'orderDtlId')
  final int? orderDtlId;
  @JsonKey(name: 'productId')
  final int? productId;
  @JsonKey(name: 'stockType')
  final String? stockType;
  @JsonKey(name: 'qty')
  final double? qty;
  @JsonKey(name: 'salesPrice')
  final double? salesPrice;
  @JsonKey(name: 'salesInPrice')
  final double? salesInPrice;
  @JsonKey(name: 'totalAmount')
  final double? totalAmount;
  @JsonKey(name: 'orderId')
  final int? orderId;
  @JsonKey(name: 'createdBy')
  final int? createdBy;
  @JsonKey(name: 'createdDate')
  final String? createdDate;
  @JsonKey(name: 'updatedBy')
  final int? updatedBy;
  @JsonKey(name: 'updatedDate')
  final String? updatedDate;

  const OrderDtlResponse(
      {this.orderDtlId,
      this.stockType,
      this.qty,
      this.salesPrice,
      this.salesInPrice,
      this.totalAmount,
      this.orderId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.productId});

  factory OrderDtlResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDtlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtlResponseToJson(this);

  @override
  List<Object?> get props => [
        orderDtlId,
        stockType,
        qty,
        salesPrice,
        salesInPrice,
        totalAmount,
        orderId,
        createdBy,
        createdDate,
        updatedBy,
        updatedDate,
        productId
      ];
}

@JsonSerializable()
class OrderPromotionResponse extends Equatable {
  @JsonKey(name: 'promotionResultId')
  final int? promotionResultId;
  @JsonKey(name: 'orderId')
  final int? orderId;
  @JsonKey(name: 'promotionId')
  final int? promotionId;
  @JsonKey(name: 'promotionSchemeId')
  final int? promotionSchemeId;
  @JsonKey(name: 'productId')
  final int? productId;
  @JsonKey(name: 'qty')
  final double? qty;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'createdBy')
  final int? createdBy;
  @JsonKey(name: 'createdDate')
  final String? createdDate;
  @JsonKey(name: 'updatedBy')
  final int? updatedBy;
  @JsonKey(name: 'updatedDate')
  final String? updatedDate;

  const OrderPromotionResponse(
      {this.promotionResultId,
      this.orderId,
      this.promotionId,
      this.promotionSchemeId,
      this.qty,
      this.description,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.productId});

  factory OrderPromotionResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderPromotionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPromotionResponseToJson(this);

  @override
  List<Object?> get props => [
        promotionResultId,
        orderId,
        promotionId,
        promotionSchemeId,
        qty,
        description,
        createdBy,
        createdDate,
        updatedBy,
        updatedDate,
        productId
      ];
}

@JsonSerializable()
class OrderDiscountResponse extends Equatable {
  @JsonKey(name: 'discountResultId')
  final int? discountResultId;
  @JsonKey(name: 'orderId')
  final int? orderId;
  @JsonKey(name: 'discountId')
  final int? discountId;
  @JsonKey(name: 'discountSchemeId')
  final int? discountSchemeId;
  @JsonKey(name: 'discountType')
  final String? discountType;
  @JsonKey(name: 'discountValue')
  final double? discountValue;
  @JsonKey(name: 'totalDiscount')
  final double? totalDiscount;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'productId')
  final int? productId;
  @JsonKey(name: 'createdBy')
  final int? createdBy;
  @JsonKey(name: 'createdDate')
  final String? createdDate;
  @JsonKey(name: 'updatedBy')
  final int? updatedBy;
  @JsonKey(name: 'updatedDate')
  final String? updatedDate;

  const OrderDiscountResponse(
      {this.discountResultId,
      this.orderId,
      this.discountId,
      this.discountSchemeId,
      this.discountType,
      this.discountValue,
      this.totalDiscount,
      this.description,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.productId});

  factory OrderDiscountResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDiscountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDiscountResponseToJson(this);

  @override
  List<Object?> get props => [
        discountResultId,
        orderId,
        discountId,
        discountSchemeId,
        discountType,
        discountValue,
        totalDiscount,
        description,
        createdBy,
        createdDate,
        updatedBy,
        updatedDate,
        productId
      ];
}

@JsonSerializable()
class SAPDelivery extends Equatable {
  @JsonKey(name: 'deliveryNo')
  final String? deliveryNo;
  @JsonKey(name: 'deliveryStatus')
  final String? deliveryStatus;
  @JsonKey(name: 'deliveryDate')
  final String? deliveryDate;
  @JsonKey(name: 'truckId')
  final int? truckId;
  @JsonKey(name: 'remark')
  final String? remark;

  const SAPDelivery({
    this.deliveryNo,
    this.deliveryStatus,
    this.deliveryDate,
    this.truckId,
    this.remark,
  });

  factory SAPDelivery.fromJson(Map<String, dynamic> json) =>
      _$SAPDeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$SAPDeliveryToJson(this);

  @override
  List<Object?> get props => [
        deliveryNo,
        deliveryStatus,
        deliveryDate,
        truckId,
        remark,
      ];
}

@JsonSerializable()
class SAPDetail extends Equatable {
  @JsonKey(name: 'productCd')
  final String? productCd;
  @JsonKey(name: 'productName')
  final String? productName;
  @JsonKey(name: 'itemCategory')
  final String? itemCategory;
  @JsonKey(name: 'unit')
  final String? unit;
  @JsonKey(name: 'qty')
  final double? qty;
  @JsonKey(name: 'shippedQty')
  final double? shippedQty;
  @JsonKey(name: 'unitPrice')
  final double? unitPrice;
  @JsonKey(name: 'discount')
  final double? discount;
  @JsonKey(name: 'unitDiscount')
  final double? unitDiscount;
  @JsonKey(name: 'productValue')
  final double? productValue;
  @JsonKey(name: 'productDiscount')
  final double? productDiscount;
  @JsonKey(name: 'vat')
  final double? vat;
  @JsonKey(name: 'taxAmount')
  final double? taxAmount;
  @JsonKey(name: 'totalAmount')
  final double? totalAmount;

  const SAPDetail({
    this.productCd,
    this.productName,
    this.itemCategory,
    this.unit,
    this.qty,
    this.shippedQty,
    this.unitPrice,
    this.discount,
    this.unitDiscount,
    this.productValue,
    this.productDiscount,
    this.vat,
    this.taxAmount,
    this.totalAmount,
  });

  factory SAPDetail.fromJson(Map<String, dynamic> json) =>
      _$SAPDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SAPDetailToJson(this);

  @override
  List<Object?> get props => [
        productCd,
        productName,
        itemCategory,
        unit,
        qty,
        shippedQty,
        unitPrice,
        discount,
        unitDiscount,
        productValue,
        productDiscount,
        vat,
        taxAmount,
        totalAmount,
      ];
}
