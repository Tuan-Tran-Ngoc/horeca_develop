// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      tabletOrderId: json['tabletOrderId'] as int?,
      poNo: json['poNo'] as String?,
      expectDeliveryDate: json['expectDeliveryDate'] as String?,
      createdBy: json['createdBy'] as int?,
      orderType: json['orderType'] as String?,
      createdDate: json['createdDate'] as String?,
      updatedBy: json['updatedBy'] as int?,
      updatedDate: json['updatedDate'] as String?,
      orderId: json['orderId'] as int?,
      orderCd: json['orderCd'] as String?,
      customerId: json['customerId'] as int?,
      customerVisitId: json['customerVisitId'] as int?,
      baPositionId: json['baPositionId'] as int?,
      employeeId: json['employeeId'] as int?,
      orderDate: json['orderDate'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      vat: (json['vat'] as num?)?.toDouble(),
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      horecaStatus: json['horecaStatus'] as String?,
      remark: json['remark'] as String?,
      orderDtls: (json['orderDtls'] as List<dynamic>?)
          ?.map((e) => OrderDtl.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDiscountResults: (json['orderDiscountResults'] as List<dynamic>?)
          ?.map((e) =>
              OrderDiscountResultRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderPromotionResults: (json['orderPromotionResults'] as List<dynamic>?)
          ?.map((e) =>
              OrderPromotionResultRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      grandTotalAmount: (json['grandTotalAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderCd': instance.orderCd,
      'customerId': instance.customerId,
      'customerVisitId': instance.customerVisitId,
      'baPositionId': instance.baPositionId,
      'employeeId': instance.employeeId,
      'orderDate': instance.orderDate,
      'totalAmount': instance.totalAmount,
      'vat': instance.vat,
      'orderType': instance.orderType,
      'totalDiscount': instance.totalDiscount,
      'remark': instance.remark,
      'orderDtls': instance.orderDtls,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate,
      'status': instance.status,
      'horecaStatus': instance.horecaStatus,
      'orderDiscountResults': instance.orderDiscountResults,
      'orderPromotionResults': instance.orderPromotionResults,
      'grandTotalAmount': instance.grandTotalAmount,
      'tabletOrderId': instance.tabletOrderId,
      'poNo': instance.poNo,
      'expectDeliveryDate': instance.expectDeliveryDate,
    };

OrderDtl _$OrderDtlFromJson(Map<String, dynamic> json) => OrderDtl(
      orderDtlId: json['orderDtlId'] as int?,
      stockType: json['stockType'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      salesPrice: (json['salesPrice'] as num?)?.toDouble(),
      salesInPrice: (json['salesInPrice'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      orderId: json['orderId'] as int?,
      createdBy: json['createdBy'] as int?,
      createdDate: json['createdDate'] as String?,
      updatedBy: json['updatedBy'] as int?,
      updatedDate: json['updatedDate'] as String?,
      productId: json['productId'] as int?,
    );

Map<String, dynamic> _$OrderDtlToJson(OrderDtl instance) => <String, dynamic>{
      'orderDtlId': instance.orderDtlId,
      'productId': instance.productId,
      'stockType': instance.stockType,
      'qty': instance.qty,
      'salesPrice': instance.salesPrice,
      'salesInPrice': instance.salesInPrice,
      'totalAmount': instance.totalAmount,
      'orderId': instance.orderId,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate,
    };

OrderPromotionResultRequest _$OrderPromotionResultRequestFromJson(
        Map<String, dynamic> json) =>
    OrderPromotionResultRequest(
      promotionResultId: json['promotionResultId'] as int?,
      orderId: json['orderId'] as int?,
      promotionId: json['promotionId'] as int?,
      promotionSchemeId: json['promotionSchemeId'] as int?,
      qty: (json['qty'] as num?)?.toDouble(),
      description: json['description'] as String?,
      createdBy: json['createdBy'] as int?,
      createdDate: json['createdDate'] as String?,
      updatedBy: json['updatedBy'] as int?,
      updatedDate: json['updatedDate'] as String?,
      productId: json['productId'] as int?,
    );

Map<String, dynamic> _$OrderPromotionResultRequestToJson(
        OrderPromotionResultRequest instance) =>
    <String, dynamic>{
      'promotionResultId': instance.promotionResultId,
      'orderId': instance.orderId,
      'promotionId': instance.promotionId,
      'promotionSchemeId': instance.promotionSchemeId,
      'productId': instance.productId,
      'qty': instance.qty,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate,
    };

OrderDiscountResultRequest _$OrderDiscountResultRequestFromJson(
        Map<String, dynamic> json) =>
    OrderDiscountResultRequest(
      discountResultId: json['discountResultId'] as int?,
      orderId: json['orderId'] as int?,
      discountId: json['discountId'] as int?,
      discountSchemeId: json['discountSchemeId'] as int?,
      discountType: json['discountType'] as String?,
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      createdBy: json['createdBy'] as int?,
      createdDate: json['createdDate'] as String?,
      updatedBy: json['updatedBy'] as int?,
      updatedDate: json['updatedDate'] as String?,
      productId: json['productId'] as int?,
    );

Map<String, dynamic> _$OrderDiscountResultRequestToJson(
        OrderDiscountResultRequest instance) =>
    <String, dynamic>{
      'discountResultId': instance.discountResultId,
      'orderId': instance.orderId,
      'discountId': instance.discountId,
      'discountSchemeId': instance.discountSchemeId,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'totalDiscount': instance.totalDiscount,
      'description': instance.description,
      'productId': instance.productId,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate,
    };
