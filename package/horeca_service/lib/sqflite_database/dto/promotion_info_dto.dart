import 'package:horeca_service/sqflite_database/dto/promotion_condition_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_info_dto.dart';

class PromotionInfoDto {
  int? promotionId;
  String? promotionCode;
  String? promotionName;
  int? schemeId;
  String? promotionType;
  String? conditionType;
  List<PromotionConditionInfoDto>? lstPromotionCodition;
  List<PromotionResultInfoDto>? lstPromotionResult;

  PromotionInfoDto(
      {this.promotionId,
      this.promotionCode,
      this.promotionName,
      this.schemeId,
      this.promotionType,
      this.conditionType,
      this.lstPromotionCodition,
      this.lstPromotionResult});

  factory PromotionInfoDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionInfoDto(
        promotionId: map['promotion_id'],
        promotionCode: map['promotion_code'],
        promotionName: map['promotion_name'],
        schemeId: map['promotion_scheme_id'],
        promotionType: map['promotion_type'],
        conditionType: map['condition_type']);
  }
}
