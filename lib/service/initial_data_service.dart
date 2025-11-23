import 'dart:convert';
import 'dart:io';

import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/def_table_constant.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/model/request/update_latest_request.dart';
import 'package:horeca_service/model/response/api_response_header.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unique_identifier/unique_identifier.dart';

class InitialDataService {
  AccountOfflineProvider accountOfflineProvider = AccountOfflineProvider();
  AccountPositionLinkProvider accountPositionLinkProvider =
      AccountPositionLinkProvider();
  AccountProvider accountProvider = AccountProvider();
  AreaLevelProvider areaLevelProvider = AreaLevelProvider();
  AreaProvider areaProvider = AreaProvider();
  BrandProvider brandProvider = BrandProvider();
  CategoryProvider categoryProvider = CategoryProvider();
  CustomerAddressProvider customerAddressProvider = CustomerAddressProvider();
  DiscountConditionProvider discountConditionProvider =
      DiscountConditionProvider();
  DiscountResultProvider discountResultProvider = DiscountResultProvider();
  DiscountSchemeProvider discountSchemeProvider = DiscountSchemeProvider();
  DiscountTargetProvider discountTargetProvider = DiscountTargetProvider();
  DiscountProvider discountProvider = DiscountProvider();
  DistrictProvider districtProvider = DistrictProvider();
  EmployeePositionLinkProvider employeePositionLinkProvider =
      EmployeePositionLinkProvider();
  EmployeeProvider employeeProvider = EmployeeProvider();
  LanguageProvider languageProvider = LanguageProvider();
  MembershipProvider membershipProvider = MembershipProvider();
  MessagesProvider messagesProvider = MessagesProvider();
  ProductTypeProvider productTypeProvider = ProductTypeProvider();
  ProductProvider productProvider = ProductProvider();
  PromotionConditionProvider promotionConditionProvider =
      PromotionConditionProvider();
  PromotionResultProvider promotionResultProvider = PromotionResultProvider();
  PromotionSchemeProvider promotionSchemeProvider = PromotionSchemeProvider();
  PromotionTargetProvider promotionTargetProvider = PromotionTargetProvider();
  PromotionProvider promotionProvider = PromotionProvider();
  ProvinceProvider provinceProvider = ProvinceProvider();
  ReasonProvider reasonProvider = ReasonProvider();
  ResourceProvider resourceProvider = ResourceProvider();
  RouteAssignmentProvider routeAssignmentProvider = RouteAssignmentProvider();
  SurveyTargetProvider surveyTargetProvider = SurveyTargetProvider();
  SurveyProvider surveyProvider = SurveyProvider();
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  UOMProvider uomProvider = UOMProvider();
  WardProvider wardProvider = WardProvider();
  CustomerPriceProvider customerPriceProvider = CustomerPriceProvider();
  CustomerStockProvider customerStockProvider = CustomerStockProvider();
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  OrderDiscountResultProvider orderDiscountResult =
      OrderDiscountResultProvider();
  OrderDetailProvider orderDetailProvider = OrderDetailProvider();
  OrderPromotionResultProvider orderPromotionResultProvider =
      OrderPromotionResultProvider();
  OrderProvider orderProvider = OrderProvider();
  ShiftReportProvider shiftReportProvider = ShiftReportProvider();
  SurveyResultProvider surveyResultProvider = SurveyResultProvider();
  SyncManageLogProvider syncManageLogProvider = SyncManageLogProvider();
  StockBalanceProvider stockBalanceProvider = StockBalanceProvider();
  TransferDtlProvider transferDtlProvider = TransferDtlProvider();
  TransferRequestProvider transferRequestProvider = TransferRequestProvider();
  CustomerProvider customerProvider = CustomerProvider();
  ShiftProvider shiftProvider = ShiftProvider();
  CustomerLiabilitiesProvider customerLiabilitiesProvider =
      CustomerLiabilitiesProvider();
  OrderDiscountResultProvider orderDiscountResultProvider =
      OrderDiscountResultProvider();
  SapOrderProvider sapOrderProvider = SapOrderProvider();
  SapOrderDtlProvider sapOrderDtlProvider = SapOrderDtlProvider();
  CustomerPropertyProvider customerPropertyProvider =
      CustomerPropertyProvider();
  CustomerPropertyMappingProvider customerPropertyMappingProvider =
      CustomerPropertyMappingProvider();
  SalesInPriceProvider salesInPriceProvider = SalesInPriceProvider();
  SalesInPriceDtlProvider salesInPriceDtlProvider = SalesInPriceDtlProvider();
  SalesInPriceTargetProvider salesInPriceTargetProvider =
      SalesInPriceTargetProvider();
  CustomersGroupProvider customersGroupProvider = CustomersGroupProvider();
  CustomersGroupDetailProvider customersGroupDetailProvider =
      CustomersGroupDetailProvider();
  SapOrderDeliveryProvider sapOrderDeliveryProvider =
      SapOrderDeliveryProvider();
  TransferUpdateLogProvider transferUpdateLogProvider =
      TransferUpdateLogProvider();
  ProductBranchMappingProvider productBranchMappingProvider =
      ProductBranchMappingProvider();

