part of 'create_buy_order_cubit.dart';

sealed class CreateBuyOrderState extends Equatable {
  const CreateBuyOrderState();

  @override
  List<Object> get props => [];
}

final class CreateBuyOrderInitial extends CreateBuyOrderState {}

final class LoadingInit extends CreateBuyOrderState {
  OrderHeaderDto orderHeader;
  List<ProductDto> lstProduct;
  LoadingInit(this.orderHeader, this.lstProduct);
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

final class ClickButtonSave extends CreateBuyOrderState {}

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

final class EventCalculatePromotion extends CreateBuyOrderState {}

final class EventCalculatePromotionSuccess extends CreateBuyOrderState {
  List<PromotionDto> lstPromotion;
  EventCalculatePromotionSuccess(this.lstPromotion);
}
