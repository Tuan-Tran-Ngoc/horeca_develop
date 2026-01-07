import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';

class PromotionDto {
  int? promotionId;
  String? promotionCode;
  String? promotionName;
  String? conditionType;
  String? startDate;
  String? endDate;
  String? promotionType;
  String? remark;
  List<SchemePromotionDto>? lstSchemeOrder;

  PromotionDto(
      {this.promotionId,
      this.promotionCode,
      this.promotionName,
      this.conditionType,
      this.startDate,
      this.endDate,
      this.lstSchemeOrder,
      this.promotionType,
      this.remark});

  factory PromotionDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionDto(
        promotionId: map['promotion_id'],
        promotionCode: map['promotion_code'],
        promotionName: map['promotion_name'],
        conditionType: map['condition_type'],
        startDate: map['start_date'],
        endDate: map['end_date'],
        promotionType: map['promotion_type'],
        remark: map['remark']);
  }
}
