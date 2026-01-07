part of 'shift_cubit.dart';

sealed class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object> get props => [];
}

final class ShiftInitial extends ShiftState {}

final class LoadingItem extends ShiftState {}

final class LoadingInit extends ShiftState {}

final class ShiftInitSuccess extends ShiftState {
  List<List<String>> rowDataOrders;
  List<ListOrderInShift> listOrderInShift;
  List<List<String>> rowDataProducts;
  List<ListProductsInShift> listProductsInShift;
  ShiftReport shiftReport;
  ShiftReportHeaderDTO shiftReportHeader;
  ShiftInitSuccess(
      this.rowDataOrders,
      this.listOrderInShift,
      this.rowDataProducts,
      this.listProductsInShift,
      this.shiftReport,
      this.shiftReportHeader);
}

final class EndShiftSucces extends ShiftState {
  String msg;
  EndShiftSucces(this.msg);
}

final class EndShiftFailed extends ShiftState {
  dynamic error;
  EndShiftFailed(this.error);
}

class ReloadControl extends ShiftState {}
