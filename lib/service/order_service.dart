import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/discount_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_condition_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_result_order_dto.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class OrderService {
  final PromotionProvider promotionProvider = PromotionProvider();
  final PromotionConditionProvider promotionConditionProvider =
      PromotionConditionProvider();
  final PromotionResultProvider promotionResultProvider =
      PromotionResultProvider();
  final DiscountProvider discountProvider = DiscountProvider();

  Future<List<PromotionResultOrderDto>> applyPromotionOrder(
      int customerId, List<ProductDto> lstProduct, Transaction? txn) async {
    if (customerId <= 0 || lstProduct.isEmpty) {
      return [];
    }
    List<PromotionResultOrderDto> results = [];
    /**
     * ***Khuyến mãi:
      (
      m_promotion.promotion_type = 00 -> lũy kế
      m_promotion.promotion_type = 01 -> không lũy kế
      )

      ** Tổng (m_promotion.condition_type = 00)
      - m_promotion_condition:
        + total_type: 00 -> Tổng số tiền (trị giá)
        + total_type: 01 -> Tổng số sản phẩm
      - m_promotion_result -> sản phẩm tặng only hàng hóa

      **  Chi tiết (m_promotion.condition_type = 01)
      - m_promotion_condition:
        + total_type is null
      - m_promotion_result -> sản phẩm tặng only hàng hóa
      -> từng sản phẩm phải thỏa điều kiện conditionQty cho từng SKU

      ** Combo (m_promotion.condition_type = 02)
      - m_promotion_result:
        + total_type is null
      - m_promotion_result -> sản phẩm tặng only hàng hóa
      -> tổng SKU >= conditionQty
     */

    // get promotionid
    List<PromotionDto> lstInitialPromotion =
        await promotionProvider.selectPromotionByCustomerId(customerId, txn);
    List<int> lstPromotionId =
        lstInitialPromotion.map((e) => e.promotionId ?? 0).toList();

    // get promotion current applied for this customer(scheme)
    List<PromotionInfoDto> lstPromotion = await promotionProvider
        .selectPromotionSchemeByCustomerId(lstPromotionId, txn);

    for (var promotion in lstPromotion) {
      List<PromotionConditionInfoDto> lstPromotionCondition =
          await promotionConditionProvider.selectPromotionConditionInfo(
              promotion.promotionId!, promotion.schemeId!, txn);

      List<PromotionResultInfoDto> lstPromotionResult =
          await promotionResultProvider.selectPromotionResultInfo(
              promotion.promotionId!, promotion.schemeId!, txn);

      promotion.lstPromotionCodition = lstPromotionCondition;
      promotion.lstPromotionResult = lstPromotionResult;
    }

    // total Amount lstProduct
    double? totalAmount = lstProduct
        .map((product) => (product.priceCostDiscount ?? 0) * product.quantity!)
        .reduce((price1, price2) => price1 + price2);

    // total quantity lstProduct
    double? totalQuatity = lstProduct
        .map((product) => product.quantity)
        .reduce((quantity1, quantity2) => quantity1! + quantity2!);

    // case promotion total order: condition_type = 00
    double? conditionAmount = 0; // tri gia
    double? conditionQty = 0; // so luong
    for (var promotion in lstPromotion) {
      // case promotion total order: condition_type = 00
      if (promotion.conditionType == '00') {
        conditionAmount = promotion.lstPromotionCodition
            ?.firstWhere(
              (condition) => condition.totalType == '00',
              orElse: () => PromotionConditionInfoDto(),
            )
            .conditionQty;
        conditionQty = promotion.lstPromotionCodition
            ?.firstWhere(
              (condition) => condition.totalType == '01',
              orElse: () => PromotionConditionInfoDto(),
            )
            .conditionQty;

        if (totalAmount >= conditionAmount! && totalQuatity! >= conditionQty!) {
          // thoa dieu kien
          // luy ke
          if (promotion.promotionType == '00') {
            // so lan apply khuyen mai
            int noTimesAmount = totalAmount ~/ conditionAmount;
            int noTimesQty = totalQuatity ~/ conditionQty;
            int noTimes =
                (noTimesAmount > noTimesQty) ? noTimesQty : noTimesAmount;

            // product applied
            List<ProductPromotionDto> lstProductApply = [];
            conditionQty = conditionQty * noTimes;
            for (ProductDto product in lstProduct) {
              if ((conditionQty ?? 0) <= 0) {
                break;
              }
              if ((product.quantity ?? 0) <= (conditionQty ?? 0)) {
                ProductPromotionDto productApply = ProductPromotionDto(
                    productId: product.productId,
                    productName: product.productName,
                    totalAmount: (product.priceCostDiscount ?? 0) *
                        (product.quantity ?? 0),
                    totalQuatity: product.quantity);

                conditionQty = (conditionQty ?? 0) - (product.quantity ?? 0);
                lstProductApply.add(productApply);
              } else {
                ProductPromotionDto productApply = ProductPromotionDto(
                    productId: product.productId,
                    productName: product.productName,
                    totalAmount:
                        (product.priceCostDiscount ?? 0) * (conditionQty ?? 0),
                    totalQuatity: conditionQty);

                conditionQty = (conditionQty ?? 0) - (product.quantity ?? 0);
                lstProductApply.add(productApply);
              }
            }

            // setting applied promotion into result
            List<ProductPromotionDto> lstProductResult = [];
            for (var promotionResult in promotion.lstPromotionResult!) {
              ProductPromotionDto productResult = ProductPromotionDto(
                  productId: promotionResult.productId,
                  productName: promotionResult.productName,
                  totalQuatity: promotionResult.resultQty! * noTimes);
              lstProductResult.add(productResult);
            }
            PromotionResultOrderDto result = PromotionResultOrderDto(
                promotionId: promotion.promotionId,
                schemeId: promotion.schemeId,
                conditionType: promotion.conditionType,
                lstProductApply: lstProductApply,
                lstProductResult: lstProductResult);

            // setting last result
            results.add(result);
          } else if (promotion.promotionType == '01') {
            // khong luy ke

            List<ProductPromotionDto> lstProductApply = [];
            // product applied
            for (ProductDto product in lstProduct) {
              if ((conditionQty ?? 0) <= 0) {
                break;
              }
              if ((product.quantity ?? 0) <= (conditionQty ?? 0)) {
                ProductPromotionDto productApply = ProductPromotionDto(
                    productId: product.productId,
                    productName: product.productName,
                    totalAmount: (product.priceCostDiscount ?? 0) *
                        (product.quantity ?? 0),
                    totalQuatity: product.quantity);

                conditionQty = (conditionQty ?? 0) - (product.quantity ?? 0);
                lstProductApply.add(productApply);
              } else {
                ProductPromotionDto productApply = ProductPromotionDto(
                    productId: product.productId,
                    productName: product.productName,
                    totalAmount:
                        (product.priceCostDiscount ?? 0) * (conditionQty ?? 0),
                    totalQuatity: conditionQty);

                conditionQty = (conditionQty ?? 0) - (product.quantity ?? 0);
                lstProductApply.add(productApply);
              }
            }

            // setting applied promotion into result
            List<ProductPromotionDto> lstProductResult = [];
            for (var promotionResult in promotion.lstPromotionResult!) {
              ProductPromotionDto productResult = ProductPromotionDto(
                  productId: promotionResult.productId,
                  productName: promotionResult.productName,
                  totalQuatity: promotionResult.resultQty);
              lstProductResult.add(productResult);
            }

            PromotionResultOrderDto result = PromotionResultOrderDto(
                promotionId: promotion.promotionId,
                schemeId: promotion.schemeId,
                conditionType: promotion.conditionType,
                lstProductApply: lstProductApply,
                lstProductResult: lstProductResult);

            results.add(result);
          }
        }
      }

      // case promotion detail for SKU
      if (promotion.conditionType == '01') {
        // check dieu kien apply promotion
        bool isApplyPromotion = true;
        // variable for luy ke
        int noTimes = 1 << 63 - 1;

        // initial product applied
        List<ProductPromotionDto> lstProductApply = [];

        for (var promotionCondition in promotion.lstPromotionCodition!) {
          ProductDto? promotionProduct = lstProduct.firstWhere(
              (product) => product.productId == promotionCondition.productId,
              orElse: () => ProductDto());
          if (promotionProduct.quantity != null &&
              promotionCondition.conditionQty != null &&
              promotionProduct.quantity! >= promotionCondition.conditionQty!) {
            int noTimesProduct =
                promotionProduct.quantity! ~/ promotionCondition.conditionQty!;
            noTimes = noTimes > noTimesProduct ? noTimesProduct : noTimes;

            // setting product applied
            // truong hop khong luy ke
            if (promotion.promotionType == '01') {
              noTimes = 1;
            }

            ProductPromotionDto productApply = ProductPromotionDto(
                productId: promotionCondition.productId,
                totalAmount: 0,
                totalQuatity: (promotionCondition.conditionQty ?? 0) * noTimes);
            lstProductApply.add(productApply);
          } else {
            // not exist promotion product
            isApplyPromotion = false;
            break;
          }
        }

        //setting promotion result
        if (isApplyPromotion) {
          List<ProductPromotionDto> lstProductResult = [];
          for (var promotionResult in promotion.lstPromotionResult!) {
            ProductPromotionDto productResult = ProductPromotionDto(
                productId: promotionResult.productId,
                productName: promotionResult.productName,
                totalQuatity: promotionResult.resultQty! * noTimes);
            lstProductResult.add(productResult);
          }

          PromotionResultOrderDto result = PromotionResultOrderDto(
              promotionId: promotion.promotionId,
              schemeId: promotion.schemeId,
              conditionType: promotion.conditionType,
              lstProductApply: lstProductApply,
              lstProductResult: lstProductResult);

          results.add(result);
        }
      }

      // case promotion combo
      if (promotion.conditionType == '02') {
        // total promotion product
        double promotionProductQty = 0;
        double promotionQty = 0;

        // check dieu kien apply promotion
        bool isApplyPromotion = false;
        // initial product applied
        List<ProductPromotionDto> lstProductApply = [];
        // luy ke
        int noTimes = 0;
        if (promotion.promotionType == '00') {
          for (var promotionCondition in promotion.lstPromotionCodition!) {
            promotionQty = promotionCondition.conditionQty!;
            ProductDto? promotionProduct = lstProduct.firstWhere(
                (product) => product.productId == promotionCondition.productId,
                orElse: () => ProductDto());

            if (promotionProduct.quantity != null) {
              // setting into lstProductApplied
              ProductPromotionDto productApply = ProductPromotionDto(
                  productId: promotionCondition.productId,
                  totalAmount: 0,
                  totalQuatity: promotionProduct.quantity);
              lstProductApply.add(productApply);
              promotionProductQty =
                  promotionProductQty + promotionProduct.quantity!;
            }
          }

          if (promotionProductQty >= promotionQty) {
            noTimes = promotionProductQty ~/ promotionQty;

            //get last product applied
            ProductPromotionDto lastProduct =
                lstProductApply[lstProductApply.length - 1];
            lastProduct.totalQuatity = (lastProduct.totalQuatity ?? 0) -
                (promotionProductQty - promotionQty * noTimes);
            lstProductApply[lstProductApply.length - 1] = lastProduct;

            isApplyPromotion = true;
          }
        } else {
          noTimes = 1;
          for (var promotionCondition in promotion.lstPromotionCodition!) {
            promotionQty = promotionCondition.conditionQty!;
            ProductDto promotionProduct = lstProduct.firstWhere(
                (product) => product.productId == promotionCondition.productId,
                orElse: () => ProductDto());

            if (promotionProduct.quantity != null) {
              promotionProductQty =
                  promotionProductQty + promotionProduct.quantity!;

              // setting into lstProductApplied
              ProductPromotionDto productApply = ProductPromotionDto(
                  productId: promotionCondition.productId,
                  totalAmount: 0,
                  totalQuatity: promotionProduct.quantity);
              lstProductApply.add(productApply);

              if (promotionProductQty >= promotionQty) {
                isApplyPromotion = true;
                productApply.totalQuatity = (promotionProduct.quantity ?? 0) -
                    (promotionProductQty - promotionQty);
                lstProductApply.add(productApply);
                break;
              } else {
                lstProductApply.add(productApply);
              }
            }
          }
        }

        //setting promotion result
        if (isApplyPromotion) {
          List<ProductPromotionDto> lstProductResult = [];
          for (var promotionResult in promotion.lstPromotionResult!) {
            ProductPromotionDto productResult = ProductPromotionDto(
                productId: promotionResult.productId,
                productName: promotionResult.productName,
                totalQuatity: promotionResult.resultQty! * noTimes);
            lstProductResult.add(productResult);
          }

          PromotionResultOrderDto result = PromotionResultOrderDto(
              promotionId: promotion.promotionId,
              schemeId: promotion.schemeId,
              conditionType: promotion.conditionType,
              lstProductApply: lstProductApply,
              lstProductResult: lstProductResult);

          results.add(result);
        }
      }
    }

    return results;
  }

  Future<List<ProductDto>> applyDiscountSKU(
      int customerId, List<ProductDto> lstProduct, Transaction? txn) async {
    /**
         * ***Chiết khấu
          ** Sản phẩm (m_discount.condition_type = 01)
          - m_discount_condition: 
            + total_type: 00 -> sản lượng
            + total_type: 01 -> trị giá
          - m_discount_result:
            + discount_type: 00 -> Phần trăm
            + discount_type: 01 -> Tiền mặt
         */

    print('\n>>> ORDER_SERVICE: applyDiscountSKU() START <<<');
    print('Customer ID: $customerId');
    print('Products to process: ${lstProduct.length}');

    // all discount
    List<DiscountDto> lstInitialDiscount =
        await discountProvider.selectDiscountByCustomerId(customerId);
    List<int> lstDiscountId =
        lstInitialDiscount.map((e) => e.discountId ?? 0).toList();
    
    print('Total discount programs for customer: ${lstInitialDiscount.length}');

    // discount folow scheme
    List<DiscountInfoDto> lstDiscount = await discountProvider
        .selectDiscountSchemeByCustomerId(lstDiscountId, '01', txn);
    
    print('SKU-level discount schemes (condition_type=01): ${lstDiscount.length}');

    for (ProductDto product in lstProduct) {
      print('\n  ===== Processing Product =====');
      print('  Product ID: ${product.productId}');
      print('  Product Name: ${product.productName}');
      print('  Quantity: ${product.quantity}');
      print('  Sales Price: ${product.salesPrice}');
      
      // setting initial for discount
      product.discountPercent = 0;
      product.discountAmount = 0;

      // discount program apply
      List<DiscountInfoDto> appliedDiscounts = [];

      //inital discount rate string
      List<String> discountRates = [];

      // discount program can apply
      List<DiscountInfoDto> canAppliedDiscounts = lstDiscount
          .where((discount) => (discount.productId == product.productId ||
              discount.productId == 0))
          .toList();
      
      print('  Found ${canAppliedDiscounts.length} potential discount schemes for this product');

      double salesPrice = product.salesPrice ?? 0;
      double priceCostDiscount = 0;
      
      for (var canAppliedDiscount in canAppliedDiscounts) {
        print('\n    --- Checking Discount Scheme ---');
        print('    Discount ID: ${canAppliedDiscount.discountId}');
        print('    Product ID filter: ${canAppliedDiscount.productId} (0=all products)');
        print('    Total Type: ${canAppliedDiscount.totalType} (00=quantity, 01=value)');
        print('    Condition Qty/Value: ${canAppliedDiscount.conditionQty}');
        print('    Discount Type: ${canAppliedDiscount.discountType} (00=percent, 01=cash)');
        print('    Result Qty/Value: ${canAppliedDiscount.resultQty}');
        
        if (canAppliedDiscount.totalType == '00' &&
            product.quantity! >= canAppliedDiscount.conditionQty!) {
          print('    ✓ APPLIES: Quantity ${product.quantity} >= ${canAppliedDiscount.conditionQty}');
          appliedDiscounts.add(canAppliedDiscount);
        } else if (canAppliedDiscount.totalType == '01' &&
            (product.quantity! * (product.salesPrice ?? 0)) >=
                canAppliedDiscount.conditionQty!) {
          double totalValue = product.quantity! * (product.salesPrice ?? 0);
          print('    ✓ APPLIES: Total value $totalValue >= ${canAppliedDiscount.conditionQty}');
          appliedDiscounts.add(canAppliedDiscount);
        } else {
          print('    ✗ DOES NOT APPLY: Condition not met');
        }
      }

      //setting discount result
      print('\n  Applied Discounts: ${appliedDiscounts.length}');
      for (var appliedDiscount in appliedDiscounts) {
        if (appliedDiscount.discountType == '00') {
          // priceCostDiscount =
          //     priceCostDiscount * (100 - appliedDiscount.resultQty!) / 100;
          //discountRates.add('${appliedDiscount.resultQty}%');
          double percentBefore = product.discountPercent ?? 0;
          product.discountPercent =
              (product.discountPercent ?? 0) + (appliedDiscount.resultQty ?? 0);
          print('    + Percent Discount: ${appliedDiscount.resultQty}% (accumulated: $percentBefore% -> ${product.discountPercent}%)');
        } else if (appliedDiscount.discountType == '01') {
          // priceCostDiscount = priceCostDiscount - appliedDiscount.resultQty!;
          // discountRates.add(NumberFormat.currency(locale: 'vi')
          //     .format(appliedDiscount.resultQty));
          double amountBefore = product.discountAmount ?? 0;
          product.discountAmount =
              (product.discountAmount ?? 0) + (appliedDiscount.resultQty ?? 0);
          print('    + Cash Discount: ${appliedDiscount.resultQty} (accumulated: $amountBefore -> ${product.discountAmount})');
        }
      }

      // calculate last price
      double percentDiscount = salesPrice * (product.discountPercent ?? 0) / 100;
      double cashDiscount = product.discountAmount ?? 0;
      priceCostDiscount = salesPrice - (percentDiscount + cashDiscount);
      
      print('\n  === FINAL CALCULATION ===');
      print('  Sales Price: $salesPrice');
      print('  Percent Discount: ${product.discountPercent}% = $percentDiscount');
      print('  Cash Discount: $cashDiscount');
      print('  Formula: $salesPrice - ($percentDiscount + $cashDiscount)');
      print('  FINAL PRICE: $priceCostDiscount');
      
      product.priceCostDiscount = priceCostDiscount;

      // setting discount rate
      if ((product.discountPercent ?? 0) > 0) {
        // Show exact percentage without rounding
        discountRates.add('${product.discountPercent}%');
      }

      if ((product.discountAmount ?? 0) > 0) {
        // Show exact amount without rounding
        discountRates.add('${product.discountAmount}₫');
      }
      product.discountRate = discountRates.join('+');
      print('  Discount Rate Display: "${product.discountRate}"');
      print('  ===========================\n');
    }

    print('\n>>> ORDER_SERVICE: applyDiscountSKU() END <<<\n');
    return lstProduct;
  }

  Future<List<DiscountResultOrderDto>> applyDiscountOrder(
      int customerId, List<ProductDto> lstProduct, Transaction? txn) async {
    /**
         * ***Chiết khấu
          ** Tổng đơn hàng(m_discount.condition_type = 00)
          - m_discount_condition: 
            + total_type: 00 -> trị giá
            + total_type: 01 -> sản lượng
          - m_discount_result:
            + discount_type: 00 -> Phần trăm
            + discount_type: 01 -> Tiền mặt
         */

    List<DiscountResultOrderDto> results = [];
    // list applied discount
    List<DiscountInfoDto> appliedDiscounts = [];

    // all discount
    List<DiscountDto> lstInitialDiscount =
        await discountProvider.selectDiscountByCustomerId(customerId);
    List<int> lstDiscountId =
        lstInitialDiscount.map((e) => e.discountId ?? 0).toList();

    List<DiscountInfoDto> lstDiscount = await discountProvider
        .selectDiscountSchemeByCustomerId(lstDiscountId, '00', txn);

    double? totalAmount = 0.0;
    double? totalQuatity = 0.0;

    if (lstProduct.isNotEmpty) {
      // total Amount lstProduct
      totalAmount = lstProduct
          .map(
              (product) => (product.priceCostDiscount ?? 0) * product.quantity!)
          .reduce((price1, price2) => price1 + price2);

      // total quantity lstProduct
      totalQuatity = lstProduct
          .map((product) => product.quantity)
          .reduce((quantity1, quantity2) => quantity1! + quantity2!);
    }

    List<DiscountInfoDto> lstDiscountTotalSKU =
        lstDiscount.where((discount) => discount.totalType == '00').toList();

    double? conditionAmount = 0;
    double? conditionQty = 0;

    for (var discount in lstDiscountTotalSKU) {
      conditionAmount = discount.conditionQty;
      conditionQty = lstDiscount
          .firstWhere(
            (element) => (element.totalType == '01' &&
                discount.discountId == element.discountId),
            orElse: () => DiscountInfoDto(),
          )
          .conditionQty;

      if (conditionQty != null &&
          conditionAmount != null &&
          totalAmount >= conditionAmount &&
          totalQuatity! >= conditionQty) {
        appliedDiscounts.add(discount);
      }
    }

    // setting result discount
    for (var discount in appliedDiscounts) {
      //create remark
      List<String> params = [];

      conditionQty = lstDiscount
          .firstWhere(
            (element) => (element.totalType == '01' &&
                discount.discountId == element.discountId),
            orElse: () => DiscountInfoDto(),
          )
          .conditionQty;

      params.add('Đơn hàng mua');
      params
          .add(NumberFormat.decimalPattern().format(conditionQty)); //san luong
      params.add('sản phẩm và trị giá đạt');
      params.add(NumberFormat.currency(locale: 'vi')
          .format(discount.conditionQty)); // tri gia
      params.add('\nNhận');

      if (discount.discountType == '00') {
        DiscountResultOrderDto result = DiscountResultOrderDto(
            discountId: discount.discountId,
            conditionType: discount.conditionType,
            schemeId: discount.discountSchemeId,
            discountValue: discount.resultQty,
            totalDiscount: totalAmount * (discount.resultQty ?? 0) / 100,
            discountType: discount.discountType);

        params.add(NumberFormat.percentPattern()
            .format((discount.resultQty ?? 0) / 100));
        result.remark = params.join(' ');
        results.add(result);
      } else if (discount.discountType == '01') {
        DiscountResultOrderDto result = DiscountResultOrderDto(
            discountId: discount.discountId,
            conditionType: discount.conditionType,
            schemeId: discount.discountSchemeId,
            discountValue: discount.resultQty,
            totalDiscount: totalAmount - discount.resultQty!,
            discountType: discount.discountType);

        params.add(
            NumberFormat.currency(locale: 'vi').format(discount.resultQty));
        result.remark = params.join(' ');
        results.add(result);
      }
    }

    return results;
  }

  List<ProductDto> replaceElements(
      List<ProductDto> lstAllProduct, List<ProductDto> availableProduct) {
    lstAllProduct.asMap().forEach((index, elementA) {
      ProductDto matchingElement = availableProduct.firstWhere(
        (elementB) => elementB.productId == elementA.productId,
        orElse: () => ProductDto(),
      );

      if (matchingElement.productId != null) {
        //lstAllProduct[index] = matchingElement;
        lstAllProduct[index].customerPriceId = matchingElement.customerPriceId;
        lstAllProduct[index].customerStockId = matchingElement.customerStockId;
        lstAllProduct[index].priceCustomer = matchingElement.priceCustomer;
        lstAllProduct[index].quantity = matchingElement.quantity;
      }
    });

    return lstAllProduct;
  }
}
