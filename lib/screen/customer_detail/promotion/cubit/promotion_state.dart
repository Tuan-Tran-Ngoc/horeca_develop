part of 'promotion_cubit.dart';

sealed class PromotionState extends Equatable {
  const PromotionState();

  @override
  List<Object> get props => [];
}

final class SaleInitial extends PromotionState {}

final class LoadingItem extends PromotionState {}

final class LoadingInit extends PromotionState {
  List<PromotionDto> lstPromotion;
  List<DiscountDto> lstDiscount;
  LoadingInit(this.lstPromotion, this.lstDiscount);
}

final class ProductInitial extends PromotionState {}

final class SaleInitialSuccess extends PromotionState {}

final class ChangeTabSuccess extends PromotionState {
  int index;
  ChangeTabSuccess(this.index);
}
