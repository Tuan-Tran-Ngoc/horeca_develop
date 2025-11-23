import 'package:horeca_service/sqflite_database/dto/promotion_display_condition_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_display_result_dto.dart';

class PromotionDisplayDto {
  int? promotionId;
  int? promotionSchemeId;
  List<PromotionDisplayConditionDto>? lstPromotionCondition;
  List<PromotionDisplayResultDto>? lstPromotionResult;

  PromotionDisplayDto(
      {this.promotionId,
      this.promotionSchemeId,
      this.lstPromotionCondition,
      this.lstPromotionResult});

  factory PromotionDisplayDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionDisplayDto(
      promotionId: map['promotion_id'],
      promotionSchemeId: map['promotion_scheme_id'],
    );
  }
}
