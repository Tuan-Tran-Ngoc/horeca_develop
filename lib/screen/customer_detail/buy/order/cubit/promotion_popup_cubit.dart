import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/service/order_service.dart';
import 'package:horeca/service/promotion_service.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/product_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';
import 'package:intl/intl.dart';

part 'promotion_popup_state.dart';

class PromotionPopupCubit extends Cubit<PromotionPopupState> {
  PromotionPopupCubit() : super(PromotionPopupInitial());
  PromotionProvider promotionProvider = PromotionProvider();
  PromotionService promotionService = PromotionService();
  OrderService orderService = OrderService();

  Future<void> init(int customerId, List<ProductDto> lstProduct,
      List<SchemePromotionDto> lstSchemeAvailable) async {
    // object target
    List<PromotionDto> results = [];
    // when no element product then show all promotion
    bool isShowAllPromotion = false;

    // get all promotion can apply(follow product)
    List<PromotionResultOrderDto> lstPromotionCanApply = [];
    if (lstProduct.isNotEmpty) {
      lstPromotionCanApply =
          await orderService.applyPromotionOrder(customerId, lstProduct, null);
    } else {
      isShowAllPromotion = true;
    }

    // select info promotion
    // List<PromotionDto> lstPromotion =
    //     await promotionProvider.selectPromotionByCustomerId(customerId, null);
    List<PromotionDto> lstPromotion =
        await promotionService.getSchemeContentPromotion(customerId);

    for (var promotion in lstPromotion) {
      List<SchemePromotionDto> lstShemeResult = [];
      for (SchemePromotionDto scheme in promotion.lstSchemeOrder ?? []) {
        if (isShowAllPromotion ||
            (lstPromotionCanApply.any((element) =>
                element.promotionId == promotion.promotionId &&
                element.schemeId == scheme.schemeId))) {
          PromotionResultOrderDto promotionCanApply = lstPromotionCanApply
              .firstWhere((element) => element.schemeId == scheme.schemeId,
                  orElse: () => PromotionResultOrderDto());

          scheme.lstProductApply = promotionCanApply.lstProductApply;
          scheme.lstProductResult = promotionCanApply.lstProductResult;
          lstShemeResult.add(scheme);
        }
      }

      if (lstShemeResult.isNotEmpty) {
        promotion.lstSchemeOrder = lstShemeResult;
        PromotionDto result = promotion;

        results.add(result);
      }
    }

    for (var promotion in results) {
      // setting isChoose
      promotion.lstSchemeOrder =
          updateIsChoose(promotion.lstSchemeOrder!, lstSchemeAvailable);
    }

    results = await checkPromotionSchemeAlow(customerId, results, lstProduct);
    emit(LoadingInitialPromotion(results));
  }

  int checkSchemeIsExist(
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

  List<SchemePromotionDto> updateIsChoose(List<SchemePromotionDto> lstScheme,
      List<SchemePromotionDto> lstSchemeAvailable) {
    lstScheme.forEach((scheme) {
      SchemePromotionDto isExist = lstSchemeAvailable.firstWhere(
          (element) => element.schemeId == scheme.schemeId,
          orElse: () => SchemePromotionDto());
      if (isExist.schemeId != null) {
        scheme.isChoose = true;
        scheme.priority = isExist.priority;
      }
    });
    return lstScheme;
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

  Future<void> eventChoosePromotion(int customerId,
      List<PromotionDto> lstPromotion, List<ProductDto> lstProduct) async {
    emit(StartEventChoosePromotion());
    //get list scheme promotion applying
    lstPromotion =
        await checkPromotionSchemeAlow(customerId, lstPromotion, lstProduct);

    emit(EventChoosePromotionSucessful(lstPromotion));
  }

  // Future<void> eventSelectAllPromotion(int customerId,
  //     List<PromotionDto> lstPromotion, List<ProductDto> lstProduct) async {
  //   emit(StartEventChoosePromotion());
  //   //get list scheme promotion applying
  //   for (PromotionDto promotion in lstPromotion) {}
  //   lstPromotion =
  //       await checkPromotionSchemeAlow(customerId, lstPromotion, lstProduct);

  //   emit(EventChoosePromotionSucessful(lstPromotion));
  // }

  Future<void> applyAllPromotion(int customerId,
      List<PromotionDto> lstPromotion, List<ProductDto> lstProduct) async {
    emit(EventApplyAllPromotion());
    lstPromotion = await promotionService.applyAllPromotion(
        customerId, lstPromotion, lstProduct);
    emit(EventApplyAllPromotionSuccess(lstPromotion));
  }

  Future<void> warningProductAvailable(int customerId,
      List<PromotionDto> lstPromotion, List<ProductDto> lstProduct) async {
    emit(ClickBtnSelectStart());

    String result = await promotionService.notifyProductAvailable(
        customerId, lstPromotion, lstProduct);

    emit(ClickBtnSelectSuccess(result));
  }

  // Future<List<ProductDto>> productAvailabelForPromotion(
  //     int customerId,
  //     List<SchemePromotionDto> lstPromotion,
  //     List<ProductDto> lstProduct) async {
  //   // List<PromotionResultOrderDto> lstPromotionCanApply =
  //   //     await orderService.applyPromotionOrder(customerId, lstProduct, txn);
  //   List<ProductDto> results = [];
  //   //get product Apply
  //   List<ProductPromotionDto> lstProductApply = [];
  //   for (SchemePromotionDto promotion in lstPromotion) {
  //     for (ProductPromotionDto productApply
  //         in (promotion.lstProductApply ?? [])) {
  //       ProductPromotionDto copiedProductApply = ProductPromotionDto(
  //           productId: productApply.productId,
  //           productName: productApply.productName,
  //           totalQuatity: productApply.totalQuatity,
  //           totalAmount: productApply.totalAmount);
  //       if (!lstProductApply.any(
  //           (element) => element.productId == copiedProductApply.productId)) {
  //         lstProductApply.add(copiedProductApply);
  //       } else {
  //         int index = lstProductApply.indexWhere(
  //             (element) => element.productId == copiedProductApply.productId);

  //         lstProductApply[index].totalQuatity =
  //             (lstProductApply[index].totalQuatity ?? 0) +
  //                 (copiedProductApply.totalQuatity ?? 0);
  //       }
  //     }
  //   }

  //   for (ProductPromotionDto productApply in lstProductApply) {
  //     if (lstProduct
  //         .any((element) => element.productId == productApply.productId)) {
  //       int index = lstProduct.indexWhere(
  //           (element) => element.productId == productApply.productId);
  //       if (((lstProduct[index].quantity ?? 0) -
  //               (productApply.totalQuatity ?? 0)) !=
  //           0) {
  //         ProductDto result = ProductDto(
  //             productName: lstProduct[index].productName,
  //             quantity: (lstProduct[index].quantity ?? 0) -
  //                 (productApply.totalQuatity ?? 0));

  //         results.add(result);
  //         break;
  //       }
  //     }
  //   }

  //   return results;
  // }
}
