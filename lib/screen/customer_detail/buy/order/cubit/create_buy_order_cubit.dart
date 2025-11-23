import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/service/order_service.dart';
import 'package:horeca/service/promotion_service.dart';
import 'package:horeca/service/sync_service.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/product_stock.dart';
import 'package:horeca_service/sqflite_database/dto/address_visit_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/order_header_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/summary_order_dto.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'create_buy_order_state.dart';

class CreateBuyOrderCubit extends Cubit<CreateBuyOrderState> {
  final BuildContext context;

  CreateBuyOrderCubit(this.context) : super(CreateBuyOrderInitial());
  CustomerProvider customerProvider = CustomerProvider();
  CustomerAddressProvider customerAddressProvider = CustomerAddressProvider();
  ResourceProvider resourceProvider = ResourceProvider();
  CustomerLiabilitiesProvider customerLiabilitiesProvider =
      CustomerLiabilitiesProvider();
  EmployeeProvider employeeProvider = EmployeeProvider();
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  PromotionProvider promotionProvider = PromotionProvider();
  PromotionSchemeProvider promotionSchemeProvider = PromotionSchemeProvider();
  PromotionConditionProvider promotionConditionProvider =
      PromotionConditionProvider();
  PromotionResultProvider promotionResultProvider = PromotionResultProvider();
  OrderPromotionResultProvider orderPromotionResultProvider =
      OrderPromotionResultProvider();
  DiscountProvider discountProvider = DiscountProvider();
  DiscountConditionProvider discountConditionProvider =
      DiscountConditionProvider();
  DiscountResultProvider discountResultProvider = DiscountResultProvider();
  OrderService orderService = OrderService();
  OrderDiscountResultProvider orderDiscountResultProvider =
      OrderDiscountResultProvider();
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  OrderProvider orderProvider = OrderProvider();
  ProductBranchMappingProvider productBranchMappingProvider =
      ProductBranchMappingProvider();
  SyncService syncService = SyncService();
  ProductProvider productProvider = ProductProvider();
  StockBalanceProvider stockBalanceProvider = StockBalanceProvider();
  OrderDetailProvider orderDetailProvider = OrderDetailProvider();
  PromotionService promotionService = PromotionService();
  DatabaseProvider db = DatabaseProvider();
  late Database database;
  String message = "";
  String moduleName = 'CREATE_BUY_ORDER';

  late SharedPreferences prefs;

