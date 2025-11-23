import 'package:equatable/equatable.dart';
import 'package:horeca_service/sqflite_database/model/m_shift.dart';

sealed class ShiftPopupState extends Equatable {
  const ShiftPopupState();

  @override
  List<Object> get props => [];
}

final class ShiftPopupInitial extends ShiftPopupState {}

final class LoadingInit extends ShiftPopupState {}

final class ChooseShiftSuccess extends ShiftPopupState {}

final class ShiftPopupInitialSuccess extends ShiftPopupState {
  List<Shift> lstShift;
  ShiftPopupInitialSuccess(this.lstShift);
}

final class ShiftPopupInitialSuccessSelect extends ShiftPopupState {
  List<Shift> lstShift;
  ShiftPopupInitialSuccessSelect(this.lstShift);
}

final class StartShiftSuccess extends ShiftPopupState {
  int? shiftReportId;
  StartShiftSuccess(this.shiftReportId);
}

final class StartShiftFail extends ShiftPopupState {
  dynamic error;
  StartShiftFail(this.error);
}
