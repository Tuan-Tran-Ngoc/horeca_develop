part of 'create_buy_order_cubit.dart';

sealed class CreateBuyOrderState extends Equatable {
  const CreateBuyOrderState();

  @override
  List<Object> get props => [];
}

final class CreateBuyOrderInitial extends CreateBuyOrderState {}

final class LoadingInitSuccess extends CreateBuyOrderState {
  OrderHeaderDto orderHeader;
  List<ProductDto> lstProduct;
  LoadingInitSuccess(this.orderHeader, this.lstProduct);
}

final class LoadingInitFail extends CreateBuyOrderState {
  String errorMsg;
  LoadingInitFail(this.errorMsg);
}

final class CreateOrderSuccess extends CreateBuyOrderState {
  bool isCreated;
  String msg;
  CreateOrderSuccess(this.isCreated, this.msg);
}

final class UpdatePromotionSuccess extends CreateBuyOrderState {
  List<SchemePromotionDto> lstScheme;
  UpdatePromotionSuccess(this.lstScheme);
}

final class OpenPromotionPopup extends CreateBuyOrderState {}

final class CreateOrderFail extends CreateBuyOrderState {
  String error;
  CreateOrderFail(this.error);
}

final class ReloadControl extends CreateBuyOrderState {}

final class StartApplyDiscounPromotion extends CreateBuyOrderState {}

final class ValidateFailShowPopup extends CreateBuyOrderState {
  String message;
  ValidateFailShowPopup(this.message);
}

final class ApplyDiscountAndPromotionSuccess extends CreateBuyOrderState {
  List<ProductDto> lstProduct;
  List<DiscountResultOrderDto> lstDiscount;
  List<PromotionResultOrderDto> lstPromotion;
  ApplyDiscountAndPromotionSuccess(
      this.lstProduct, this.lstDiscount, this.lstPromotion);
}

final class EventCalculatePromotionSuccess extends CreateBuyOrderState {
  List<PromotionDto> lstPromotion;
  String notify;
  EventCalculatePromotionSuccess(this.lstPromotion, this.notify);
}