  Future<void> init(
      int customerId, int customerVisitId, int orderIdCopy) async {
    //log init
    FlutterLogs.logThis(
      tag: 'CREATE_BUY_ORDER',
      subTag: 'build',
      logMessage: 'Start init create buy order screen',
      level: LogLevel.INFO,
    );

    DateTime now = DateTime.now();
    String dateTimeStr = DateFormat(Constant.dateTimeStr).format(now);
    String dateStr = DateFormat(Constant.dateFormatterYYYYMMDD).format(now);
    List<ProductDto> lstProduct = [];
    OrderHeaderDto orderHeader = OrderHeaderDto();
    Customer customer = Customer();
    AddressVisitDto customerAddress = AddressVisitDto();
    // create order_no
    String orderCd = Constant.ORDER_CD_HEADER.replaceAll('?', dateTimeStr);
    orderHeader.orderCd = orderCd;

    // get Customer information
    List<Customer> lstCustomer =
        await customerProvider.select(customerId, null);
    //List<Customer> lstCustomer = [];

    if (lstCustomer.isNotEmpty) {
      customer = lstCustomer[0];
      orderHeader.customerCode = customer.customerCode;
      orderHeader.customerName = customer.customerName;
      orderHeader.isTax = customer.isTax;
      if (customer.isTax == 1) {
        List<Resource> lstVatValue =
            await resourceProvider.getResourceByCategoryCd(Constant.clVatValue);

        if (lstVatValue.isNotEmpty) {
          orderHeader.vatValue =
              (double.tryParse(lstVatValue[0].value1 ?? '0') ?? 0) / 100;
        }
      }
    }

    //setting order date
    orderHeader.orderDate = dateStr;

    //setting address
    List<AddressVisitDto> lstCustomerAddress = await customerAddressProvider
        .getAddressCustomerVistting(customerVisitId);

    //setting order type
    List<Resource> lstTypeOrder =
        await resourceProvider.getResourceByCategoryCd(Constant.clTypeOrder);
    orderHeader.lstTypeOrder = lstTypeOrder;
    orderHeader.selectedTypeOrder = lstTypeOrder[0].resourceCd;

    if (lstCustomerAddress.isNotEmpty) {
      customerAddress = lstCustomerAddress[0];
      orderHeader.address = customerAddress.address;
    }

    //setting liabilities
    List<CustomerLiabilities> lstCustomerLiabilities =
        await customerLiabilitiesProvider.select(customer.customerCode!, null);

    //default value
    orderHeader.planShippingDate = null;
    orderHeader.pOnumber = null;
    orderHeader.remark = null;
    orderHeader.orderStatus = false;

    if (lstCustomerLiabilities.isNotEmpty) {
      double sumGrandOrder =
          await orderProvider.sumGrandOrder(customerId, null);
      CustomerLiabilities customerLiabilities = lstCustomerLiabilities[0];
      orderHeader.orderDebtLimit = customerLiabilities.orderDebtLimit;
      orderHeader.remainDebtLimit =
          (customerLiabilities.remainDebtLimit ?? 0) + sumGrandOrder.toInt();
    }

    //log init
    FlutterLogs.logThis(
      tag: 'CREATE_BUY_ORDER',
      subTag: 'build',
      logMessage: 'End init create buy order screen',
      level: LogLevel.INFO,
    );

    final directory = await getApplicationDocumentsDirectory();
    print('Creating log directory: $directory');
    // exportFileLogs();

    // copy order
    if (orderIdCopy != 0) {
      List<ProductDto> lstProductDto =
          await productProvider.getAllInfoProduct(customerId);

      List<OrderDetail> lstProductOrderDtl =
          await orderDetailProvider.selectByOrderId(orderIdCopy);

      lstProduct = lstProductOrderDtl
          .map((e) => ProductDto(productId: e.productId, quantity: e.quantity))
          .toList();

      lstProduct = orderService.replaceElements(lstProductDto, lstProduct);
    }

    emit(LoadingInit(orderHeader, lstProduct));
  }

  void exportFileLogs() {
    var _myLogFileName = "MyLogFile";
    FlutterLogs.exportFileLogForName(
        logFileName: _myLogFileName, decryptBeforeExporting: true);
  }

