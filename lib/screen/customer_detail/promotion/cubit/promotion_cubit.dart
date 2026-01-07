import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca/service/promotion_service.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/discount_content_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';
import 'package:intl/intl.dart';

part 'promotion_state.dart';

class PromotionCubit extends Cubit<PromotionState> {
  PromotionCubit() : super(SaleInitial());
  PromotionProvider promotionProvider = PromotionProvider();
  DiscountProvider discountProvider = DiscountProvider();
  PromotionService promotionService = PromotionService();

  Future<void> init(int customerId) async {
    List<PromotionDto> lstPromotion =
        await promotionService.getSchemeContentPromotion(customerId);

    // select info discount
    List<DiscountDto> lstDiscount =
        await discountProvider.selectDiscountByCustomerId(customerId);

    for (var discount in lstDiscount) {
      List<DiscountContentDto> lstDiscountContent =
          await discountProvider.selectDiscountContent(discount.discountId!);

      List<SchemeDto> lstSchemeOrder = [];
      for (DiscountContentDto discountContent in lstDiscountContent) {
        int indexSchemeExist = checkSchemeDiscountIsExist(
            discountContent.discountSchemeId!, lstSchemeOrder);
        List<String> params = [];
        if (indexSchemeExist == -1) {
          SchemeDto schemeOrder = SchemeDto();
          List<String> params = [];
          if (discountContent.conditionProductId != null) {
            if (discountContent.totalType == '00') {}
            params = [
              'Mua',
              NumberFormat.decimalPattern()
                  .format(discountContent.conditionQty),
              discountContent.conditionProductName!,
              'Nhận'
            ];
            if (discountContent.discountType == '00') {
              // result discount is percent
              params.add(
                  CommonUtils.formatQtyPercent(discountContent.resultQty ?? 0));
            } else {
              // result discount is money
              params
                  .add(CommonUtils.displayCurrency(discountContent.resultQty));
            }
          } else {
            if (discountContent.conditionType == '00') {
              // discount SKU
              if (discountContent.totalType == '00') {
                params = [
                  'Đơn hàng đạt',
                  CommonUtils.displayCurrency(discountContent.conditionQty),
                  'Nhận'
                ];
                if (discountContent.discountType == '00') {
                  // result discount is percent
                  params.add(CommonUtils.formatQtyPercent(
                      discountContent.resultQty ?? 0));
                } else {
                  // result discount is money
                  params.add(
                      CommonUtils.displayCurrency(discountContent.resultQty));
                }
              } else if (discountContent.totalType == '01') {
                params = [
                  'Đơn hàng đạt',
                  NumberFormat.decimalPattern()
                      .format(discountContent.conditionQty),
                  'sản phẩm',
                  'Nhận'
                ];
                if (discountContent.discountType == '00') {
                  // result discount is percent
                  params.add(CommonUtils.formatQtyPercent(
                      discountContent.resultQty ?? 0));
                } else {
                  // result discount is money
                  params.add(
                      CommonUtils.displayCurrency(discountContent.resultQty));
                }
              }
            } else {
              // discount order
              if (discountContent.totalType == '00') {
                params = [
                  'Đơn hàng đạt',
                  NumberFormat.decimalPattern()
                      .format(discountContent.conditionQty),
                  'sản phẩm',
                  'Nhận'
                ];
                if (discountContent.discountType == '00') {
                  // result discount is percent
                  params.add(CommonUtils.formatQtyPercent(
                      discountContent.resultQty ?? 0));
                } else {
                  // result discount is money
                  params.add(
                      CommonUtils.displayCurrency(discountContent.resultQty));
                }
              } else if (discountContent.totalType == '01') {
                params = [
                  'Đơn hàng đạt',
                  CommonUtils.displayCurrency(discountContent.conditionQty),
                  'Nhận'
                ];
                if (discountContent.discountType == '00') {
                  // result discount is percent
                  params.add(CommonUtils.formatQtyPercent(
                      discountContent.resultQty ?? 0));
                } else {
                  // result discount is money
                  params.add(
                      CommonUtils.displayCurrency(discountContent.resultQty));
                }
              }
            }
          }
          schemeOrder.schemeContent = params.join(' ');
          schemeOrder.schemeId = discountContent.discountSchemeId;
          lstSchemeOrder.add(schemeOrder);
        } else {
          // condition 2 of condition discount order
          if (discountContent.conditionType == '00') {
            SchemeDto schemeExist = lstSchemeOrder[indexSchemeExist];
            List<String> params = [];
            List<String> conditionStr = [];
            String conditionOld = getSubStringBetween(
                schemeExist.schemeContent!, 'Đơn hàng đạt', 'Nhận');

            if (discountContent.totalType == '01') {
              conditionStr = [
                conditionOld,
                [
                  NumberFormat.decimalPattern()
                      .format(discountContent.conditionQty),
                  'sản phẩm'
                ].join(' ')
              ];
            } else {
              conditionStr = [
                conditionOld,
                [CommonUtils.displayCurrency(discountContent.conditionQty)]
                    .join(' ')
              ];
            }

            if (discountContent.discountType == '00') {
              params = [
                'Đơn hàng đạt',
                conditionStr.join(', '),
                'Nhận',
                CommonUtils.formatQtyPercent(discountContent.resultQty ?? 0),
              ];
            } else {
              params = [
                'Đơn hàng đạt',
                conditionStr.join(', '),
                'Nhận',
                CommonUtils.displayCurrency(discountContent.resultQty),
              ];
            }
            lstSchemeOrder[indexSchemeExist].schemeContent = params.join(' ');
          }
        }
      }

      discount.lstShemeOrder = lstSchemeOrder;
    }

    emit(LoadingInit(lstPromotion, lstDiscount));
  }

  void changeTab(index) {
    emit(LoadingItem());
    emit(ChangeTabSuccess(index));
  }

  int checkSchemePromotionIsExist(
      int schemeId, List<SchemePromotionDto> lstSchemeOrder) {
    return lstSchemeOrder.indexWhere((scheme) => scheme.schemeId == schemeId);
  }

  int checkSchemeDiscountIsExist(int schemeId, List<SchemeDto> lstSchemeOrder) {
    return lstSchemeOrder.indexWhere((scheme) => scheme.schemeId == schemeId);
  }

  String getSubStringBetween(String input, String start, String end) {
    final startIndex = input.indexOf(start);
    final endIndex = input.indexOf(end);
    if (startIndex == -1 || endIndex == -1) {
      return '';
    } else {
      return input.substring(startIndex + start.length, endIndex).trim();
    }
  }
}
