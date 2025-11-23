part of 'customer_detail_cubit.dart';

sealed class CustomerDetailState extends Equatable {
  const CustomerDetailState();

  @override
  List<Object> get props => [];
}

final class CustomerDetailInitial extends CustomerDetailState {}

final class CustomerDetailInitSuccess extends CustomerDetailState {
  int customerVisitId;
  String? customerName;
  String statusVisit;
  CustomerDetailInitSuccess(
      this.customerVisitId, this.customerName, this.statusVisit);
}

final class LoadingInit extends CustomerDetailState {}

final class LoadingItem extends CustomerDetailState {}

final class ClickMenuSuccess extends CustomerDetailState {
  final int index;
  const ClickMenuSuccess(this.index);
}
