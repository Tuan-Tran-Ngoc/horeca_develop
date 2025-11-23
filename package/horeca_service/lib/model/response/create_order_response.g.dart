// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderResponse _$CreateOrderResponseFromJson(Map<String, dynamic> json) =>
    CreateOrderResponse(
      orderId: json['orderId'] as int?,
      orderCd: json['orderCd'] as String?,
      tabletOrderId: json['tabletOrderId'] as int?,
      supPositionId: json['supPositionId'] as int?,
      baPositionId: json['baPositionId'] as int?,
      cityLeaderPositionId: json['cityLeaderPositionId'] as int?,
      status: json['status'] as String?,
      customerId: json['customerId'] as int?,
      customerVisitId: json['customerVisitId'] as int?,
      horecaStatus: json['horecaStatus'] as String?,
      orderType: json['orderType'] as String?,
      errorFlg: json['errorFlg'],
      errorString: json['errorString'] as String?,
      poNo: json['poNo'] as String?,
      sapOrderNo: json['sapOrderNo'] as String?,
      lstDelivery: (json['lstDelivery'] as List<dynamic>?)
          ?.map((e) => SAPDelivery.fromJson(e as Map<String, dynamic>))
          .toList(),
      lstSAPDetail: (json['lstSAPDetail'] as List<dynamic>?)
          ?.map((e) => SAPDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDtls: (json['orderDtls'] as List<dynamic>?)
          ?.map((e) => OrderDtlResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDiscountResults: (json['orderDiscountResults'] as List<dynamic>?)
          ?.map(
              (e) => OrderDiscountResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderPromotionResults: (json['orderPromotionResults'] as List<dynamic>?)
          ?.map(
              (e) => OrderPromotionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateOrderResponseToJson(
        CreateOrderResponse instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderCd': instance.orderCd,
      'tabletOrderId': instance.tabletOrderId,
      'supPositionId': instance.supPositionId,
      'baPositionId': instance.baPositionId,
      'cityLeaderPositionId': instance.cityLeaderPositionId,
      'status': instance.status,
      'customerId': instance.customerId,
      'customerVisitId': instance.customerVisitId,
      'horecaStatus': instance.horecaStatus,
      'orderType': instance.orderType,
      'errorFlg': instance.errorFlg,
      'errorString': instance.errorString,
      'poNo': instance.poNo,
      'sapOrderNo': instance.sapOrderNo,
      'lstDelivery': instance.lstDelivery,
      'lstSAPDetail': instance.lstSAPDetail,
      'orderDtls': instance.orderDtls,
      'orderDiscountResults': instance.orderDiscountResults,
      'orderPromotionResults': instance.orderPromotionResults,
    };

OrderDtlResponse _$OrderDtlResponseFromJson(Map<String, dynamic> json) =>
    OrderDtlResponse(
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

Map<String, dynamic> _$OrderDtlResponseToJson(OrderDtlResponse instance) =>
    <String, dynamic>{
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

OrderPromotionResponse _$OrderPromotionResponseFromJson(
        Map<String, dynamic> json) =>
    OrderPromotionResponse(
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

Map<String, dynamic> _$OrderPromotionResponseToJson(
        OrderPromotionResponse instance) =>
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

OrderDiscountResponse _$OrderDiscountResponseFromJson(
        Map<String, dynamic> json) =>
    OrderDiscountResponse(
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

Map<String, dynamic> _$OrderDiscountResponseToJson(
        OrderDiscountResponse instance) =>
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

SAPDelivery _$SAPDeliveryFromJson(Map<String, dynamic> json) => SAPDelivery(
      deliveryNo: json['deliveryNo'] as String?,
      deliveryStatus: json['deliveryStatus'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      truckId: json['truckId'] as int?,
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$SAPDeliveryToJson(SAPDelivery instance) =>
    <String, dynamic>{
      'deliveryNo': instance.deliveryNo,
      'deliveryStatus': instance.deliveryStatus,
      'deliveryDate': instance.deliveryDate,
      'truckId': instance.truckId,
      'remark': instance.remark,
    };

SAPDetail _$SAPDetailFromJson(Map<String, dynamic> json) => SAPDetail(
      productCd: json['productCd'] as String?,
      productName: json['productName'] as String?,
      itemCategory: json['itemCategory'] as String?,
      unit: json['unit'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      shippedQty: (json['shippedQty'] as num?)?.toDouble(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      unitDiscount: (json['unitDiscount'] as num?)?.toDouble(),
      productValue: (json['productValue'] as num?)?.toDouble(),
      productDiscount: (json['productDiscount'] as num?)?.toDouble(),
      vat: (json['vat'] as num?)?.toDouble(),
      taxAmount: (json['taxAmount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SAPDetailToJson(SAPDetail instance) => <String, dynamic>{
      'productCd': instance.productCd,
      'productName': instance.productName,
      'itemCategory': instance.itemCategory,
      'unit': instance.unit,
      'qty': instance.qty,
      'shippedQty': instance.shippedQty,
      'unitPrice': instance.unitPrice,
      'discount': instance.discount,
      'unitDiscount': instance.unitDiscount,
      'productValue': instance.productValue,
      'productDiscount': instance.productDiscount,
      'vat': instance.vat,
      'taxAmount': instance.taxAmount,
      'totalAmount': instance.totalAmount,
    };
