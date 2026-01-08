import 'package:equatable/equatable.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/order_check_out_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_checkout_dto.dart';

sealed class SummaryState extends Equatable {
  const SummaryState();

  @override
  List<Object> get props => [];
}

final class SummaryInitial extends SummaryState {}

final class LoadingInit extends SummaryState {
  CustomerVisit? customerVisit;
  List<ProductCheckoutDto> lstProduct;
  List<OrderCheckOutDTO> lstOrder;
  CustomerLiabilities? customerLiabilities;
  LoadingInit(this.customerVisit, this.lstProduct, this.lstOrder,
      this.customerLiabilities);
}

final class CheckoutSuccess extends SummaryState {
  String msg;
  CheckoutSuccess(this.msg);
}

final class CheckoutFailed extends SummaryState {
  String error;
  CheckoutFailed(this.error);
}

class ReloadControl extends SummaryState {}

final class ClickCheckOutState extends SummaryState {}

