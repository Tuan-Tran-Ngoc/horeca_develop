import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BuildContext context;
  HomeCubit(this.context) : super(HomeInitial());
  late SharedPreferences prefs;
  ShiftReportProvider shiftReportProvider = ShiftReportProvider();
  bool isStartShift = false;

  void initHomeScreen() async {
    emit(HomeInitialSuccessful());
    await checkStartShift();
  }

  Future<bool> checkStartShift() async {
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    List<ShiftReport> lstCurrentReport =
        await shiftReportProvider.getCurrentReport(baPositionId);
    if (lstCurrentReport.isNotEmpty) {
      isStartShift = true;

      //setting shift info into global variable
      ShiftReport currentReport = lstCurrentReport[0];
      prefs.setInt('shiftReportId', currentReport.shiftReportId ?? 0);
      prefs.setString('shiftCode', currentReport.shiftCode ?? '');
      prefs.setString('workingDate', currentReport.workingDate ?? '');
    } else {
      isStartShift = false;
    }
    emit(CheckStartShiftState(isStartShift));
    return isStartShift;
  }

  Future<void> logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? refresh_token;
    // if (prefs.get('refresh_token') != null) {
    //   refresh_token = prefs.get('refresh_token').toString();
    // }
    // await prefs.clear();
    // if (refresh_token != null) prefs.setString('refresh_token', refresh_token);
    await CommonUtils.logout();

    AppLocalizations multiLang = AppLocalizations.of(context)!;
    String message = [multiLang.logout, multiLang.success].join(" ");
    emit(LogoutSuccessful(message));
  }
}
