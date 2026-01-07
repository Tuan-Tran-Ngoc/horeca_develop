import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
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
    int? baPositionId = prefs.getInt(Session.baPositionId.toString());
    List<ShiftReport> lstCurrentReport =
        await shiftReportProvider.getCurrentReport(baPositionId);
    if (lstCurrentReport.isNotEmpty) {
      isStartShift = true;

      //setting shift info into global variable
      ShiftReport currentReport = lstCurrentReport[0];
      prefs.setInt(
          Session.shiftReportId.toString(), currentReport.shiftReportId ?? 0);
      prefs.setString(
          Session.shiftCode.toString(), currentReport.shiftCode ?? '');
      prefs.setString(
          Session.workingDate.toString(), currentReport.workingDate ?? '');
    } else {
      isStartShift = false;
    }
    emit(CheckStartShiftState(isStartShift));
    return isStartShift;
  }

  Future<void> logout() async {
    await CommonUtils.logout();

    AppLocalizations multiLang = AppLocalizations.of(context)!;
    String message = [multiLang.logout, multiLang.success].join(" ");
    emit(LogoutSuccessful(message));
  }
}