  Future<void> createOrder(
      int customerId,
      int customerVisitId,
      OrderHeaderDto orderHeader,
      SummaryOrderDto summaryOrder,
      List<ProductDto> lstProduct,
      List<SchemePromotionDto> lstPromotion,
      List<DiscountResultOrderDto> lstDiscount,
      bool isCheckLiabilities) async {
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    try {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      await database.transaction((txn) async {
        emit(ClickButtonSave());
        OrderProvider orderProvider = OrderProvider();
        OrderDetailProvider orderDetailProvider = OrderDetailProvider();
        StockBalanceProvider stockBalanceProvider = StockBalanceProvider();

        DateTime now = DateTime.now();
        String dateTimeStr = DateFormat(Constant.dateTimeFormatter).format(now);
        String orderDateStr = DateFormat(Constant.dateTimeFormatter)
            .format(DateTime.parse(orderHeader.orderDate!));
        String? expectDeliveryDateStr;
        if (orderHeader.planShippingDate != null) {
          expectDeliveryDateStr = DateFormat(Constant.dateTimeFormatter)
              .format(DateTime.parse(orderHeader.planShippingDate!));
        }
        prefs = await SharedPreferences.getInstance();

        var shiftReportId = prefs.getInt('shiftReportId');
        var baPositionId = prefs.getInt('baPositionId');

        // check sync data
        if (await syncService.checkSyncCurrent(
            baPositionId ?? 0, SyncType.order, customerVisitId, txn)) {
          throw multiLang.msgCheckSync;
        }

        CustomerVisit? customerVisit =
            await customerVisitProvider.select(customerVisitId, txn);

        if (customerVisit == null) {
          // throw Exception('Thông tin viếng thăm không tìm thấy');

          message = multiLang
              .notFound([multiLang.information, multiLang.visit].join(" "));
          throw message;
        }

        // set init summary
        double totalAmount = summaryOrder.totalAmount ?? 0;
        double discountAmount = summaryOrder.discountAmount ?? 0;
        double promotionAmount = summaryOrder.promotionAmount ?? 0;
        double vatAmount = summaryOrder.vatAmount ?? 0;
        double grandTotalAmount = summaryOrder.grandTotalAmount ?? 0;

        // get info employee
        List<Employee> lstEmployInfo =
            await employeeProvider.getEmployByPosId(baPositionId!, txn);

        Employee employInfo;

        if (lstEmployInfo.isEmpty) {
          // throw Exception(
          //     'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại');
          // message =
          // '${multiLang.notFound('${multiLang.information} ${multiLang.employee}')}.\n${multiLang.loginAgain}';
          message = [
            multiLang.notFound(
                [multiLang.information, multiLang.employee].join(" ")),
            multiLang.loginAgain
          ].join(".\n");
          throw message;
        }

        // check draft order
        if (orderHeader.orderStatus! && orderHeader.planShippingDate == null) {
          // throw Exception(
          //     'Tạo đơn hàng không thành công. Nhập ngày dự kiến giao hàng cho đơn Nháp.');
          // message =
          // '${multiLang.createOrder} ${multiLang.unsucess}.\n${multiLang.enter(multiLang.planDeliveryDate)}';
          message = [
            [multiLang.createOrder, multiLang.unsucess].join(" "),
            multiLang.enter(multiLang.planDeliveryDate)
          ].join(".\n");
          throw message;
        } else if (orderHeader.planShippingDate != null &&
            !DateTime.parse(orderHeader.planShippingDate ?? '').isAfter(now)) {
          // throw Exception('Ngày dự kiến giao hàng phải là tương lai');
          message = multiLang.planDeliveryDateMustBeFuture;
          throw message;
        }

        employInfo = lstEmployInfo[0];

        if (lstProduct.isEmpty) {
          // throw Exception('Không có sản phẩm được mua');
          message = multiLang.noProductsPurchased;
          throw message;
        }
        //check sales price is null
        if (lstProduct.any((product) => product.salesPrice == null)) {
          message = multiLang.errMsgNotPriceProduct;
          throw message;
        }

        //get promotion current applied for this customer
        bool isCheckPromotion = await checkPromotionValid(
            customerId, lstPromotion, lstProduct, txn);
        if (!isCheckPromotion) {
          // throw Exception('Sản phẩm chưa đủ điều kiện để sử dụng khuyến mãi');
          message = multiLang.productPromotionCriteria;
          throw message;
        }

        if (!(orderHeader.orderStatus ?? true)) {
          // warning liabilities
          if (isCheckLiabilities) {
            List<String> warningMessages = [];

            List<Customer> lstCustomer =
                await customerProvider.select(customerId, txn);

            if (lstCustomer.isNotEmpty) {
              List<CustomerLiabilities> lstCustomerLiabilities =
                  await customerLiabilitiesProvider.select(
                      lstCustomer[0].customerCode!, txn);
              if (lstCustomerLiabilities.isNotEmpty) {
                double sumGrandOrder =
                    await orderProvider.sumGrandOrder(customerId, txn);
                CustomerLiabilities customerLiabilities =
                    lstCustomerLiabilities[0];

                customerLiabilities.remainDebtLimit =
                    ((customerLiabilities.remainDebtLimit ?? 0) * -1) -
                        sumGrandOrder.toInt();

                if ((customerLiabilities.remainDebtLimit ?? 0) <
                    grandTotalAmount) {
                  // emit(ValidateFailShowPopup(
                  //     'Số dư nợ tín dụng đã vượt quá.\nBạn có muốn tiếp tục lưu đơn hàng không?'));
                  // message = [
                  //   multiLang.creditBalanceExceeded,
                  //   multiLang.doYouWant(multiLang.createOrder)
                  // ].join(".");
                  // emit(ValidateFailShowPopup(message));
                  // return;
                  warningMessages.add(multiLang.creditBalanceExceeded);
                }
              } else {
                if (grandTotalAmount > 0) {
                  // emit(ValidateFailShowPopup(
                  //     'Số dư nợ tín dụng đã vượt quá.\nBạn có muốn tiếp tục lưu đơn hàng không?'));
                  // message = [
                  //   multiLang.creditBalanceExceeded,
                  //   multiLang.doYouWant(multiLang.createOrder)
                  // ].join(".");
                  // emit(ValidateFailShowPopup(message));
                  // return;
                  warningMessages.add(multiLang.creditBalanceExceeded);
                }
              }

              if (warningMessages.isNotEmpty) {
                warningMessages.add(multiLang.doYouWant(multiLang.createOrder));
                emit(ValidateFailShowPopup(warningMessages.join('\n')));
                return;
              }
            } else {
              // throw Exception(
              //     'Tạo đơn hàng không thành công. Thông tin khách hàng không tìm thấy.');
              message = [
                [multiLang.createOrder, multiLang.unsucess].join(" "),
                multiLang.notFound(
                    [multiLang.information, multiLang.customer].join(" "))
              ].join(".");
              // throw CommonUtils.firstLetterUpperCase(
              //     '${multiLang.createOrder} ${multiLang.unsucess}. ${multiLang.notFound("${multiLang.information} ${multiLang.customer}")}');
              throw message;
            }
          }

          // check stock balance
          List<ProductStock> lstProductStock =
              await stockBalanceProvider.getListStockBalance(baPositionId,
                  DateFormat(Constant.dateFormatterYYYYMMDD).format(now), txn);

          List<int> lstProductMapping = await productBranchMappingProvider
              .getProductMapping(customerId, txn);

          ProductDto? productFail = checkProductStock(
              lstProduct, lstPromotion, lstProductStock, lstProductMapping);

          if (productFail != null) {
            throw multiLang.inventoryIsNotEnough(productFail.productName ?? '');
          }
        }

        // insert order header
        Order orderDto = Order(
            orderCd: orderHeader.orderCd,
            customerId: customerId,
            shiftReportId: shiftReportId,
            customerVisitId: customerVisitId,
            baPositionId: baPositionId,
            employeeId: employInfo.employeeId,
            employeeName: employInfo.employeeName,
            orderDate: orderDateStr,
            expectDeliveryDate: expectDeliveryDateStr,
            poNo: orderHeader.pOnumber,
            totalAmount: totalAmount,
            vat: vatAmount,
            totalDiscount: discountAmount,
            collection: 0,
            remark: orderHeader.remark,
            grandTotalAmount: grandTotalAmount,
            orderType: orderHeader.selectedTypeOrder,
            visitTimes: 1,
            status: Constant.orderStatusInComplete,
            horecaStatus: (orderHeader.planShippingDate == null ||
                    orderHeader.planShippingDate == '')
                ? Constant.horecaStsReceived
                : Constant.horecaStsDraft,
            createdBy: baPositionId,
            createdDate: dateTimeStr,
            updatedBy: baPositionId,
            updatedDate: dateTimeStr,
            version: 1);

        Order orderResult = await orderProvider.insert(orderDto, txn);

        // insert order detail
        List<OrderDetail> lstOrderDtl = [];
        if (orderResult.orderId != null) {
          for (var product in lstProduct) {
            OrderDetail orderDetailDto = OrderDetail(
                orderId: orderResult.orderId,
                productId: product.productId,
                stockType: Constant.stockTypeDTC,
                quantity: product.quantity,
                salesPrice: product.salesPrice,
                salesInPrice: product.priceCostDiscount,
                totalAmount:
                    product.quantity! * (product.priceCostDiscount ?? 0),
                createdBy: baPositionId,
                createdDate: dateTimeStr,
                updatedBy: baPositionId,
                updatedDate: dateTimeStr,
                version: 1);

            OrderDetail orderDetailResult =
                await orderDetailProvider.insert(orderDetailDto, txn);
            lstOrderDtl.add(orderDetailResult);
          }
        }

        // insert order promotion result
        List<OrderPromotionResult> lstPromotionResult = [];
        if (orderResult.orderId != null) {
          for (var promotion in lstPromotion) {
            for (ProductPromotionDto productResult
                in (promotion.lstProductResult ?? [])) {
              OrderPromotionResult orderPromotionResult = OrderPromotionResult(
                  orderId: orderResult.orderId,
                  promotionId: promotion.programId,
                  promotionSchemeId: promotion.schemeId,
                  productId: productResult.productId,
                  qty: productResult.totalQuatity,
                  description: promotion.schemeContent,
                  createdBy: baPositionId,
                  createdDate: dateTimeStr,
                  updatedBy: baPositionId,
                  updatedDate: dateTimeStr,
                  version: 1);

              OrderPromotionResult result = await orderPromotionResultProvider
                  .insert(orderPromotionResult, txn);

              lstPromotionResult.add(result);
            }
          }
        }

        // insert order discount ressult
        List<OrderDiscountResult> lstDiscountResult = [];
        if (orderResult.orderId != null) {
          for (var discount in lstDiscount) {
            OrderDiscountResult orderDiscountResult = OrderDiscountResult(
                orderId: orderResult.orderId,
                discountId: discount.discountId,
                discountSchemeId: discount.schemeId,
                discountType: discount.discountType,
                discountValue: discount.discountValue,
                totalDiscount: discount.totalDiscount,
                description: discount.remark,
                createdBy: baPositionId,
                createdDate: dateTimeStr,
                updatedBy: baPositionId,
                updatedDate: dateTimeStr,
                version: 1);

            OrderDiscountResult result = await orderDiscountResultProvider
                .insert(orderDiscountResult, txn);

            lstDiscountResult.add(result);
          }
        }

        // sync data
        var connect = await Connectivity().checkConnectivity();
        if (connect == ConnectivityResult.none) {
          SyncOffline syncOffline = SyncOffline(
              positionId: baPositionId,
              type: SyncType.order.toString(),
              status: Constant.STS_ACT,
              relatedId: orderResult.orderId,
              createdDate: dateTimeStr);
          await syncOfflineProvider.insert(syncOffline, txn);
        } else if (connect == ConnectivityResult.wifi ||
            connect == ConnectivityResult.mobile) {
          await syncService.syncCreateOrder(
              lstOrderDtl,
              lstPromotionResult,
              lstDiscountResult,
              orderResult,
              customerVisit.customerVisitIdSync ?? 0,
              baPositionId,
              txn,
              multiLang);
        }
        message = [multiLang.createOrder, multiLang.success].join(" ");
        emit(CreateOrderSuccess(true, message));
      });
    } catch (error) {
      print('Tạo đơn hàng không thành công ERROR-003: $error');
      if (error.toString() ==
          MessageUtils.getMessages(code: Constant.SESSION_LOGIN_EXPIRED)) {
        await CommonUtils.logout();
        GoRouter.of(context).go('/');
      }
      // emit(CreateOrderFail('$error'));
      emit(CreateOrderFail(error.toString()));
    }
  }

