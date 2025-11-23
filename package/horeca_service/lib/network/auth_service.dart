import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:horeca_service/model/request/customer_stock_checkstock.dart';
import 'package:horeca_service/model/request/customer_visit_cancel.dart';
import 'package:horeca_service/model/request/customer_visit_checkin.dart';
import 'package:horeca_service/model/request/customer_visit_checkout.dart';
import 'package:horeca_service/model/request/login_request.dart';
import 'package:horeca_service/model/request/member_ship_request.dart';
import 'package:horeca_service/model/request/redeem_save_request.dart';
import 'package:horeca_service/model/request/request_update_request.dart';
import 'package:horeca_service/model/request/shift_end_request.dart';
import 'package:horeca_service/model/request/shift_start_request.dart';
import 'package:horeca_service/model/request/update_latest_request.dart';
import 'package:http/http.dart' as http;

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class AuthService extends ChopperService {
  // MARK: - Login
  @Post(path: '/api/auth/login')
  Future<Response> login(@Body() LoginRequest request);

  @Post(path: '/oauth/token')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response> oauth(
    @Field('grant_type') String grantType,
    @Field('username') String username,
    @Field('password') String password,
  );

  // MARK: - Sync
  var download = "/api/downloadFile";
  var syncGetDailyData = "/api/sync/getDailyData";

  @Get(path: '/api/sync/getInitData?baPositionId={baPositionId}')
  Future<Response> getInitData(@Path('baPositionId') String baPositionId);

  @Get(path: '/api/downloadFile?dataType={dataType}&fileName={fileName}')
  Future<Response> downloadFile(
      @Path('dataType') String dataType, @Path('fileName') String fileName);

  @Get(
    path: '/api/sync/getUpdateData',
  )
  Future<Response> getUpdateData(
    @Query('baPositionId') String baPositionId,
    @Query('imeiDevice') String imeiDevice,
    @Query('dateCreate') String dateCreate,
    @Query('jobSeqId') String jobSeqId,
  );

  @Post(path: '/sync/updateLatest')
  Future<Response> updateLatest(
    @Body() UpdateLatestRequest request,
  );

  @Post(path: '/sync/requestUpdateData')
  Future<Response> requestUpdateData(
    @Body() RequestUpdateRequest request,
  );

  // MARK: - Membership

  var membershipGetInfor = "/api/membership/getInfor";

  @Get(path: '/membership/findAll')
  Future<Response> membershipFindAll();

  @Get(path: '/api/sync/getAPK')
  Future<Response> getAPK();

  // @Get(path: '/api/sync/getAPK')
  // Future<Response> dowloadApk();

  @Post(path: '/membership/save')
  Future<Response> membershipSave(@Body() MembershipModelRequest request);

  // MARK: - Shift
  @Post(path: '/shift/endShift')
  Future<Response> endShift(@Body() ShiftEndRequest request);

  @Post(path: '/shift/startShift')
  Future<Response> startShift(@Body() ShiftStartRequest request);

  // MARK: - Customer visit

  @Post(path: '/visit/checkin')
  Future<Response> custommerVisitCheckin(
      @Body() CustomerVisitCheckinRequest request);

  @Post(path: '/visit/revisit')
  Future<Response> customerVisitRevisit(
      @Body() CustomerVisitCheckinRequest request);

  @Post(path: '/visit/checkout')
  Future<Response> customerVisitCheckout(
      @Body() CustomerVisitCheckoutRequest request);

  @Post(path: '/visit/cancel')
  Future<Response> customerVisitCalcel(
      @Body() CustomerVisitCancelRequest request);

// MARK: - Check stock
  static var checkStock = "/api/stock/checkStockCustomer";
  @Post(path: '/stock/checkStockCustomer')
  Future<Response> checkStockCustomer(
      @Body() CustomerStockCheckStockRequest request);

  // MARK: - Confirm allocation
  static var confirmAllocation = "/api/stock/confirmAllocation";

  // MARK: - Create order
  static var createOrder = "/api/order/createOrder";

  // MARK: - Redemption
  static var redeem = "/api/redeem/save";
  @Post(path: '/redeem/save')
  Future<Response> saveRedeem(@Body() RedeemSaveRequest request);

  // MARK: - Pack swap
  static var packswap = "/api/packswap/save";

  // MARK: - Reward
  static var reward = "/api/reward/save";
  static var otp = "/api/reward/otp";

  // MARK: - Stock return
  static var stockReturn = "/api/stock/return";

  // MARK: - Cashback
  static var cashback = "/api/cashback/save";

  // MARK: - Change password
  static var changePassword = "/api/user/changepass";

  // MARK: - Survey
  static var survey = "/api/survey/save";
  // MARK: - Smoker
  static var smokerFindAll = "/api/smoker/findAll";
  static var smokerGetInfo = "/api/smoker/getInfor";
  static var smokerSave = "/api/smoker/save";
  static AuthService create([ChopperClient? client]) => _$AuthService(client);
}
