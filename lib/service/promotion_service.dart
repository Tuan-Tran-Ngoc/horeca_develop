import 'package:horeca/service/order_service.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_display_condition_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_display_result_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_display_dto.dart';
import 'package:intl/intl.dart';

class PromotionService {
  PromotionProvider promotionProvider = PromotionProvider();
  PromotionSchemeProvider promotionSchemeProvider = PromotionSchemeProvider();
  PromotionConditionProvider promotionConditionProvider =
      PromotionConditionProvider();
  PromotionResultProvider promotionResultProvider = PromotionResultProvider();
  OrderService orderService = OrderService();

  Future<List<PromotionDto>> getSchemeContentPromotion(int customerId) async {
    // select info promotion
    List<PromotionDto> lstPromotion =
        await promotionProvider.selectPromotionByCustomerId(customerId, null);

    for (var promotion in lstPromotion) {
      List<PromotionDisplayDto> lstPromotionScheme =
          await selectPromotionInfo(promotion.promotionId ?? 0);

      List<SchemePromotionDto> lstScheme = [];
      if (promotion.conditionType == '00') {
        //promotion type order
        for (PromotionDisplayDto promotionScheme in lstPromotionScheme) {
          List<String> params = ['Đơn hàng đạt'];
          List<String> paramsCondition = [];
          List<String> paramsResult = [];
          for (PromotionDisplayConditionDto promotionCondition
              in promotionScheme.lstPromotionCondition ?? []) {
            if (promotionCondition.totalType == '00') {
              paramsCondition.add(NumberFormat.currency(locale: 'vi')
                  .format(promotionCondition.conditionQty));
            } else {
              paramsCondition.add([
                NumberFormat.decimalPattern()
                    .format(promotionCondition.conditionQty),
                'sản phẩm'
              ].join(' '));
            }
          }
          params.add(paramsCondition.join(' ,'));
          params.add('\nNhận');
          for (PromotionDisplayResultDto promotionResult
              in promotionScheme.lstPromotionResult ?? []) {
            paramsResult.add([
              NumberFormat.decimalPattern().format(promotionResult.resultQty),
              promotionResult.productName ?? ''
            ].join(' '));
          }
          params.add(paramsResult.join(' ,'));
          SchemePromotionDto scheme = SchemePromotionDto(
            programId: promotion.promotionId,
            schemeId: promotionScheme.promotionSchemeId,
            schemeContent: params.join(' '),
            lstProductApply: convertProductPromotionDto(
                promotionScheme.lstPromotionResult ?? []),
          );

          lstScheme.add(scheme);
        }
      } else if (promotion.conditionType == '01') {
        //promotion SKU detail
        for (PromotionDisplayDto promotionScheme in lstPromotionScheme) {
          List<String> params = [];
          List<String> paramsCondition = [];
          List<String> paramsResult = [];
          params = ['Mua'];
          for (PromotionDisplayConditionDto promotionCondition
              in promotionScheme.lstPromotionCondition ?? []) {
            paramsCondition.add([
              NumberFormat.decimalPattern()
                  .format(promotionCondition.conditionQty),
              promotionCondition.productName ?? ''
            ].join(' '));
          }
          params.add(paramsCondition.join(' ,'));
          params.add('\nNhận');
          for (PromotionDisplayResultDto promotionResult
              in promotionScheme.lstPromotionResult ?? []) {
            paramsResult.add([
              NumberFormat.decimalPattern().format(promotionResult.resultQty),
              promotionResult.productName ?? ''
            ].join(' '));
          }
          params.add(paramsResult.join(' ,'));

          SchemePromotionDto scheme = SchemePromotionDto(
            programId: promotion.promotionId,
            schemeId: promotionScheme.promotionSchemeId,
            schemeContent: params.join(' '),
          );

          lstScheme.add(scheme);
        }
      } else if (promotion.conditionType == '02') {
        //promotion SKU combo
        for (PromotionDisplayDto promotionScheme in lstPromotionScheme) {
          List<String> params = [];
          List<String> paramsCondition = [];
          List<String> paramsResult = [];
          params = ['Đơn hàng mua combo'];
          double conditionQty = 0;
          for (PromotionDisplayConditionDto promotionCondition
              in promotionScheme.lstPromotionCondition ?? []) {
            paramsCondition.add(promotionCondition.productName ?? '');
            conditionQty = promotionCondition.conditionQty ?? 0;
          }
          params.add(paramsCondition.join(' ,'));
          params.add('với tổng số lượng là');
          params.add(NumberFormat.decimalPattern().format(conditionQty));
          params.add('\nNhận');
          for (PromotionDisplayResultDto promotionResult
              in promotionScheme.lstPromotionResult ?? []) {
            paramsResult.add([
              NumberFormat.decimalPattern().format(promotionResult.resultQty),
              promotionResult.productName ?? ''
            ].join(' '));
          }

          params.add(paramsResult.join(' ,'));

          SchemePromotionDto scheme = SchemePromotionDto(
            programId: promotion.promotionId,
            schemeId: promotionScheme.promotionSchemeId,
            schemeContent: params.join(' '),
          );

          lstScheme.add(scheme);
        }
      }

      promotion.lstSchemeOrder = lstScheme;
    }
    return lstPromotion;
  }

