import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/service/visit_service.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/shift_visit_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final BuildContext context;
  CustomerCubit(this.context) : super(CustomerInitial());
  late SharedPreferences prefs;
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  CustomerAddressProvider customerAddressProvider = CustomerAddressProvider();
  ShiftProvider shiftProvider = ShiftProvider();
  ShiftReportProvider shiftReportProvider = ShiftReportProvider();
  VisitService visitService = VisitService();
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    // get info shift from global var
    int? shiftReportId = prefs.getInt(Session.shiftReportId.toString());
    String? shiftCode = prefs.getString(Session.shiftCode.toString());
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    print('Shift report id $shiftReportId');
    //get shift report inffo
    List<ShiftReport> lstShiftReport =
        await shiftReportProvider.select(shiftReportId ?? 0);

    List<ShiftVisitDto> lstShiftVisit =
        await customerVisitProvider.getPlanCustomerVisit(shiftReportId, null);

    List<ShiftVisitDto> lstCustomerTarget =
        visitService.mergeShiftVisit(lstShiftVisit);

    //await customerAddressProvider.getAllCustomerAddress();
    // print('listCustomerVisit $listCustomerVisit');
    int index = 0;
    List<List<String>> results = lstCustomerTarget.map((data) {
      index++;
      List<String> result = [];
      result.add(index.toString());
      result.add(data.customerCode.toString());
      result.add(data.customerName.toString());
      result.add(data.shiftName.toString());
      result.add(CommonUtils.convertDate(
          data.visitDate, Constant.dateFormatterYYYYMMDD));
      result.add(CommonUtils.convertDate(
          data.startTime, Constant.dateFormatterYYYYMMDDHHMM));
      result.add(CommonUtils.convertDate(
          data.endTime, Constant.dateFormatterYYYYMMDDHHMM));
      result.add(data.visitTimes.toString());
      result.add(colorRow(data.visitStatus ?? ''));
      return result;
    }).toList();
    final List<String> daysOfWeek = [
      multiLang.mon,
      multiLang.tue,
      multiLang.wed,
      multiLang.thu,
      multiLang.fri,
      multiLang.sat,
      multiLang.sun
    ];
    List<Shift> lstShift = await shiftProvider.getShift();
    var lstShiftName = lstShift.map((e) => e.shiftName ?? "").toList();

    // setting initial day of week
    DateTime date = DateTime.parse(lstShiftReport[0].workingDate!);
    int dayOfWeek = date.weekday;
    print('dateOfWeek $dayOfWeek');

    // setting inital shift
    int indChooseShift =
        lstShift.indexWhere((element) => element.shiftCode == shiftCode);

    emit(CustomerInitSuccess(results, lstCustomerTarget, daysOfWeek,
        lstShiftName, [dayOfWeek - 1], [indChooseShift]));
  }

  Future<void> reload() async {
    print('reload page');
    emit(StartReload());
    prefs = await SharedPreferences.getInstance();
    // get info shift from global var
    int? shiftReportId = prefs.getInt(Session.shiftReportId.toString());
    String? shiftCode = prefs.getString(Session.shiftCode.toString());
    print('Shift report id $shiftReportId');
    //get shift report inffo
    List<ShiftReport> lstShiftReport =
        await shiftReportProvider.select(shiftReportId ?? 0);

    List<ShiftVisitDto> lstShiftVisit =
        await customerVisitProvider.getPlanCustomerVisit(shiftReportId, null);

    List<ShiftVisitDto> lstCustomerTarget =
        visitService.mergeShiftVisit(lstShiftVisit);

    //await customerAddressProvider.getAllCustomerAddress();
    // print('listCustomerVisit $listCustomerVisit');
    int index = 0;
    List<List<String>> results = lstCustomerTarget.map((data) {
      index++;
      List<String> result = [];
      result.add(index.toString());
      result.add(data.customerCode.toString());
      result.add(data.customerName.toString());
      result.add(data.shiftName.toString());
      result.add(CommonUtils.convertDate(
          data.visitDate, Constant.dateFormatterYYYYMMDD));
      result.add(CommonUtils.convertDate(
          data.startTime, Constant.dateFormatterYYYYMMDDHHMM));
      result.add(CommonUtils.convertDate(
          data.endTime, Constant.dateFormatterYYYYMMDDHHMM));
      result.add(data.visitTimes.toString());
      result.add(colorRow(data.visitStatus ?? ''));
      return result;
    }).toList();
    final List<String> daysOfWeek = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
    List<Shift> lstShift = await shiftProvider.getShift();
    var lstShiftName = lstShift.map((e) => e.shiftName ?? "").toList();

    // setting initial day of week
    DateTime date = DateTime.parse(lstShiftReport[0].workingDate!);
    int dayOfWeek = date.weekday;
    print('dateOfWeek $dayOfWeek');

    // setting inital shift
    int indChooseShift =
        lstShift.indexWhere((element) => element.shiftCode == shiftCode);

    emit(ReloadSuccess(results, lstCustomerTarget, daysOfWeek, lstShiftName,
        [dayOfWeek - 1], [indChooseShift]));
  }

  Future<void> searchPlanRouteAssignment(
      String customerName, List<int> lstIndDay, List<int> lstIndShift) async {
    emit(StartSearchRouteAssign());
    prefs = await SharedPreferences.getInstance();
    // get info shift from global var
    int? shiftReportId = prefs.getInt(Session.shiftReportId.toString());
    print('Shift report id $shiftReportId');

    lstIndDay = lstIndDay.map((e) => (e + 2) % 7).toList();
    List<Shift> lstShift = await shiftProvider.getShift();
    List<String> lstShiftCode = [];
    for (var indShift in lstIndShift) {
      if (indShift != -1) {
        lstShiftCode.add(lstShift[indShift].shiftCode ?? '');
      }
    }
    List<ShiftVisitDto> lstShiftVisit =
        await customerVisitProvider.getPlanCustomerVisitSearch(
            shiftReportId ?? 0, customerName, lstIndDay, lstShiftCode);

    List<ShiftVisitDto> lstCustomerTarget =
        visitService.mergeShiftVisit(lstShiftVisit);

    //await customerAddressProvider.getAllCustomerAddress();
    // print('listCustomerVisit $listCustomerVisit');
    int index = 0;
    List<List<String>> results = lstCustomerTarget.map((data) {
      index++;
      List<String> result = [];
      result.add(index.toString());
      result.add(data.customerCode.toString());
      result.add(data.customerName.toString());
      result.add(data.shiftName.toString());
      result.add(CommonUtils.convertDate(
          data.visitDate, Constant.dateFormatterYYYYMMDD));
      result.add(CommonUtils.convertDate(
          data.startTime, Constant.dateFormatterYYYYMMDDHHMM));
      result.add(CommonUtils.convertDate(
          data.endTime, Constant.dateFormatterYYYYMMDDHHMM));
      result.add(data.visitTimes.toString());
      result.add(colorRow(data.visitStatus ?? ''));
      return result;
    }).toList();

    emit(SearchRouteAssignSuccess(results, lstCustomerTarget));
  }

  String colorRow(String visitStatus) {
    String colorCode = 'FFFFFFFF';
    switch (visitStatus) {
      case Constant.notYetVisit:
        colorCode = 'FFFFFFFF';
        break;
      case Constant.visiting:
        colorCode = 'FFF8FBA8';
        break;
      case Constant.visited:
        colorCode = 'FFABFBB0';
        break;
      case Constant.canceledVisit:
        colorCode = 'FFFFB7B7';
        break;
      default:
        colorCode = 'FFFFFFFF';
        break;
    }
    return colorCode;
  }
}
