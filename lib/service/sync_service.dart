import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/request/create_order_request.dart';
import 'package:horeca_service/model/request/customer_stock_checkstock.dart';
import 'package:horeca_service/model/response/create_order_response.dart';
import 'package:horeca_service/model/response/customer_check_stock_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SyncService {
  final SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  final CustomerPriceProvider customerPriceProvider = CustomerPriceProvider();
  final CustomerStockProvider customerStockProvider = CustomerStockProvider();
  final OrderProvider orderProvider = OrderProvider();
  final OrderDetailProvider orderDetailProvider = OrderDetailProvider();
  final OrderPromotionResultProvider orderPromotionResultProvider =
      OrderPromotionResultProvider();
  final OrderDiscountResultProvider orderDiscountResultProvider =
      OrderDiscountResultProvider();
  // Future<bool> checkSync(int positionId, Transaction? txn) async {
  //   var connect = await Connectivity().checkConnectivity();
  //   // if (connect == ConnectivityResult.wifi ||
  //   //     connect == ConnectivityResult.mobile) {
  //   //   List<SyncOffline> lstSyncOffline =
  //   //       await syncOfflineProvider.selectByBaPosition(positionId, txn);
  //   //   if (lstSyncOffline.isNotEmpty) {
  //   //     return true;
  //   //   }
  //   // }

  //   return false;
  // }

  Future<bool> checkSyncCurrent(int positionId, SyncType typeData,
      int? relatedId, Transaction? txn) async {
    var connect = await Connectivity().checkConnectivity();
    bool result = false;
    if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      List<SyncOffline> lstSyncOffline =
          await syncOfflineProvider.selectByBaPosition(positionId, txn);
      if (lstSyncOffline.isEmpty) {
        return false;
      } else {
        switch (typeData) {
          case SyncType.startShift:
            result = isSyncShift(lstSyncOffline);
            break;
          case SyncType.endShift:
            result = isSyncShift(lstSyncOffline);
            break;
          case SyncType.checkinVisit:
            result = isSyncShift(lstSyncOffline);
            break;
          case SyncType.checkoutVisit:
            result = await isSyncCheckoutVisit(lstSyncOffline, relatedId, txn);
            break;
          case SyncType.cancelVisit:
            result = isSyncShift(lstSyncOffline);
            break;
          case SyncType.revisit:
            result = await isSyncCheckoutVisit(lstSyncOffline, relatedId, txn);
            break;
          case SyncType.order:
            result = await isSyncCheckoutVisit(lstSyncOffline, relatedId, txn);
            break;
          case SyncType.customerPrice:
            break;
          case SyncType.customerStock:
            result = await isSyncCheckoutVisit(lstSyncOffline, relatedId, txn);
            break;
          case SyncType.survey:
            result = await isSyncCheckoutVisit(lstSyncOffline, relatedId, txn);
            break;
        }
      }
    }

    return result;
  }

  bool isSyncShift(List<SyncOffline> lstSyncOffline) {
    List<SyncOffline> lstRecord = lstSyncOffline
        .where((record) =>
            record.type == SyncType.startShift.toString() ||
            record.type == SyncType.endShift.toString())
        .toList();

    if (lstRecord.isEmpty) {
      return false;
    }

    return true;
  }

  Future<bool> isSyncCheckoutVisit(List<SyncOffline> lstSyncOffline,
      int? customerVisitId, Transaction? txn) async {
    bool result = isSyncShift(lstSyncOffline);

    if (result) return true;

    int? countSyncVisit =
        await syncOfflineProvider.countSyncVisit(customerVisitId, txn);

    if (countSyncVisit != null && countSyncVisit > 0) {
      return true;
    }

    return false;
  }

  Future<void> syncStock(
      List<CustomerPrice> lstCustomerPrice,
      List<CustomerStock> lstCustomerStock,
      int? customerVisitId,
      Transaction? txn,
      AppLocalizations multiLang) async {
    List<LstCustomerPrices> lstCustomerPrices = [];
    List<LstCustomerStocks> lstCustomerStocks = [];
    String message = "";

    for (CustomerPrice customerPrice in lstCustomerPrice) {
      LstCustomerPrices record = LstCustomerPrices(
        customerId: customerPrice.customerId,
        baPositionId: customerPrice.baPositionId,
        lastUpdate: customerPrice.lastUpdate,
        productId: customerPrice.productId,
        customerVisitId: customerVisitId,
        price: customerPrice.price,
      );

      lstCustomerPrices.add(record);
    }

    for (CustomerStock customerStock in lstCustomerStock) {
      LstCustomerStocks record = LstCustomerStocks(
          customerId: customerStock.customerId,
          baPositionId: customerStock.baPositionId,
          lastUpdate: customerStock.lastUpdate,
          productId: customerStock.productId,
          customerVisitId: customerVisitId,
          availableStock: customerStock.availableStock);

      lstCustomerStocks.add(record);
    }

    CustomerStockCheckStockRequest request = CustomerStockCheckStockRequest(
        customerVisitId: customerVisitId,
        lstCustomerPrices: lstCustomerPrices,
        lstCustomerStocks: lstCustomerStocks);

    CallApiUtils<CustomerCheckStockResponse> sendRequest = CallApiUtils();
    String requestBodyJson = jsonEncode(request);

    APIResponseEntity<CustomerCheckStockResponse> response =
        await sendRequest.callApiPostMethod(APIs.checkStock, requestBodyJson,
            CustomerCheckStockResponse.fromJson);

    for (var item in response.data!.lstCustomerPrices!) {
      CustomerPrice priceItem = lstCustomerPrice.firstWhere(
          (element) =>
              customerVisitId == item.customerVisitId &&
              element.customerId == item.customerId &&
              element.baPositionId == item.baPositionId &&
              element.productId == item.productId, orElse: () {
        message = multiLang.cannotSynchronize(multiLang.productPrice);
        throw message;
      });
      // lstCustomerPrice.remove(priceItem);
      priceItem.customerPriceIdSync = item.customerPriceId;
      await customerPriceProvider.update(priceItem, txn);
    }
    for (var item in response.data!.lstCustomerStocks!) {
      CustomerStock? stockItem = lstCustomerStock.firstWhere(
          (element) =>
              customerVisitId == item.customerVisitId &&
              element.customerId == item.customerId &&
              element.baPositionId == item.baPositionId &&
              element.productId == item.productId, orElse: () {
        message = multiLang.cannotSynchronize(multiLang.salesInventory);
        throw message;
      });
      // lstCustomerStock.remove(stockItem);
      stockItem.customerStockIdSync = item.customerStockId;
      await customerStockProvider.update(stockItem, txn);
    }
  }

  Future<void> syncCreateOrder(
      List<OrderDetail> lstOrderDtl,
      List<OrderPromotionResult> lstPromotionResult,
      List<OrderDiscountResult> lstDiscountResult,
      Order orderResult,
      int customerVisitIdSync,
      int baPositionId,
      Transaction? txn,
      AppLocalizations multiLang) async {
    List<OrderDtl> lstOrderDtlRequest = [];
    List<OrderDiscountResultRequest> lstOrderDiscountResultRequest = [];
    List<OrderPromotionResultRequest> lstOrderPromotionResultRequest = [];
    String message = '';
    for (var orderDtl in lstOrderDtl) {
      OrderDtl record = OrderDtl(
          createdBy: orderDtl.createdBy,
          createdDate: orderDtl.createdDate,
          updatedBy: orderDtl.updatedBy,
          updatedDate: orderDtl.updatedDate,
          orderDtlId: orderDtl.orderDetailId,
          productId: orderDtl.productId,
          stockType: orderDtl.stockType,
          qty: orderDtl.quantity,
          salesPrice: orderDtl.salesPrice,
          salesInPrice: orderDtl.salesInPrice,
          totalAmount: orderDtl.totalAmount,
          orderId: orderDtl.orderId);

      lstOrderDtlRequest.add(record);
    }

    for (var promotionResult in lstPromotionResult) {
      OrderPromotionResultRequest record = OrderPromotionResultRequest(
          promotionResultId: promotionResult.orderPromotionResultId,
          orderId: promotionResult.orderId,
          promotionId: promotionResult.promotionId,
          promotionSchemeId: promotionResult.promotionSchemeId,
          productId: promotionResult.productId,
          qty: promotionResult.qty,
          description: promotionResult.description,
          createdBy: promotionResult.createdBy,
          createdDate: promotionResult.createdDate,
          updatedBy: promotionResult.updatedBy,
          updatedDate: promotionResult.updatedDate);

      lstOrderPromotionResultRequest.add(record);
    }

    for (var discountResult in lstDiscountResult) {
      OrderDiscountResultRequest record = OrderDiscountResultRequest(
          discountResultId: discountResult.orderDiscountResultId,
          orderId: discountResult.orderId,
          discountId: discountResult.discountId,
          discountSchemeId: discountResult.discountSchemeId,
          productId: discountResult.productId,
          discountType: discountResult.discountType,
          discountValue: discountResult.discountValue,
          totalDiscount: discountResult.totalDiscount,
          description: discountResult.description,
          createdBy: discountResult.createdBy,
          createdDate: discountResult.createdDate,
          updatedBy: discountResult.updatedBy,
          updatedDate: discountResult.updatedDate);

      lstOrderDiscountResultRequest.add(record);
    }

    CreateOrderRequest request = CreateOrderRequest(
      tabletOrderId: orderResult.orderId,
      orderCd: orderResult.orderCd,
      orderType: orderResult.orderType,
      customerId: orderResult.customerId,
      customerVisitId: customerVisitIdSync,
      baPositionId: baPositionId,
      employeeId: orderResult.employeeId,
      orderDate: orderResult.orderDate,
      totalAmount: orderResult.totalAmount,
      totalDiscount: orderResult.totalDiscount,
      vat: orderResult.vat,
      status: orderResult.status,
      horecaStatus: orderResult.horecaStatus,
      remark: orderResult.remark,
      orderDtls: lstOrderDtlRequest,
      orderDiscountResults: lstOrderDiscountResultRequest,
      orderPromotionResults: lstOrderPromotionResultRequest,
      grandTotalAmount: orderResult.grandTotalAmount,
      poNo: orderResult.poNo,
      expectDeliveryDate: orderResult.expectDeliveryDate,
      createdBy: orderResult.createdBy,
      createdDate: orderResult.createdDate,
      updatedBy: orderResult.updatedBy,
      updatedDate: orderResult.updatedDate,
    );

    CallApiUtils<CreateOrderResponse> callApi = CallApiUtils();

    Map<String, dynamic> jsonMapping = request.toJson();

    String json = jsonEncode(jsonMapping);
    APIResponseEntity<CreateOrderResponse> response =
        await callApi.callApiPostMethod(
            APIs.createOrder, json, CreateOrderResponse.fromJson);
    orderResult.orderIdSync = response.data?.orderId;
    orderResult.orderCd = response.data?.orderCd;
    orderResult.supPositionId = response.data?.supPositionId;
    orderResult.cityLeaderPositionId = response.data?.cityLeaderPositionId;
    orderResult.status = response.data?.status;
    orderResult.orderType = response.data?.orderType;
    orderResult.horecaStatus = response.data?.horecaStatus;

    //update order detail
    List<OrderDtlResponse>? lstOrderDetailResponse = response.data?.orderDtls;
    List<OrderDetail> lstOrderDetailUpdate = [];
    if (lstOrderDetailResponse != null) {
      for (var item in lstOrderDetailResponse) {
        OrderDetail orderDetailUpdate = lstOrderDtl.firstWhere(
            (element) =>
                element.productId == item.productId &&
                element.orderId == orderResult.orderId &&
                orderResult.orderIdSync == item.orderId, orElse: () {
          message = multiLang.cannotSynchronize(
              multiLang.listOf([multiLang.product, multiLang.order].join(" ")));
          throw message;
        });
        orderDetailUpdate.orderDetailIdSync = item.orderDtlId;
        orderDetailUpdate.updatedBy = baPositionId;
        orderDetailUpdate.updatedDate =
            DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
        lstOrderDetailUpdate.add(orderDetailUpdate);
      }
    }

    //update promotion
    List<OrderPromotionResponse>? lstPromotionResponse =
        response.data?.orderPromotionResults;
    List<OrderPromotionResult> lstPromotionResultUpdate = [];
    if (lstPromotionResponse != null) {
      for (var item in lstPromotionResponse) {
        OrderPromotionResult orderPromotionResultUpdate = lstPromotionResult
            .firstWhere(
                (element) =>
                    element.orderId == orderResult.orderId &&
                    orderResult.orderIdSync == item.orderId &&
                    element.promotionSchemeId == item.promotionSchemeId &&
                    element.productId == item.productId, orElse: () {
          message = multiLang
              .cannotSynchronize(multiLang.listOf(multiLang.promotion));
          throw message;
        });
        orderPromotionResultUpdate.orderPromotionResultIdSync =
            item.promotionResultId;
        orderPromotionResultUpdate.updatedBy = baPositionId;
        orderPromotionResultUpdate.updatedDate =
            DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
        lstPromotionResultUpdate.add(orderPromotionResultUpdate);
      }
    }

    //update discount
    List<OrderDiscountResponse>? lstDiscountResponse =
        response.data?.orderDiscountResults;
    List<OrderDiscountResult> lstDiscountResultUpdate = [];
    if (lstDiscountResponse != null) {
      for (var item in lstDiscountResponse) {
        OrderDiscountResult orderDiscountResultUpdate = lstDiscountResult
            .firstWhere(
                (element) =>
                    element.orderId == orderResult.orderId &&
                    orderResult.orderIdSync == item.orderId &&
                    element.discountSchemeId == item.discountSchemeId,
                orElse: () {
          message =
              multiLang.cannotSynchronize(multiLang.listOf(multiLang.discount));
          throw message;
        });
        orderDiscountResultUpdate.orderDiscountResultIdSync =
            item.discountResultId;
        orderDiscountResultUpdate.updatedBy = baPositionId;
        orderDiscountResultUpdate.updatedDate =
            DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
        lstDiscountResultUpdate.add(orderDiscountResultUpdate);
      }
    }

    await orderProvider.updateOrderSync(orderResult, txn);
    for (var item in lstOrderDetailUpdate) {
      await orderDetailProvider.updateSyncId(item, txn);
    }
    for (var item in lstPromotionResultUpdate) {
      await orderPromotionResultProvider.updateSyncId(item, txn);
    }
    for (var item in lstDiscountResultUpdate) {
      await orderDiscountResultProvider.updateSyncId(item, txn);
    }
  }
}
