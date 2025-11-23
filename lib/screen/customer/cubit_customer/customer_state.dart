part of 'customer_cubit.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

final class LoadingItem extends CustomerState {}

final class LoadingInit extends CustomerState {}

final class CustomerInitial extends CustomerState {}

final class StartSearchRouteAssign extends CustomerState {}

final class CustomerInitSuccess extends CustomerState {
  List<List<String>> rowDataShiftVisit;
  List<ShiftVisitDto> listShiftVisit;
  List<String> daysOfWeek;
  List<String> lstShiftName;
  List<int> lstChooseDay;
  List<int> lstChooseShift;
  CustomerInitSuccess(
      this.rowDataShiftVisit,
      this.listShiftVisit,
      this.daysOfWeek,
      this.lstShiftName,
      this.lstChooseDay,
      this.lstChooseShift);
}

final class StartReload extends CustomerState {}

final class ReloadSuccess extends CustomerState {
  List<List<String>> rowDataShiftVisit;
  List<ShiftVisitDto> listShiftVisit;
  List<String> daysOfWeek;
  List<String> lstShiftName;
  List<int> lstChooseDay;
  List<int> lstChooseShift;
  ReloadSuccess(this.rowDataShiftVisit, this.listShiftVisit, this.daysOfWeek,
      this.lstShiftName, this.lstChooseDay, this.lstChooseShift);
}

final class SearchRouteAssignSuccess extends CustomerState {
  List<List<String>> rowDataShiftVisit;
  List<ShiftVisitDto> listShiftVisit;
  SearchRouteAssignSuccess(this.rowDataShiftVisit, this.listShiftVisit);
}
