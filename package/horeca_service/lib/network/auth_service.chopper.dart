// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthService extends AuthService {
  _$AuthService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthService;

  @override
  Future<Response<dynamic>> login(LoginRequest request) {
    final Uri $url = Uri.parse('/api/auth/login');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> oauth(
    String grantType,
    String username,
    String password,
  ) {
    final Uri $url = Uri.parse('/oauth/token');
    final $body = <String, dynamic>{
      'grant_type': grantType,
      'username': username,
      'password': password,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>(
      $request,
      requestConverter: FormUrlEncodedConverter.requestFactory,
    );
  }

  @override
  Future<Response<dynamic>> getInitData(String baPositionId) {
    final Uri $url =
        Uri.parse('/api/sync/getInitData?baPositionId=${baPositionId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> downloadFile(
    String dataType,
    String fileName,
  ) {
    final Uri $url = Uri.parse(
        '/api/downloadFile?dataType=${dataType}&fileName=${fileName}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUpdateData(
    String baPositionId,
    String imeiDevice,
    String dateCreate,
    String jobSeqId,
  ) {
    final Uri $url = Uri.parse('/api/sync/getUpdateData');
    final Map<String, dynamic> $params = <String, dynamic>{
      'baPositionId': baPositionId,
      'imeiDevice': imeiDevice,
      'dateCreate': dateCreate,
      'jobSeqId': jobSeqId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateLatest(UpdateLatestRequest request) {
    final Uri $url = Uri.parse('/sync/updateLatest');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> requestUpdateData(RequestUpdateRequest request) {
    final Uri $url = Uri.parse('/sync/requestUpdateData');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> membershipFindAll() {
    final Uri $url = Uri.parse('/membership/findAll');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAPK() {
    final Uri $url = Uri.parse('/api/sync/getAPK');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> membershipSave(MembershipModelRequest request) {
    final Uri $url = Uri.parse('/membership/save');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> endShift(ShiftEndRequest request) {
    final Uri $url = Uri.parse('/shift/endShift');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> startShift(ShiftStartRequest request) {
    final Uri $url = Uri.parse('/shift/startShift');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> custommerVisitCheckin(
      CustomerVisitCheckinRequest request) {
    final Uri $url = Uri.parse('/visit/checkin');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> customerVisitRevisit(
      CustomerVisitCheckinRequest request) {
    final Uri $url = Uri.parse('/visit/revisit');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> customerVisitCheckout(
      CustomerVisitCheckoutRequest request) {
    final Uri $url = Uri.parse('/visit/checkout');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> customerVisitCalcel(
      CustomerVisitCancelRequest request) {
    final Uri $url = Uri.parse('/visit/cancel');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkStockCustomer(
      CustomerStockCheckStockRequest request) {
    final Uri $url = Uri.parse('/stock/checkStockCustomer');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> saveRedeem(RedeemSaveRequest request) {
    final Uri $url = Uri.parse('/redeem/save');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
