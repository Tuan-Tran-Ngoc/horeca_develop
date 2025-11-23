import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:connectivity/connectivity.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/def_table_constant.dart';
import 'package:horeca_service/contants/network.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/model/request/request_update_request.dart';
import 'package:horeca_service/model/request/update_latest_request.dart';
import 'package:horeca_service/model/response/api_response_header.dart';
import 'package:horeca_service/model/response/get_update_data_response.dart';
import 'package:horeca_service/model/response/request_update_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:http/http.dart' as http;

class UpdateDataService {
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
  DataDeleteProvide dataDeleteProvide = DataDeleteProvide();
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

  Future<String> syncUpdateData(AppLocalizations multiLang) async {
    String? imeiDevice = await UniqueIdentifier.serial;
    String message = '';
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    String username = prefs.getString('username') ?? '';
    print('imeiDevice: ${imeiDevice}');
    if (imeiDevice == null) {
      message = multiLang
          .notFound([multiLang.information, multiLang.imeiDevice].join(" "));
      return message;
    }

    var connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      // request call API: requestUpdateData
      CallApiUtils<RequestUpdateResponse> callApiRequestUpdateData =
          CallApiUtils();

      // get date lastest update
      TransferUpdateLog? transferUpdateLog =
          await transferUpdateLogProvider.select(baPositionId ?? 0);

      if (transferUpdateLog == null ||
          transferUpdateLog.dateLastestUpdate == null) {
        message = multiLang.msgGetInfoLastestUpdate;
        return message;
      }

      RequestUpdateRequest requestUpdateData = RequestUpdateRequest(
          baPositionId: baPositionId,
          imeiDevice: imeiDevice,
          dateLastestUpdate: transferUpdateLog.dateLastestUpdate);

      Map<String, dynamic> jsonMapping = requestUpdateData.toJson();
      String json = jsonEncode(jsonMapping);
      print('requestUpdateData $json');

      APIResponseEntity<RequestUpdateResponse> responseRequestUpdateData =
          await callApiRequestUpdateData.callApiPostMethod(
              APIs.syncRequestUpdateData, json, RequestUpdateResponse.fromJson);
      RequestUpdateResponse? response = responseRequestUpdateData.data;

      // request call API: getUpdateData
      if (response == null) {
        message = [
          multiLang.sendRequest,
          multiLang.updateData,
          multiLang.failed
        ].join(" ");
        return message;
      }

      int countCallUpdateData = 0;
      late APIResponseEntity<GetUpdateDataResponse> getInitResponse;
      CallApiUtils<GetUpdateDataResponse> callApiUtils = CallApiUtils();
      try {
        while (countCallUpdateData < 3) {
          print('countCallUpdateData $countCallUpdateData');
          sleep(const Duration(seconds: 5));
          Map<String, dynamic> queryParams = {};
          queryParams['baPositionId'] = prefs.getInt('baPositionId').toString();
          queryParams['imeiDevice'] = imeiDevice;
          queryParams['dateCreate'] = response.dateCreateFile ?? '';
          queryParams['jobSeqId'] = response.jobSeqId.toString();
          getInitResponse = await callApiUtils.callApiGetMethod(
              APIs.syncGetUpdateData,
              queryParams,
              GetUpdateDataResponse.fromJson);
          if (getInitResponse.data != null) {
            final GetUpdateDataResponse response = getInitResponse.data!;
            if (response.fileName != null) {
              break;
            }
          }
          countCallUpdateData++;
        }
      } catch (error) {
        return error.toString();
      }

      print(getInitResponse);

      if (getInitResponse.data != null) {
        final GetUpdateDataResponse response = getInitResponse.data!;
        if (response.fileName == null) {
          message = multiLang
              .notFound([multiLang.information, multiLang.update].join(" "));
          return message;
        }
        await downloadUnzip(response.fileName.toString(), 'updatedata')
            .then((value) async {
          // write log update data
          try {
            UpdateDataService updateDataService = UpdateDataService();
            bool isUpdateData = await updateDataService.updateData();

            if (!isUpdateData) {
              message = [multiLang.updateData, multiLang.unsucess].join(" ");
              throw message;
            }

            //copy file
            final Directory tempDir = await getTemporaryDirectory();
            final String tempPathUpdateData = '${tempDir.path}/updatedata';
            var databasesPath = await getDatabasesPath();
            await copyDirectory('$tempPathUpdateData/genHtml',
                '$databasesPath/$username/genHtml');
            await copyDirectory('$tempPathUpdateData/masterPhoto',
                '$databasesPath/$username/masterPhoto');
            await copyDirectory(
                '$tempPathUpdateData/lib', '$databasesPath/$username/lib');

            // write log update data
            try {
              MappingErrorObject errorLog = const MappingErrorObject(
                  objectFail: 'getUpdatedata', log: 'success');
              UpdateLatestRequest requestLastest = UpdateLatestRequest(
                  positionId: baPositionId,
                  imei: imeiDevice,
                  updateDate: response.dateCreateFile,
                  updateStatus: '01',
                  mappingErrorObject: errorLog);
              String requestBodyJson = jsonEncode(requestLastest);
              CallApiUtils<dynamic> sendRequestAPI = CallApiUtils<dynamic>();
              APIResponseHeader responseLatest = await sendRequestAPI
                  .sendRequestAPI(APIs.syncLogging, requestBodyJson);
            } catch (err) {
              print('${APIs.syncLogging} error line 628: ${err.toString()}');
            }

            // get date lastest update
            TransferUpdateLog? transferUpdateLog =
                await transferUpdateLogProvider.select(baPositionId ?? 0);
            String lastestUpdate = transferUpdateLog?.dateLastestUpdate ?? '';
            if (lastestUpdate != '') {
              lastestUpdate = CommonUtils.convertDate(
                  lastestUpdate, Constant.dateFormatterYYYYMMDDHHMM);
            }

            message = [multiLang.updateData, multiLang.success].join(" ");
            //emit(UpdateDataSuccess(message, lastestUpdate));
          } catch (err) {
            // write log update data
            MappingErrorObject errorLog = MappingErrorObject(
                objectFail: 'getUpdatedata', log: err.toString());
            UpdateLatestRequest requestLastest = UpdateLatestRequest(
                positionId: baPositionId,
                imei: imeiDevice,
                updateDate: response.dateCreateFile,
                updateStatus: '00',
                mappingErrorObject: errorLog);
            String requestBodyJson = jsonEncode(requestLastest);
            CallApiUtils<dynamic> sendRequestAPI = CallApiUtils<dynamic>();
            APIResponseHeader responseLatest = await sendRequestAPI
                .sendRequestAPI(APIs.syncLogging, requestBodyJson);

            return err.toString();
          }
        });

        //init data
      } else {
        message = [multiLang.updateData, multiLang.failed].join(" ");
        return message;
      }
      return '';
    } else {
      message = multiLang.turnOnInternet(multiLang.updateData);
      return message;
    }
  }

  Future<void> downloadUnzip(String masterUrlFile, String type) async {
    final headers = <String, String>{
      'Authorization': 'Bearer ${prefs.getString('token')}',
      // Add other headers as needed
    };
    final getDownloadResponse = await http.get(
        Uri.parse(
            '${Network.url}/api/downloadFile?dataType=$type&fileName=$masterUrlFile'),
        headers: headers);
    // final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    // print(getDownloadResponse.body);
    if (getDownloadResponse.statusCode == 200) {
      // Get the app's temporary directory to store the downloaded file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      // Replace 'downloaded_file.txt' with the desired filename
      final String filePath = '$tempPath/$masterUrlFile';

      // Write the content of the response to the file
      final File file =
          await File(filePath).writeAsBytes(getDownloadResponse.bodyBytes);

      print('File downloaded successfully at: $file');
      await unzipFile(file.path, type);
    }
  }

  Future<void> unzipFile(String zipFilePath, String type) async {
    // Read the Zip file from disk.
    final bytes = File(zipFilePath).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/$type';
    print('tempPath: $tempPath');
    // delete old folder
    final Directory oldDirectory = Directory(tempPath);
    if (await oldDirectory.exists()) {
      await oldDirectory.delete(recursive: true);
    }

    final Directory newDirectory = Directory(tempPath);
    await newDirectory.create(recursive: true);
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$tempPath/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$tempPath/$filename').create(recursive: true);
      }
    }
  }

  Future<void> copyDirectory(String sourcePath, String destinationPath) async {
    try {
      // check sourcePath exist
      if (!await Directory(sourcePath).exists()) {
        print('tempPath: $sourcePath not exisit');
        return;
      }

      // Lấy danh sách tất cả các tệp và thư mục trong thư mục nguồn
      List<FileSystemEntity> entities =
          Directory(sourcePath).listSync(recursive: true);

      //override old directory
      await Directory(destinationPath).create(recursive: true);

      // Sao chép từng tệp và thư mục sang thư mục đích
      for (var entity in entities) {
        String newPath = entity.path.replaceFirst(sourcePath, destinationPath);
        if (entity is Directory) {
          await Directory(newPath).create(recursive: true);
        } else if (entity is File) {
          await entity.copy(newPath);
        }
      }
    } catch (e) {
      print(
          'Update data: Copy Directory Fail $sourcePath -> $destinationPath: ${e.toString()}');
    }
  }

  Future<bool> updateData() async {
    bool isUpdateData = true;

    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPathUpdateData = '${tempDir.path}/updatedata/';

      // check mapping json file
      if (!(await mapping(tempPathUpdateData, DefTableConstant.updateFiles))) {
        // isUpdateData = false;
        // return isUpdateData;
      }

      String filePath = '';
      DatabaseProvider db = DatabaseProvider();
      var database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      var batch = database.batch();

      // ========= delete data =======
      filePath = tempPathUpdateData + DefTableConstant.JSON_DATA_DELETE;
      await dataDelete(filePath, batch);
      // ========= start insert data =======
      //m_brand
      filePath = tempPathUpdateData + DefTableConstant.JSON_BRAND;
      await insertAll<Brand>(
          filePath, (json) => Brand.fromJson(json), brandProvider, batch);

      //m_customer_address
      filePath = tempPathUpdateData + DefTableConstant.JSON_CUSTOMER_ADDRESS;
      await insertAll<CustomerAddress>(
          filePath,
          (json) => CustomerAddress.fromJson(json),
          customerAddressProvider,
          batch);

      //m_customer_liabilities
      filePath =
          tempPathUpdateData + DefTableConstant.JSON_CUSTOMER_LIABILITIES;
      await insertAll<CustomerLiabilities>(
          filePath,
          (json) => CustomerLiabilities.fromJson(json),
          customerLiabilitiesProvider,
          batch);

      //m_customer
      filePath = tempPathUpdateData + DefTableConstant.JSON_CUSTOMER;
      await insertAll<Customer>(
          filePath, (json) => Customer.fromJson(json), customerProvider, batch);

      //m_customer_property
      filePath = tempPathUpdateData + DefTableConstant.JSON_CUSTOMER_PROPERTY;
      await insertAll<CustomerProperty>(
          filePath,
          (json) => CustomerProperty.fromJson(json),
          customerPropertyProvider,
          batch);

      //m_customer_property_mapping
      filePath =
          tempPathUpdateData + DefTableConstant.JSON_CUSTOMER_PROPERTY_MAAPING;
      await insertAll<CustomerPropertyMapping>(
          filePath,
          (json) => CustomerPropertyMapping.fromJson(json),
          customerPropertyMappingProvider,
          batch);

      //m_discount_condition
      filePath = tempPathUpdateData + DefTableConstant.JSON_DISCOUNT_CONDITION;
      await insertAll<DiscountCondition>(
          filePath,
          (json) => DiscountCondition.fromJson(json),
          discountConditionProvider,
          batch);

      //m_discount_result
      filePath = tempPathUpdateData + DefTableConstant.JSON_DISCOUNT_RESULT;
      await insertAll<DiscountResult>(
          filePath,
          (json) => DiscountResult.fromJson(json),
          discountResultProvider,
          batch);

      //m_discount_scheme
      filePath = tempPathUpdateData + DefTableConstant.JSON_DISCOUNT_SCHEME;
      await insertAll<DiscountScheme>(
          filePath,
          (json) => DiscountScheme.fromJson(json),
          discountSchemeProvider,
          batch);

      //m_discount_target
      filePath = tempPathUpdateData + DefTableConstant.JSON_DISCOUNT_TARGET;
      await insertAll<DiscountTarget>(
          filePath,
          (json) => DiscountTarget.fromJson(json),
          discountTargetProvider,
          batch);

      //m_discount
      filePath = tempPathUpdateData + DefTableConstant.JSON_DISCOUNT;
      await insertAll<Discount>(
          filePath, (json) => Discount.fromJson(json), discountProvider, batch);

      //m_messages
      filePath = tempPathUpdateData + DefTableConstant.JSON_MESSAGES;
      await insertAll<Messages>(
          filePath, (json) => Messages.fromJson(json), messagesProvider, batch);

      //m_product_type
      filePath = tempPathUpdateData + DefTableConstant.JSON_PRODUCT_TYPE;
      await insertAll<ProductType>(filePath,
          (json) => ProductType.fromJson(json), productTypeProvider, batch);

      //m_product
      filePath = tempPathUpdateData + DefTableConstant.JSON_PRODUCT;
      await insertAll<Product>(
          filePath, (json) => Product.fromJson(json), productProvider, batch);

      //m_promotion_condition
      filePath = tempPathUpdateData + DefTableConstant.JSON_PROMOTION_CONDITION;
      await insertAll<PromotionCondition>(
          filePath,
          (json) => PromotionCondition.fromJson(json),
          promotionConditionProvider,
          batch);

      //m_promotion_result
      filePath = tempPathUpdateData + DefTableConstant.JSON_PROMOTION_RESULT;
      await insertAll<PromotionResult>(
          filePath,
          (json) => PromotionResult.fromJson(json),
          promotionResultProvider,
          batch);

      //m_promotion_scheme
      filePath = tempPathUpdateData + DefTableConstant.JSON_PROMOTION_SCHEME;
      await insertAll<PromotionScheme>(
          filePath,
          (json) => PromotionScheme.fromJson(json),
          promotionSchemeProvider,
          batch);

      //m_promotion_target
      filePath = tempPathUpdateData + DefTableConstant.JSON_PROMOTION_TARGET;
      await insertAll<PromotionTarget>(
          filePath,
          (json) => PromotionTarget.fromJson(json),
          promotionTargetProvider,
          batch);

      //m_promotion
      filePath = tempPathUpdateData + DefTableConstant.JSON_PROMOTION;
      await insertAll<Promotion>(filePath, (json) => Promotion.fromJson(json),
          promotionProvider, batch);

      //m_resource
      filePath = tempPathUpdateData + DefTableConstant.JSON_RESOURCE;
      await insertAll<Resource>(
          filePath, (json) => Resource.fromJson(json), resourceProvider, batch);

      //m_route_assignment
      filePath = tempPathUpdateData + DefTableConstant.JSON_ROUTE_ASSIGNMENT;
      await insertAll<RouteAssignment>(
          filePath,
          (json) => RouteAssignment.fromJson(json),
          routeAssignmentProvider,
          batch);

      //m_sales_in_price
      filePath = tempPathUpdateData + DefTableConstant.JSON_SALES_IN_PRICE;
      await insertAll<SalesInPrice>(filePath,
          (json) => SalesInPrice.fromJson(json), salesInPriceProvider, batch);

      //m_sales_in_price_dtl
      filePath = tempPathUpdateData + DefTableConstant.JSON_SALES_IN_PRICE_DTL;
      await insertAll<SalesInPriceDtl>(
          filePath,
          (json) => SalesInPriceDtl.fromJson(json),
          salesInPriceDtlProvider,
          batch);

      //m_sales_in_price_target
      filePath =
          tempPathUpdateData + DefTableConstant.JSON_SALES_IN_PRICE_TARGET;
      await insertAll<SalesInPriceTarget>(
          filePath,
          (json) => SalesInPriceTarget.fromJson(json),
          salesInPriceTargetProvider,
          batch);

      //m_customers_group_detail
      filePath =
          tempPathUpdateData + DefTableConstant.JSON_CUSTOMERS_GROUP_DETAIL;
      await insertAll<CustomersGroupDetail>(
          filePath,
          (json) => CustomersGroupDetail.fromJson(json),
          customersGroupDetailProvider,
          batch);

      //m_customers_group
      filePath = tempPathUpdateData + DefTableConstant.JSON_CUSTOMERS_GROUP;
      await insertAll<CustomersGroup>(
          filePath,
          (json) => CustomersGroup.fromJson(json),
          customersGroupProvider,
          batch);

      //s_sap_order_delivery
      filePath = tempPathUpdateData + DefTableConstant.JSON_SAP_ORDER_DELIVERY;
      await insertAll<SapOrderDelivery>(
          filePath,
          (json) => SapOrderDelivery.fromJson(json),
          sapOrderDeliveryProvider,
          batch);

      //m_shift
      filePath = tempPathUpdateData + DefTableConstant.JSON_SHIFT;
      await insertAll<Shift>(
          filePath, (json) => Shift.fromJson(json), shiftProvider, batch);

      //m_survey_target
      filePath = tempPathUpdateData + DefTableConstant.JSON_SURVEY_TARGET;
      await insertAll<SurveyTarget>(filePath,
          (json) => SurveyTarget.fromJson(json), surveyTargetProvider, batch);

      //m_survey
      filePath = tempPathUpdateData + DefTableConstant.JSON_SURVEY;
      await insertAll<Survey>(
          filePath, (json) => Survey.fromJson(json), surveyProvider, batch);

      //s_customer_stock
      filePath = tempPathUpdateData + DefTableConstant.JSON_CUSTOMER_STOCK;
      await insertAll<CustomerStock>(filePath,
          (json) => CustomerStock.fromJson(json), customerStockProvider, batch);

      //s_customer_price
      filePath = tempPathUpdateData + DefTableConstant.JSON_CUSTOMER_PRICE;
      await insertAll<CustomerPrice>(filePath,
          (json) => CustomerPrice.fromJson(json), customerPriceProvider, batch);

      //s_customer_visit
      filePath = tempPathUpdateData + DefTableConstant.JSON_CUSTOMER_VISIT;
      await insertAll<CustomerVisit>(filePath,
          (json) => CustomerVisit.fromJson(json), customerVisitProvider, batch);

      //s_order_discount_result
      filePath =
          tempPathUpdateData + DefTableConstant.JSON_ORDER_DISCOUNT_RESULT;
      await insertAll<OrderDiscountResult>(
          filePath,
          (json) => OrderDiscountResult.fromJson(json),
          orderDiscountResultProvider,
          batch);

      //s_order_promotion_result
      filePath =
          tempPathUpdateData + DefTableConstant.JSON_ORDER_PROMOTION_RESULT;
      await insertAll<OrderPromotionResult>(
          filePath,
          (json) => OrderPromotionResult.fromJson(json),
          orderPromotionResultProvider,
          batch);

      //s_order_dtl
      filePath = tempPathUpdateData + DefTableConstant.JSON_ORDER_DTL;
      await insertAll<OrderDetail>(filePath,
          (json) => OrderDetail.fromJson(json), orderDetailProvider, batch);

      //s_order
      filePath = tempPathUpdateData + DefTableConstant.JSON_ORDER;
      await insertAll<Order>(
          filePath, (json) => Order.fromJson(json), orderProvider, batch);

      // s_shift_report
      filePath = tempPathUpdateData + DefTableConstant.JSON_SHIFT_REPORT;
      await insertAll<ShiftReport>(filePath,
          (json) => ShiftReport.fromJson(json), shiftReportProvider, batch);

      //w_stock_balance
      filePath = tempPathUpdateData + DefTableConstant.JSON_STOCK_BALANCE;
      await insertAll<StockBalance>(filePath,
          (json) => StockBalance.fromJson(json), stockBalanceProvider, batch);

      //m_product_branch_mapping
      filePath =
          tempPathUpdateData + DefTableConstant.JSON_PRODUCT_BRANCH_MAPPING;
      await insertAll<ProductBranchMapping>(
          filePath,
          (json) => ProductBranchMapping.fromJson(json),
          productBranchMappingProvider,
          batch);

      // write log lastest update data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? baPositionId = prefs.getInt('baPositionId');
      String nowTime =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      TransferUpdateLog transferUpdateLog = TransferUpdateLog(
          baPositionId: prefs.getInt('baPositionId'),
          dateLastestUpdate: nowTime,
          status: '01',
          createdBy: baPositionId,
          createdDate: nowTime,
          updatedBy: baPositionId,
          updatedDate: nowTime);
      await transferUpdateLogProvider.softDelete(
          baPositionId ?? 0, nowTime, batch);
      await transferUpdateLogProvider.insertForInit(transferUpdateLog, batch);

      await batch.commit(noResult: true);
    } catch (err) {
      print('update data exception $err');
      isUpdateData = false;

      throw Exception(err.toString());
    }

    return isUpdateData;
  }

  Future<void> insertAll<T>(
      String filePath,
      T Function(
        dynamic,
      ) fromJson,
      dynamic provider,
      Batch batch) async {
    final File file = File(filePath);
    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      List<T> lstData = List<T>.from(jsonData.map((model) => fromJson(model)));
      await provider.insertMultipleRow(lstData, batch);
    } else {
      print('File does not exist: $filePath');
      // Xử lý khi tệp không tồn tại
    }
  }

  Future<void> dataDelete(String filePath, Batch batch) async {
    //final String jsonString = await rootBundle.loadString(filePath);
    // final File file = File(filePath);
    // final String jsonString = await file.readAsString();
    final File file = File(filePath);
    final String jsonString = await file.readAsString();
    final List<dynamic> jsonData = json.decode(jsonString);
    List<DataDelete> lstData = List<DataDelete>.from(
        jsonData.map((model) => DataDelete.fromJson(model)));
    await dataDeleteProvide.deleteMultipleRow(lstData, batch);
  }

  Future<bool> mapping(String folderPath, List<String> fileNames) async {
    bool isValid = true;
    Directory directory = Directory(folderPath);
    if (await directory.exists()) {
      for (var fileName in fileNames) {
        File file = File('${directory.path}$fileName');
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
