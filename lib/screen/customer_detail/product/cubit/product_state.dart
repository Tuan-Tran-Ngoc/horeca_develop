part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class LoadingInit extends ProductState {}

final class LoadingItem extends ProductState {}

final class ProductInitial extends ProductState {}

final class ProductInitialSuccess extends ProductState {
  String selectedAddval;
  List<List<String>> rowDataDTC;
  List<ProductDto> listCustomerStock;
  List<ProductStock> listStockBalance;
  List<AddressVisitDto> lstAddress;
  bool isStartVisit;
  int? customerVisitId;
  ProductInitialSuccess(
      this.selectedAddval,
      this.lstAddress,
      this.listCustomerStock,
      this.listStockBalance,
      this.rowDataDTC,
      this.isStartVisit,
      this.customerVisitId);
}

final class ClickTabSuccess extends ProductState {
  bool isDTC;
  ClickTabSuccess(this.isDTC);
}

final class StartVisitSuccess extends ProductState {
  bool isStartVisit;
  int? customerVisitId;
  int customerAddressId;
  StartVisitSuccess(
      this.isStartVisit, this.customerVisitId, this.customerAddressId);
}

final class StartVisitFail extends ProductState {
  String error;
  StartVisitFail(this.error);
}

final class ModifyProductSucess extends ProductState {
  ModifyProductSucess();
}

final class SaveCustomerPriceSuccess extends ProductState {
  String msg;
  SaveCustomerPriceSuccess(this.msg);
}

final class ClickRevisitSuccess extends ProductState {}

final class RevisitSuccess extends ProductState {
  int customerVisitId;
  int customerAddressId;
  String msg;
  RevisitSuccess(this.customerVisitId, this.customerAddressId, this.msg);
}

final class RevisitFail extends ProductState {
  String error;
  RevisitFail(this.error);
}

final class SaveCustomerPriceFail extends ProductState {
  String error;
  SaveCustomerPriceFail(this.error);
}

final class EventChangeAddress extends ProductState {}

final class ChangeAddressSuccess extends ProductState {
  CustomerVisit customerVisit;
  List<ProductDto> listCustomerStock;
  int customerAddressId;
  ChangeAddressSuccess(
      this.customerVisit, this.listCustomerStock, this.customerAddressId);
}

class ReloadControl extends ProductState {}
