import 'package:horeca_service/sqflite_database/dto/product_promotion_dto.dart';

class PromotionResultOrderDto {
  int? promotionId;
  int? schemeId;
  String? conditionType;
  String? totalType; // type condition promotion
  List<ProductPromotionDto>? lstProductApply;
  List<ProductPromotionDto>? lstProductResult;

  // int? productIdResult;
  // double? resultQty;

  PromotionResultOrderDto(
      {this.promotionId,
      this.schemeId,
      this.conditionType,
      this.totalType,
      this.lstProductApply,
      this.lstProductResult});

  factory PromotionResultOrderDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionResultOrderDto(
        promotionId: map['promotion_id'],
        schemeId: map['scheme_id'],
        conditionType: map['condition_type'],
        totalType: map['total_type']);
  }
}
