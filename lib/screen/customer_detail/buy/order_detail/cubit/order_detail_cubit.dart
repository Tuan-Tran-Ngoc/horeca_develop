import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/discount_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/order_header_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_dto.dart';
import 'package:meta/meta.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit() : super(OrderDetailInitial());
  OrderProvider orderProvider = OrderProvider();
  OrderDetailProvider orderDetailProvider = OrderDetailProvider();
  PromotionProvider promotionProvider = PromotionProvider();
  DiscountProvider discountProvider = DiscountProvider();
  SapOrderDtlProvider sapOrderDtlProvider = SapOrderDtlProvider();
  SapOrderDeliveryProvider sapOrderDeliveryProvider =
      SapOrderDeliveryProvider();

  Future<void> init(int orderId) async {
    //intial result
    OrderHeaderDto orderHeader = OrderHeaderDto();
    List<SapOrderDtl> lstOrderDtl = [];
    List<SchemeDto> lstPromotionOrder = [];
    List<DiscountResultOrderDto> lstDiscountOrder = [];
    List<SapOrderDelivery> lstSapOrderDelivery = [];

    // is order sap
    int? sapOrderId = await orderProvider.countOrderSap(orderId);
    if (sapOrderId != null && sapOrderId > 0) {
      List<OrderHeaderDto> lstOrderHeader =
          await orderProvider.selectSapOrderHeader(orderId);
      orderHeader = lstOrderHeader[0];

      //List<SapOrderDtl>
      List<SapOrderDtl> lstSapOrderDtl =
          await sapOrderDtlProvider.selectSapOrderDtl(sapOrderId);

      for (var sapOrderDtl in lstSapOrderDtl) {
        if (sapOrderDtl.itemCategory == 'Hàng bán') {
          lstOrderDtl.add(sapOrderDtl);
        } else if (sapOrderDtl.itemCategory == 'Hàng khuyến mãi (NÐ)') {
          SchemeDto promotion = SchemeDto(
            productName: sapOrderDtl.productName,
            resultQty: sapOrderDtl.qty,
            schemeContent: '',
          );
          lstPromotionOrder.add(promotion);
        }
      }

      lstSapOrderDelivery =
          await sapOrderDeliveryProvider.selectSapOrderDelivery(sapOrderId);
    } else {
      // get order header
      List<OrderHeaderDto> lstOrderHeader =
          await orderProvider.selectOrderHeader(orderId);

      orderHeader = lstOrderHeader[0];

      // get order detail
      List<ProductDto> lstOrderDtlHrc =
          await orderDetailProvider.selectOrderDtl(orderId);

      lstOrderDtl = lstOrderDtlHrc.map((e) {
        return SapOrderDtl(
            productName: e.productName,
            qty: e.quantity,
            shippedQty: 0,
            unit: e.uomName,
            unitPrice: e.salesPrice,
            unitPriceAfterDiscount: e.priceCostDiscount,
            netValue: e.totalAmount);
      }).toList();

      // get promotion
      lstPromotionOrder =
          await promotionProvider.selectPromotioneByOrder(orderId);

      // get discount
      lstDiscountOrder = await discountProvider.selectDiscountByOrder(orderId);
    }

    //get summary order
    emit(LoadingInit(orderHeader, lstOrderDtl, lstPromotionOrder,
        lstDiscountOrder, lstSapOrderDelivery));
  }
}
