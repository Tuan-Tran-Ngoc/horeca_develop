import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca/service/order_service.dart';
import 'package:horeca/service/promotion_service.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/discount_content_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_content_dto.dart';
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
    // select info promotion
    // List<PromotionDto> lstPromotion =
    //     await promotionProvider.selectPromotionByCustomerId(customerId, null);

    // for (var promotion in lstPromotion) {
    //   List<PromotionContentDto> lstPromotionContent = await promotionProvider
    //       .selectPromotionContent(promotion.promotionId!);

    //   List<SchemePromotionDto> lstSchemeOrder = [];
    //   for (PromotionContentDto promotionContent in lstPromotionContent) {
    //     int indexSchemeExist = checkSchemePromotionIsExist(
    //         promotionContent.promotionSchemeId!, lstSchemeOrder);
    //     // first condition
    //     if (indexSchemeExist == -1) {
    //       SchemePromotionDto schemeOrder = SchemePromotionDto();
    //       List<String> params = [];

    //       // difference promotion total order
    //       if (promotionContent.conditionProductId != null) {
    //         params = [
    //           'Mua',
    //           NumberFormat.decimalPattern()
    //               .format(promotionContent.conditionQty),
    //           promotionContent.conditionProductName!,
    //           'Nhận',
    //           NumberFormat.decimalPattern().format(promotionContent.resultQty),
    //           promotionContent.resultProductName!,
    //         ];
    //       } else {
    //         if (promotionContent.totalType == '00') {
    //           params = [
    //             'Đơn hàng đạt',
    //             NumberFormat.currency(locale: 'vi')
    //                 .format(promotionContent.conditionQty),
    //             'Nhận',
    //             NumberFormat.decimalPattern()
    //                 .format(promotionContent.resultQty),
    //             promotionContent.resultProductName!,
    //           ];
    //         } else if (promotionContent.totalType == '01') {
    //           params = [
    //             'Đơn hàng đạt',
    //             NumberFormat.decimalPattern()
    //                 .format(promotionContent.conditionQty),
    //             'sản phẩm',
    //             'Nhận',
    //             NumberFormat.decimalPattern()
    //                 .format(promotionContent.resultQty),
    //             promotionContent.resultProductName!,
    //           ];
    //         }
    //       }

    //       schemeOrder.schemeContent = params.join(' ');
    //       schemeOrder.schemeId = promotionContent.promotionSchemeId;
    //       lstSchemeOrder.add(schemeOrder);
    //     } else {
    //       // promotion has multi condition
    //       SchemePromotionDto schemeExist = lstSchemeOrder[indexSchemeExist];
    //       List<String> params = [];
    //       List<String> conditionStr = [];

    //       if (promotionContent.conditionProductId != null) {
    //         String conditionOld =
    //             getSubStringBetween(schemeExist.schemeContent!, 'Mua', 'Nhận');

    //         conditionStr = [
    //           conditionOld,
    //           [
    //             NumberFormat.decimalPattern()
    //                 .format(promotionContent.conditionQty),
    //             promotionContent.conditionProductName!
    //           ].join(' ')
    //         ];

    //         params = [
    //           'Mua',
    //           conditionStr.join(', '),
    //           'Nhận',
    //           NumberFormat.decimalPattern().format(promotionContent.resultQty),
    //           promotionContent.resultProductName!,
    //         ];
    //       } else {
    //         String conditionOld = getSubStringBetween(
    //             schemeExist.schemeContent!, 'Đơn hàng đạt', 'Nhận');

    //         if (promotionContent.totalType == '00') {
    //           conditionStr = [
    //             conditionOld,
    //             NumberFormat.currency(locale: 'vi')
    //                 .format(promotionContent.conditionQty)
    //           ];
    //         } else if (promotionContent.totalType == '01') {
    //           conditionStr = [
    //             conditionOld,
    //             [
    //               NumberFormat.decimalPattern()
    //                   .format(promotionContent.conditionQty),
    //               'sản phẩm'
    //             ].join(' ')
    //           ];
    //         }

    //         params = [
    //           'Đơn hàng đạt',
    //           conditionStr.join(', '),
    //           'Nhận',
    //           NumberFormat.decimalPattern().format(promotionContent.resultQty),
    //           promotionContent.resultProductName!,
    //         ];
    //       }

    //       lstSchemeOrder[indexSchemeExist].schemeContent = params.join(' ');
    //     }
    //   }

    //   promotion.lstSchemeOrder = lstSchemeOrder;
    // }

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
                  params.add(discountContent.resultQty.toString() + '%');
            } else {
              // result discount is money
              params.add(NumberFormat.currency(locale: 'vi')
                  .format(discountContent.resultQty));
            }
          } else {
            if (discountContent.conditionType == '00') {
              // discount SKU
              if (discountContent.totalType == '00') {
                params = [
                  'Đơn hàng đạt',
                  NumberFormat.currency(locale: 'vi')
                      .format(discountContent.conditionQty),
                  'Nhận'
                ];
                if (discountContent.discountType == '00') {
                  // result discount is percent
                  params.add(discountContent.resultQty.toString() + '%');
                } else {
                  // result discount is money
                  params.add(NumberFormat.currency()
                      .format(discountContent.resultQty));
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
                  params.add(discountContent.resultQty.toString() + '%');
                } else {
                  // result discount is money
                  params.add(NumberFormat.currency()
                      .format(discountContent.resultQty));
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
                  params.add(discountContent.resultQty.toString() + '%');
                } else {
                  // result discount is money
                  params.add(NumberFormat.currency()
                      .format(discountContent.resultQty));
                }
              } else if (discountContent.totalType == '01') {
                params = [
                  'Đơn hàng đạt',
                  NumberFormat.currency(locale: 'vi')
                      .format(discountContent.conditionQty),
                  'Nhận'
                ];
                if (discountContent.discountType == '00') {
                  // result discount is percent
                  params.add(discountContent.resultQty.toString() + '%');
                } else {
                  // result discount is money
                  params.add(NumberFormat.currency()
                      .format(discountContent.resultQty));
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
                [
                  NumberFormat.currency(locale: 'vi')
                      .format(discountContent.conditionQty)
                ].join(' ')
              ];
            }

            if (discountContent.discountType == '00') {
              params = [
                'Đơn hàng đạt',
                conditionStr.join(', '),
                'Nhận',
                NumberFormat.percentPattern()
                    .format((discountContent.resultQty ?? 0) / 100),
              ];
            } else {
              params = [
                'Đơn hàng đạt',
                conditionStr.join(', '),
                'Nhận',
                NumberFormat.currency().format(discountContent.resultQty),
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
