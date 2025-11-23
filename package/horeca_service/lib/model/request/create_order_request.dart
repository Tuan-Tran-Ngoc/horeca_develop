import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

@JsonSerializable()
class CreateOrderRequest extends Equatable {
  @JsonKey(name: 'orderId')
  final int? orderId;
  @JsonKey(name: 'orderCd')
  final String? orderCd;
  @JsonKey(name: 'customerId')
  final int? customerId;
  @JsonKey(name: 'customerVisitId')
  final int? customerVisitId;
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'employeeId')
  final int? employeeId;
  @JsonKey(name: 'orderDate')
  final String? orderDate;
  @JsonKey(name: 'totalAmount')
  final double? totalAmount;
  @JsonKey(name: 'vat')
  final double? vat;
  @JsonKey(name: 'orderType')
  final String? orderType;
  @JsonKey(name: 'totalDiscount')
  final double? totalDiscount;
  @JsonKey(name: 'remark')
  final String? remark;
  @JsonKey(name: 'orderDtls')
  final List<OrderDtl>? orderDtls;
  @JsonKey(name: 'createdBy')
  final int? createdBy;
  @JsonKey(name: 'createdDate')
  final String? createdDate;
  @JsonKey(name: 'updatedBy')
  final int? updatedBy;
  @JsonKey(name: 'updatedDate')
  final String? updatedDate;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'horecaStatus')
  final String? horecaStatus;
  @JsonKey(name: 'orderDiscountResults')
  final List<OrderDiscountResultRequest>? orderDiscountResults;
  @JsonKey(name: 'orderPromotionResults')
  final List<OrderPromotionResultRequest>? orderPromotionResults;
  @JsonKey(name: 'grandTotalAmount')
  final double? grandTotalAmount;
  @JsonKey(name: 'tabletOrderId')
  final int? tabletOrderId;
  @JsonKey(name: 'poNo')
  final String? poNo;
  @JsonKey(name: 'expectDeliveryDate')
  final String? expectDeliveryDate;

  const CreateOrderRequest(
      {this.tabletOrderId,
      this.poNo,
      this.expectDeliveryDate,
      this.createdBy,
      this.orderType,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.orderId,
      this.orderCd,
      this.customerId,
      this.customerVisitId,
      this.baPositionId,
      this.employeeId,
      this.orderDate,
      this.totalAmount,
      this.vat,
      this.totalDiscount,
      this.status,
      this.horecaStatus,
      this.remark,
      this.orderDtls,
      this.orderDiscountResults,
      this.orderPromotionResults,
      this.grandTotalAmount});

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);

  @override
  List<Object?> get props => [
        createdBy,
        createdDate,
        updatedBy,
        updatedDate,
        orderId,
        orderCd,
        customerId,
        customerVisitId,
        baPositionId,
        employeeId,
        orderDate,
        totalAmount,
        vat,
        totalDiscount,
        status,
        horecaStatus,
        remark,
        orderDtls,
        orderDiscountResults,
        orderPromotionResults,
        grandTotalAmount,
        tabletOrderId,
        poNo,
        expectDeliveryDate,
      ];
}

@JsonSerializable()
class OrderDtl extends Equatable {
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

  const OrderDtl(
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

  factory OrderDtl.fromJson(Map<String, dynamic> json) =>
      _$OrderDtlFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtlToJson(this);

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
class OrderPromotionResultRequest extends Equatable {
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

  const OrderPromotionResultRequest(
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

  factory OrderPromotionResultRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderPromotionResultRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPromotionResultRequestToJson(this);

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
class OrderDiscountResultRequest extends Equatable {
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

  const OrderDiscountResultRequest(
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

  factory OrderDiscountResultRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderDiscountResultRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDiscountResultRequestToJson(this);

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
