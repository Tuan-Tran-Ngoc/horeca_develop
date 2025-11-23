part of 'promotion_popup_cubit.dart';

sealed class PromotionPopupState extends Equatable {
  const PromotionPopupState();

  @override
  List<Object> get props => [];
}

final class PromotionPopupInitial extends PromotionPopupState {}

final class LoadingInitialPromotion extends PromotionPopupState {
  List<PromotionDto> lstPromotion;
  LoadingInitialPromotion(this.lstPromotion);
}

final class StartEventChoosePromotion extends PromotionPopupState {}

final class EventChoosePromotionSucessful extends PromotionPopupState {
  List<PromotionDto> lstPromotion;
  EventChoosePromotionSucessful(this.lstPromotion);
}

final class EventApplyAllPromotion extends PromotionPopupState {}

final class EventApplyAllPromotionSuccess extends PromotionPopupState {
  List<PromotionDto> lstPromotion;
  EventApplyAllPromotionSuccess(this.lstPromotion);
}

final class ClickBtnSelectStart extends PromotionPopupState {}

final class ClickBtnSelectSuccess extends PromotionPopupState {
  String notify;
  ClickBtnSelectSuccess(this.notify);
}