  late SharedPreferences prefs;

  Future<void> createTable() async {
    DatabaseProvider db = DatabaseProvider();
    prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    var path = await db.createDatabase(username);
    DatabaseProvider.pathDb = path;

    await surveyProvider.createTableSurvey();
    await customerVisitProvider.createTableCustomerVisit();
    await areaProvider.createTableArea();
    await customerProvider.createTableCustomer();
    await customerStockProvider.createTableCustomerStock();
    await stockBalanceProvider.createTableStockBalance();
    await productTypeProvider.createTableProductType();
    await uomProvider.createTableUOM();
    await productProvider.createTableProduct();
    await orderProvider.createTableOrder();
    await orderDetailProvider.createTableOrderDetail();
    await customerAddressProvider.createTableCustomerAddress();
    await resourceProvider.createTableResource();
    await shiftReportProvider.createTableShiftReport();
    await routeAssignmentProvider.createTableRouteAssignment();
    await brandProvider.createTableBrand();
    await wardProvider.createTableWard();
    await provinceProvider.createTableProvince();
    await districtProvider.createTableDistrict();
    await accountProvider.createTableAccount();
    await accountOfflineProvider.createTableAccountOffline();
    await accountPositionLinkProvider.createTableAccountPositionLink();
    await areaLevelProvider.createTableAreaLevelProvider();
    await discountProvider.createTableDiscount();
    await discountConditionProvider.createTableDiscountCondition();
    await discountTargetProvider.createTableDiscountTarget();
    await discountResultProvider.createTableDiscountResult();
    await discountSchemeProvider.createTableDiscountScheme();
    await employeeProvider.createTableEmployee();
    await employeePositionLinkProvider.createTableEmployeePositionLink();
    await languageProvider.createTableLanguage();
    await membershipProvider.createTableMembership();
    await promotionProvider.createTablePromotion();
    await promotionConditionProvider.createTablePromotionCondition();
    await promotionSchemeProvider.createTablePromotionScheme();
    await promotionTargetProvider.createTablePromotionTarget();
    await promotionResultProvider.createTablePromotionResult();
    await reasonProvider.createTableReason();
    await surveyTargetProvider.createTableReason();
    await syncOfflineProvider.createTableSyncOffline();
    await customerPriceProvider.createTableCustomerPrice();
    await orderDiscountResult.createTableOrderDiscountResult();
    await surveyResultProvider.createTableSurveyResult();
    await orderPromotionResultProvider.createTableOrderPromotionResult();
    await syncManageLogProvider.createTableSyncManageLog();
    await transferRequestProvider.createTableTransferRequest();
    await transferDtlProvider.createTableTransferDtl();
    await categoryProvider.createTableCategory();
    await messagesProvider.createTableMessages();
    await shiftProvider.createTableShift();
    await customerLiabilitiesProvider.createTableCustomerLiabilities();
    await sapOrderProvider.createTableSapOrder();
    await sapOrderDtlProvider.createTableSapOrderDtl();
    await customerPropertyProvider.createTableCustomerProperty();
    await customerPropertyMappingProvider.createTableCustomerPropertyMapping();
    await salesInPriceProvider.createTableSalesInPrice();
    await salesInPriceDtlProvider.createTableSalesInPriceDtl();
    await salesInPriceTargetProvider.createTableSalesInPriceTarget();
    await customersGroupProvider.createTableCustomersGroup();
    await customersGroupDetailProvider.createTableCustomersGroupDetail();
    await sapOrderDeliveryProvider.createTableSapOrderDelivery();
    await transferUpdateLogProvider.createTableTransferUpdateLog();
    await productBranchMappingProvider.createTableProductBranchMapping();
  }