  Future<bool> checkPromotionValid(
      int customerId,
      List<SchemePromotionDto> lstPromotion,
      List<ProductDto> lstProduct,
      Transaction txn) async {
    // List<PromotionResultOrderDto> lstPromotionCanApply =
    //     await orderService.applyPromotionOrder(customerId, lstProduct, txn);
    bool isPromotionApply = true;
    //get product Apply
    List<ProductPromotionDto> lstProductApply = [];
    for (SchemePromotionDto promotion in lstPromotion) {
      for (ProductPromotionDto productApply
          in (promotion.lstProductApply ?? [])) {
        ProductPromotionDto copiedProductApply = ProductPromotionDto(
            productId: productApply.productId,
            productName: productApply.productName,
            totalQuatity: productApply.totalQuatity,
            totalAmount: productApply.totalAmount);
        if (!lstProductApply.any(
            (element) => element.productId == copiedProductApply.productId)) {
          lstProductApply.add(copiedProductApply);
        } else {
          int index = lstProductApply.indexWhere(
              (element) => element.productId == copiedProductApply.productId);

          lstProductApply[index].totalQuatity =
              (lstProductApply[index].totalQuatity ?? 0) +
                  (copiedProductApply.totalQuatity ?? 0);
        }
      }
    }

    for (ProductPromotionDto productApply in lstProductApply) {
      if (lstProduct
          .any((element) => element.productId == productApply.productId)) {
        int index = lstProduct.indexWhere(
            (element) => element.productId == productApply.productId);
        if ((lstProduct[index].quantity ?? 0) <
            (productApply.totalQuatity ?? 0)) {
          isPromotionApply = false;
          break;
        }
      } else {
        isPromotionApply = false;
        break;
      }
    }

    return isPromotionApply;
  }