  int checkSchemePromotionIsExist(
      int schemeId, List<SchemePromotionDto> lstSchemeOrder) {
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

  Future<List<PromotionDisplayDto>> selectPromotionInfo(int promotionId) async {
    List<PromotionDisplayDto> lstPromotionDisplay = [];

    //get schemeId
    List<PromotionScheme> lstSheme =
        await promotionSchemeProvider.selectByPromotionId(promotionId);

    for (PromotionScheme scheme in lstSheme) {
      //get product condition
      List<PromotionDisplayConditionDto> lstPromotionCondition =
          await promotionConditionProvider.selectPromotionDisplayCondition(
              promotionId, scheme.promotionSchemeId ?? 0);

      //get product result
      List<PromotionDisplayResultDto> lstPromotionResult =
          await promotionResultProvider.selectPromotionDisplayResult(
              promotionId, scheme.promotionSchemeId ?? 0);

      PromotionDisplayDto promotionDisplay = PromotionDisplayDto(
          promotionId: scheme.promotionId,
          promotionSchemeId: scheme.promotionSchemeId,
          lstPromotionCondition: lstPromotionCondition,
          lstPromotionResult: lstPromotionResult);
      lstPromotionDisplay.add(promotionDisplay);
    }

    return lstPromotionDisplay;
  }

  List<ProductPromotionDto> convertProductPromotionDto(
      List<PromotionDisplayResultDto> obj) {
    List<ProductPromotionDto> results = [];
    obj.forEach((element) {
      ProductPromotionDto result = ProductPromotionDto(
          productId: element.productId,
          productName: element.productName,
          totalQuatity: element.resultQty);
      results.add(result);
    });

    return results;
  }

  Future<List<PromotionDto>> checkPromotionSchemeAlow(int customerId,
      List<PromotionDto> lstPromotion, List<ProductDto> lstProduct) async {
    List<SchemePromotionDto> lstSelectingScheme = lstPromotion
        .map((promotion) =>
            promotion.lstSchemeOrder!.where((scheme) => scheme.isChoose!))
        .expand((schemes) => schemes)
        .toList();

    lstSelectingScheme.sort((a, b) => a.priority.compareTo(b.priority));

    // calculate promotion again
    List<ProductDto> lstProductTarget = [];
    for (var product in lstProduct) {
      lstProductTarget.add(ProductDto.copyWith(product));
    }
    for (SchemePromotionDto selectingScheme in lstSelectingScheme) {
      List<PromotionResultOrderDto> lstPromotionCanApply = await orderService
          .applyPromotionOrder(customerId, lstProductTarget, null);

      //setting promotion result actual
      for (PromotionResultOrderDto promotionCanApply in lstPromotionCanApply) {
        if (selectingScheme.programId == promotionCanApply.promotionId &&
            selectingScheme.schemeId == promotionCanApply.schemeId) {
          selectingScheme.lstProductApply = promotionCanApply.lstProductApply;
          selectingScheme.lstProductResult = promotionCanApply.lstProductResult;
        }
      }

      lstProductTarget =
          calculateProductRemainPromotion([selectingScheme], lstProductTarget);
    }

    List<PromotionResultOrderDto> lstPromotionCanApply = await orderService
        .applyPromotionOrder(customerId, lstProductTarget, null);

    //set allowed promotion
    for (var promotion in lstPromotion) {
      for (SchemePromotionDto scheme in (promotion.lstSchemeOrder ?? [])) {
        if (lstPromotionCanApply
                .any((element) => element.schemeId == scheme.schemeId) ||
            lstSelectingScheme
                .any((element) => element.schemeId == scheme.schemeId)) {
          scheme.isAllowed = true;
          print('scheme.promotionId ${scheme.programId} - ${scheme.isAllowed}');
        } else {
          scheme.isAllowed = false;
          print('scheme.promotionId ${scheme.programId} - ${scheme.isAllowed}');
        }
      }
    }

    return lstPromotion;
  }

  List<ProductDto> calculateProductRemainPromotion(
      List<SchemePromotionDto> lstSelectingScheme,
      List<ProductDto> lstProduct) {
    // total product(productId/quantity) apllying
    List<ProductPromotionDto> lstApplyingPromotionProduct = [];
    for (SchemePromotionDto scheme in lstSelectingScheme) {
      for (ProductPromotionDto productApply in (scheme.lstProductApply ?? [])) {
        if (!lstApplyingPromotionProduct
            .any((element) => element.productId == productApply.productId)) {
          lstApplyingPromotionProduct.add(productApply);
        } else {
          int index = lstApplyingPromotionProduct.indexWhere(
              (element) => element.productId == productApply.productId);

          ProductPromotionDto applyingPromotionProduct =
              lstApplyingPromotionProduct[index];

          applyingPromotionProduct.totalAmount =
              (applyingPromotionProduct.totalAmount ?? 0) +
                  (productApply.totalAmount ?? 0);

          applyingPromotionProduct.totalQuatity =
              (applyingPromotionProduct.totalQuatity ?? 0) +
                  (productApply.totalQuatity ?? 0);
          lstApplyingPromotionProduct[index] = applyingPromotionProduct;
        }
      }
    }

    // set lstProduct not yet apply promotion
    List<ProductDto> lstProductTarget = [];
    for (ProductDto product in lstProduct) {
      ProductDto productTarget = ProductDto.copyWith(product);
      int index = lstApplyingPromotionProduct
          .indexWhere((element) => element.productId == product.productId);

      if (index >= 0) {
        productTarget.quantity = (product.quantity ?? 0) -
            (lstApplyingPromotionProduct[index].totalQuatity ?? 0);

        productTarget.priceCostDiscount = (product.priceCostDiscount ?? 0) -
            (lstApplyingPromotionProduct[index].totalAmount ?? 0);

        if ((productTarget.quantity ?? 0) <= 0) {
          continue;
        }
      }

      lstProductTarget.add(productTarget);
    }

    return lstProductTarget;
  }

  Future<List<PromotionDto>> applyAllPromotion(int customerId,
      List<PromotionDto> lstPromotion, List<ProductDto> lstProduct) async {
    //set status scheme promotion for init
    lstPromotion.forEach((promotion) {
      promotion.lstSchemeOrder!.forEach((scheme) {
        scheme.isAllowed = true;
        scheme.isChoose = false;
        scheme.priority = 0;
      });
    });

    //calculate promotion
    int priority = 1;
    for (PromotionDto promotion in lstPromotion) {
      for (SchemePromotionDto scheme in (promotion.lstSchemeOrder ?? [])) {
        if ((scheme.isAllowed ?? true)) {
          scheme.isAllowed = true;
          scheme.isChoose = true;
          scheme.priority = priority;

          lstPromotion = await checkPromotionSchemeAlow(
              customerId, lstPromotion, lstProduct);
          priority++;
        }
      }
    }
    return lstPromotion;
  }
}