  Future<bool> initData(String dateCreateFile) async {
    bool isInitData = true;

    try {
      DatabaseProvider db = DatabaseProvider();
      var database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      var batch = database.batch();

      final Directory tempDir = await getTemporaryDirectory();
      final String tempPathMaster = '${tempDir.path}/masterdata/';
      final String tempPathSalesman = '${tempDir.path}/salesmandata/';

      // check mapping json file
      if (!(await mapping(tempPathMaster, DefTableConstant.masterFiles)) ||
          !(await mapping(tempPathSalesman, DefTableConstant.salesmanFiles))) {
        // isInitData = false;
        // return isInitData;
      }

      String filePath = '';
      // ==== master data ====
      //m_area
      filePath = tempPathMaster + DefTableConstant.JSON_AREA;
      await insertAll<Area>(
          filePath, (json) => Area.fromJson(json), areaProvider, batch);

      //m_brand
      filePath = tempPathMaster + DefTableConstant.JSON_BRAND;
      await insertAll<Brand>(
          filePath, (json) => Brand.fromJson(json), brandProvider, batch);

      //m_customer_property
      filePath = tempPathMaster + DefTableConstant.JSON_CUSTOMER_PROPERTY;
      await insertAll<CustomerProperty>(
          filePath,
          (json) => CustomerProperty.fromJson(json),
          customerPropertyProvider,
          batch);

      //m_district
      filePath = tempPathMaster + DefTableConstant.JSON_DISTRICT;
      await insertAll<District>(
          filePath, (json) => District.fromJson(json), districtProvider, batch);

      //m_language
      filePath = tempPathMaster + DefTableConstant.JSON_LANGUAGE;
      await insertAll<Language>(
          filePath, (json) => Language.fromJson(json), languageProvider, batch);

      //m_messages
      filePath = tempPathMaster + DefTableConstant.JSON_MESSAGES;
      await insertAll<Messages>(
          filePath, (json) => Messages.fromJson(json), messagesProvider, batch);

      //m_product_type
      filePath = tempPathMaster + DefTableConstant.JSON_PRODUCT_TYPE;
      await insertAll<ProductType>(filePath,
          (json) => ProductType.fromJson(json), productTypeProvider, batch);

      //m_product
      filePath = tempPathMaster + DefTableConstant.JSON_PRODUCT;
      await insertAll<Product>(
          filePath, (json) => Product.fromJson(json), productProvider, batch);

      //m_province
      filePath = tempPathMaster + DefTableConstant.JSON_PROVINCE;
      await insertAll<Province>(
          filePath, (json) => Province.fromJson(json), provinceProvider, batch);

      //m_reason
      filePath = tempPathMaster + DefTableConstant.JSON_REASON;
      await insertAll<Reason>(
          filePath, (json) => Reason.fromJson(json), reasonProvider, batch);

      //m_resource
      filePath = tempPathMaster + DefTableConstant.JSON_RESOURCE;
      await insertAll<Resource>(
          filePath, (json) => Resource.fromJson(json), resourceProvider, batch);

      //m_uom
      filePath = tempPathMaster + DefTableConstant.JSON_UOM;
      await insertAll<UOM>(
          filePath, (json) => UOM.fromJson(json), uomProvider, batch);

      //m_ward
      filePath = tempPathMaster + DefTableConstant.JSON_WARD;
      await insertAll<Ward>(
          filePath, (json) => Ward.fromJson(json), wardProvider, batch);

      //m_shift
      filePath = tempPathMaster + DefTableConstant.JSON_SHIFT;
      await insertAll<Shift>(
          filePath, (json) => Shift.fromJson(json), shiftProvider, batch);

      //m_shift
      filePath = tempPathMaster + DefTableConstant.JSON_PRODUCT_BRANCH_MAPPING;
      await insertAll<ProductBranchMapping>(
          filePath,
          (json) => ProductBranchMapping.fromJson(json),
          productBranchMappingProvider,
          batch);
      // // =====================

      // // ======= salesman data ======
      //m_customer_property_mapping
      filePath =
          tempPathSalesman + DefTableConstant.JSON_CUSTOMER_PROPERTY_MAAPING;
      await insertAll<CustomerPropertyMapping>(
          filePath,
          (json) => CustomerPropertyMapping.fromJson(json),
          customerPropertyMappingProvider,
          batch);

      //m_account_position_link
      filePath = tempPathSalesman + DefTableConstant.JSON_ACCOUNT_POSITION_LINK;
      await insertAll<AccountPositionLink>(
          filePath,
          (json) => AccountPositionLink.fromJson(json),
          accountPositionLinkProvider,
          batch);

      //m_account
      filePath = tempPathSalesman + DefTableConstant.JSON_ACCOUNT;
      await insertAll<Account>(
          filePath, (json) => Account.fromJson(json), accountProvider, batch);

      //m_customer_address
      filePath = tempPathSalesman + DefTableConstant.JSON_CUSTOMER_ADDRESS;
      await insertAll<CustomerAddress>(
          filePath,
          (json) => CustomerAddress.fromJson(json),
          customerAddressProvider,
          batch);

      //m_customer
      filePath = tempPathSalesman + DefTableConstant.JSON_CUSTOMER;
      await insertAll<Customer>(
          filePath, (json) => Customer.fromJson(json), customerProvider, batch);

      //m_discount_condition
      filePath = tempPathSalesman + DefTableConstant.JSON_DISCOUNT_CONDITION;
      await insertAll<DiscountCondition>(
          filePath,
          (json) => DiscountCondition.fromJson(json),
          discountConditionProvider,
          batch);

      //m_discount_result
      filePath = tempPathSalesman + DefTableConstant.JSON_DISCOUNT_RESULT;
      await insertAll<DiscountResult>(
          filePath,
          (json) => DiscountResult.fromJson(json),
          discountResultProvider,
          batch);

      //m_discount_scheme
      filePath = tempPathSalesman + DefTableConstant.JSON_DISCOUNT_SCHEME;
      await insertAll<DiscountScheme>(
          filePath,
          (json) => DiscountScheme.fromJson(json),
          discountSchemeProvider,
          batch);

      //m_discount_target
      filePath = tempPathSalesman + DefTableConstant.JSON_DISCOUNT_TARGET;
      await insertAll<DiscountTarget>(
          filePath,
          (json) => DiscountTarget.fromJson(json),
          discountTargetProvider,
          batch);

      //m_discount
      filePath = tempPathSalesman + DefTableConstant.JSON_DISCOUNT;
      await insertAll<Discount>(
          filePath, (json) => Discount.fromJson(json), discountProvider, batch);

      //m_employee_position_link
      filePath =
          tempPathSalesman + DefTableConstant.JSON_EMPLOYEE_POSITION_LINK;
      await insertAll<EmployeePositionLink>(
          filePath,
          (json) => EmployeePositionLink.fromJson(json),
          employeePositionLinkProvider,
          batch);

      //m_employee
      filePath = tempPathSalesman + DefTableConstant.JSON_EMPLOYEE;
      await insertAll<Employee>(
          filePath, (json) => Employee.fromJson(json), employeeProvider, batch);

      //m_promotion_condition
      filePath = tempPathSalesman + DefTableConstant.JSON_PROMOTION_CONDITION;
      await insertAll<PromotionCondition>(
          filePath,
          (json) => PromotionCondition.fromJson(json),
          promotionConditionProvider,
          batch);

      //m_promotion_result
      filePath = tempPathSalesman + DefTableConstant.JSON_PROMOTION_RESULT;
      await insertAll<PromotionResult>(
          filePath,
          (json) => PromotionResult.fromJson(json),
          promotionResultProvider,
          batch);

      //m_promotion_scheme
      filePath = tempPathSalesman + DefTableConstant.JSON_PROMOTION_SCHEME;
      await insertAll<PromotionScheme>(
          filePath,
          (json) => PromotionScheme.fromJson(json),
          promotionSchemeProvider,
          batch);

      //m_promotion_target
      filePath = tempPathSalesman + DefTableConstant.JSON_PROMOTION_TARGET;
      await insertAll<PromotionTarget>(
          filePath,
          (json) => PromotionTarget.fromJson(json),
          promotionTargetProvider,
          batch);

      //m_promotion
      filePath = tempPathSalesman + DefTableConstant.JSON_PROMOTION;
      await insertAll<Promotion>(filePath, (json) => Promotion.fromJson(json),
          promotionProvider, batch);

      //m_route_assignment
      filePath = tempPathSalesman + DefTableConstant.JSON_ROUTE_ASSIGNMENT;
      await insertAll<RouteAssignment>(
          filePath,
          (json) => RouteAssignment.fromJson(json),
          routeAssignmentProvider,
          batch);

      //m_survey_target
      filePath = tempPathSalesman + DefTableConstant.JSON_SURVEY_TARGET;
      await insertAll<SurveyTarget>(filePath,
          (json) => SurveyTarget.fromJson(json), surveyTargetProvider, batch);

      //m_survey
      filePath = tempPathSalesman + DefTableConstant.JSON_SURVEY;
      await insertAll<Survey>(
          filePath, (json) => Survey.fromJson(json), surveyProvider, batch);

      //m_custopmer_liabilities
      filePath = tempPathSalesman + DefTableConstant.JSON_CUSTOMER_LIABILITIES;
      await insertAll<CustomerLiabilities>(
          filePath,
          (json) => CustomerLiabilities.fromJson(json),
          customerLiabilitiesProvider,
          batch);

      //w_stock_balance
      filePath = tempPathSalesman + DefTableConstant.JSON_STOCK_BALANCE;
      await insertAll<StockBalance>(filePath,
          (json) => StockBalance.fromJson(json), stockBalanceProvider, batch);

      //s_order
      filePath = tempPathSalesman + DefTableConstant.JSON_ORDER;
      await insertAll<Order>(
          filePath, (json) => Order.fromJson(json), orderProvider, batch);

      //s_order_dtl
      filePath = tempPathSalesman + DefTableConstant.JSON_ORDER_DTL;
      await insertAll<OrderDetail>(filePath,
          (json) => OrderDetail.fromJson(json), orderDetailProvider, batch);

      //s_order_promotion_result
      filePath =
          tempPathSalesman + DefTableConstant.JSON_ORDER_PROMOTION_RESULT;
      await insertAll<OrderPromotionResult>(
          filePath,
          (json) => OrderPromotionResult.fromJson(json),
          orderPromotionResultProvider,
          batch);

      //s_order_discount_result
      filePath = tempPathSalesman + DefTableConstant.JSON_ORDER_DISCOUNT_RESULT;
      await insertAll<OrderDiscountResult>(
          filePath,
          (json) => OrderDiscountResult.fromJson(json),
          orderDiscountResultProvider,
          batch);

      //sap_order
      filePath = tempPathSalesman + DefTableConstant.JSON_SAP_ORDER;
      await insertAll<SapOrder>(
          filePath, (json) => SapOrder.fromJson(json), sapOrderProvider, batch);

      //sap_order
      filePath = tempPathSalesman + DefTableConstant.JSON_SAP_ORDER_DTL;
      await insertAll<SapOrderDtl>(filePath,
          (json) => SapOrderDtl.fromJson(json), sapOrderDtlProvider, batch);

      // s_shift_report
      filePath = tempPathSalesman + DefTableConstant.JSON_SHIFT_REPORT;
      await insertAll<ShiftReport>(filePath,
          (json) => ShiftReport.fromJson(json), shiftReportProvider, batch);

      //s_customer_stock
      filePath = tempPathSalesman + DefTableConstant.JSON_CUSTOMER_STOCK;
      await insertAll<CustomerStock>(filePath,
          (json) => CustomerStock.fromJson(json), customerStockProvider, batch);

      //s_customer_price
      filePath = tempPathSalesman + DefTableConstant.JSON_CUSTOMER_PRICE;
      await insertAll<CustomerPrice>(filePath,
          (json) => CustomerPrice.fromJson(json), customerPriceProvider, batch);

      //s_customer_visit
      filePath = tempPathSalesman + DefTableConstant.JSON_CUSTOMER_VISIT;
      await insertAll<CustomerVisit>(filePath,
          (json) => CustomerVisit.fromJson(json), customerVisitProvider, batch);

      //m_sales_in_price
      filePath = tempPathSalesman + DefTableConstant.JSON_SALES_IN_PRICE;
      await insertAll<SalesInPrice>(filePath,
          (json) => SalesInPrice.fromJson(json), salesInPriceProvider, batch);

      //m_sales_in_price_dtl
      filePath = tempPathSalesman + DefTableConstant.JSON_SALES_IN_PRICE_DTL;
      await insertAll<SalesInPriceDtl>(
          filePath,
          (json) => SalesInPriceDtl.fromJson(json),
          salesInPriceDtlProvider,
          batch);

      //m_sales_in_price_target
      filePath = tempPathSalesman + DefTableConstant.JSON_SALES_IN_PRICE_TARGET;
      await insertAll<SalesInPriceTarget>(
          filePath,
          (json) => SalesInPriceTarget.fromJson(json),
          salesInPriceTargetProvider,
          batch);

      //m_customers_group
      filePath = tempPathSalesman + DefTableConstant.JSON_CUSTOMERS_GROUP;
      await insertAll<CustomersGroup>(
          filePath,
          (json) => CustomersGroup.fromJson(json),
          customersGroupProvider,
          batch);

      //m_customers_group_detail
      filePath =
          tempPathSalesman + DefTableConstant.JSON_CUSTOMERS_GROUP_DETAIL;
      await insertAll<CustomersGroupDetail>(
          filePath,
          (json) => CustomersGroupDetail.fromJson(json),
          customersGroupDetailProvider,
          batch);

      //s_sap_order_delivery
      filePath = tempPathSalesman + DefTableConstant.JSON_SAP_ORDER_DELIVERY;
      await insertAll<SapOrderDelivery>(
          filePath,
          (json) => SapOrderDelivery.fromJson(json),
          sapOrderDeliveryProvider,
          batch);

      //w_transfer_update_log
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? baPositionId = prefs.getInt('baPositionId');
      String nowTime =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      TransferUpdateLog transferUpdateLog = TransferUpdateLog(
          baPositionId: prefs.getInt('baPositionId'),
          dateLastestUpdate: dateCreateFile,
          status: '01',
          createdBy: baPositionId,
          createdDate: nowTime,
          updatedBy: baPositionId,
          updatedDate: nowTime);
      await transferUpdateLogProvider.insertForInit(transferUpdateLog, batch);

      //update lastest
      String? imeiDevice = await UniqueIdentifier.serial;
      MappingErrorObject errorLog =
          const MappingErrorObject(objectFail: 'getUpdatedata', log: 'success');
      UpdateLatestRequest requestLastest = UpdateLatestRequest(
          positionId: baPositionId,
          imei: imeiDevice,
          updateDate: nowTime,
          updateStatus: '01',
          mappingErrorObject: errorLog);
      String requestBodyJson = jsonEncode(requestLastest);
      CallApiUtils<dynamic> sendRequestAPI = CallApiUtils<dynamic>();
      APIResponseHeader responselatest = await sendRequestAPI.sendRequestAPI(
          APIs.syncLogging, requestBodyJson);
      // ============================
      await batch.commit(noResult: true);
    } catch (err) {
      print('init data exception $err');
      isInitData = false;
    }

    return isInitData;

    //m_area_level
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_AREA_LEVEL;
    // insertAll<AreaLevel>(
    //     filePath, (json) => AreaLevel.fromJson(json), areaLevelProvider);

    //m_category
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_CATEGORY;
    // insertAll<MCategory>(
    //     filePath, (json) => MCategory.fromJson(json), categoryProvider);

    //m_membership
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_MEMBERSHIP;
    // insertAll<Membership>(
    //     filePath, (json) => Membership.fromJson(json), membershipProvider);

    //s_customer_price
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_CUSTOMER_PRICE;
    // insertAll<CustomerPrice>(filePath, (json) => CustomerPrice.fromJson(json),
    //     customerPriceProvider);

    // //s_customer_stock
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_CUSTOMER_STOCK;
    // insertAll<CustomerStock>(filePath, (json) => CustomerStock.fromJson(json),
    //     customerStockProvider);

    // //s_customer_visit
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_CUSTOMER_VISIT;
    // insertAll<CustomerVisit>(filePath, (json) => CustomerVisit.fromJson(json),
    //     customerVisitProvider);

    //s_order_dtl
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_ORDER_DTL;
    // insertAll<OrderDetail>(
    //     filePath, (json) => OrderDetail.fromJson(json), orderDetailProvider);

    // //s_order
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_ORDER;
    // insertAll<Order>(filePath, (json) => Order.fromJson(json), orderProvider);

    //s_shift_report
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_SHIFT_REPORT;
    // insertAll<ShiftReport>(
    //     filePath, (json) => ShiftReport.fromJson(json), shiftReportProvider);

    //s_suvey_result
    // filePath = Constant.PATH_FOLDER_SYNC_DATA + Constant.JSON_SURVEY_RESULT;
    // insertAll<SurveyResult>(
    //     filePath, (json) => SurveyResult.fromJson(json), surveyResultProvider);
  }

  Future<void> insertAll<T>(
      String filePath,
      T Function(
        dynamic,
      ) fromJson,
      dynamic provider,
      Batch batch) async {
    // final String jsonString = await rootBundle.loadString(filePath);
    // final List<dynamic> jsonData = json.decode(jsonString);
    // List<T> lstData = List<T>.from(jsonData.map((model) => fromJson(model)));
    // provider.insertMultipleRow(lstData);
    final File file = File(filePath);
    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      List<T> lstData = List<T>.from(jsonData.map((model) => fromJson(model)));
      provider.insertMultipleRow(lstData, batch);
    } else {
      print('File does not exist: $filePath');
      // Xử lý khi tệp không tồn tại
    }
  }

  Future<bool> mapping(String folderPath, List<String> fileNames) async {
    bool isValid = true;
    Directory directory = Directory(folderPath);
    if (await directory.exists()) {
      for (var fileName in fileNames) {
        File file = File('${directory.path}/$fileName');
        if (!(await file.exists())) {
          isValid = false;
          print('file $fileName not exist');
          break;
        }
      }
    }
    return isValid;
  }
}