  Future<void> applyDiscountAndPromotion(
      int customerId, List<ProductDto> lstProduct) async {
    // get promotion current applied for this customer
    emit(StartApplyDiscounPromotion());
    lstProduct =
        await orderService.applyDiscountSKU(customerId, lstProduct, null);
    List<DiscountResultOrderDto> lstDiscountOrder =
        await orderService.applyDiscountOrder(customerId, lstProduct, null);
    List<PromotionResultOrderDto> lstPromotion =
        await orderService.applyPromotionOrder(customerId, lstProduct, null);
    // List<DiscountResultOrderDto> lstDiscountOrder = [];
    // List<PromotionResultOrderDto> lstPromotion = [];

    emit(ApplyDiscountAndPromotionSuccess(
        lstProduct, lstDiscountOrder, lstPromotion));
  }

  ProductDto? checkProductStock(
      List<ProductDto> lstProduct,
      List<SchemePromotionDto> lstPromotion,
      List<ProductStock> lstProductStock,
      List<int> lstProductMapping) {
    ProductDto? result;

    List<ProductDto> lstProductTarget =
        lstProduct.map((product) => ProductDto.copyWith(product)).toList();

    //get product result
    List<ProductPromotionDto> lstProductResult = [];
    for (SchemePromotionDto promotion in lstPromotion) {
      for (ProductPromotionDto productResult
          in (promotion.lstProductResult ?? [])) {
        ProductPromotionDto copiedProductResult = ProductPromotionDto(
            productId: productResult.productId,
            productName: productResult.productName,
            totalQuatity: productResult.totalQuatity,
            totalAmount: productResult.totalAmount);
        if (!lstProductResult.any(
            (element) => element.productId == copiedProductResult.productId)) {
          lstProductResult.add(copiedProductResult);
        } else {
          int index = lstProductResult.indexWhere(
              (element) => element.productId == copiedProductResult.productId);

          lstProductResult[index].totalQuatity =
              (lstProductResult[index].totalQuatity ?? 0) +
                  (copiedProductResult.totalQuatity ?? 0);
        }
      }
    }
    // for (ProductDto product in lstProductTarget) {
    //   int index = lstProductResult
    //       .indexWhere((element) => element.productId == product.productId);
    //   if (index >= 0) {
    //     product.quantity = (product.quantity ?? 0) +
    //         (lstProductResult[index].totalQuatity ?? 0);
    //   } else {
    //     ProductDto newProduct = ProductDto(
    //       productId:
    //     )
    //   }
    // }

    // merge product order anf product promotion
    for (ProductPromotionDto promotion in lstProductResult) {
      int index = lstProductTarget
          .indexWhere((element) => element.productId == promotion.productId);
      if (index >= 0) {
        lstProductTarget[index].quantity =
            (lstProductTarget[index].quantity ?? 0) +
                (promotion.totalQuatity ?? 0);
      } else {
        ProductDto newProduct = ProductDto(
            productId: promotion.productId,
            productName: promotion.productName,
            quantity: promotion.totalQuatity);
        lstProductTarget.add(newProduct);
      }
    }

    for (var product in lstProductTarget) {
      if (lstProductMapping.any((element) => element == product.productId) &&
          !lstProductStock.any((element) =>
              (element.productId == product.productId) &&
              ((product.quantity ?? 0) <=
                  (element.availableStock ?? 0) -
                      ((element.orderUsedStock ?? 0) +
                          (element.promotionUsedStock ?? 0))))) {
        result = product;
        break;
      }
    }

    return result;
  }

