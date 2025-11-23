part of 'order_detail_cubit.dart';

sealed class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object> get props => [];
}

final class OrderDetailInitial extends OrderDetailState {}

final class LoadingInit extends OrderDetailState {
  OrderHeaderDto orderHeader;
  List<SapOrderDtl> lstProduct;
  List<SchemeDto> lstPromotionOrder;
  List<DiscountResultOrderDto> lstDiscountOrder;
  List<SapOrderDelivery> lstSapOrderDelivery;
  LoadingInit(this.orderHeader, this.lstProduct, this.lstPromotionOrder,
      this.lstDiscountOrder, this.lstSapOrderDelivery);
}