  void openPromotionPopup() {
    emit(OpenPromotionPopup());
  }

  Future<void> calculatePromotion(
      int customerId, List<ProductDto> lstProduct) async {
    emit(EventCalculatePromotion());
    // List<PromotionDto> lstPromotion =
    //     await promotionService.getSchemeContentPromotion(customerId);
    // object target
    List<PromotionDto> lstPromotion = [];

    // when no element product then show all promotion
    bool isShowAllPromotion = false;

    List<PromotionResultOrderDto> lstPromotionCanApply = [];
    if (lstProduct.isNotEmpty) {
      lstPromotionCanApply =
          await orderService.applyPromotionOrder(customerId, lstProduct, null);
    } else {
      isShowAllPromotion = true;
    }

    if (lstPromotionCanApply.isNotEmpty) {
      List<PromotionDto> lstPromotionAll =
          await promotionService.getSchemeContentPromotion(customerId);

      for (var promotion in lstPromotionAll) {
        List<SchemePromotionDto> lstShemeResult = [];
        for (SchemePromotionDto scheme in promotion.lstSchemeOrder ?? []) {
          if (isShowAllPromotion ||
              (lstPromotionCanApply.any((element) =>
                  element.promotionId == promotion.promotionId &&
                  element.schemeId == scheme.schemeId))) {
            PromotionResultOrderDto promotionCanApply = lstPromotionCanApply
                .firstWhere((element) => element.schemeId == scheme.schemeId,
                    orElse: () => PromotionResultOrderDto());

            scheme.lstProductApply = promotionCanApply.lstProductApply;
            scheme.lstProductResult = promotionCanApply.lstProductResult;
            lstShemeResult.add(scheme);
          }
        }

        if (lstShemeResult.isNotEmpty) {
          promotion.lstSchemeOrder = lstShemeResult;
          PromotionDto result = promotion;

          lstPromotion.add(result);
        }
      }
      lstPromotion = await promotionService.checkPromotionSchemeAlow(
          customerId, lstPromotion, lstProduct);
    }

    lstPromotion = await promotionService.applyAllPromotion(
        customerId, lstPromotion, lstProduct);
    emit(EventCalculatePromotionSuccess(lstPromotion));
  }
}
