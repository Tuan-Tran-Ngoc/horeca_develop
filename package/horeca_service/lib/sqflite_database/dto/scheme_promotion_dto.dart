import 'package:horeca_service/sqflite_database/dto/product_promotion_dto.dart';

class SchemePromotionDto {
  int? programId;
  int? schemeId;
  String? schemeContent;
  bool? isChoose;
  List<ProductPromotionDto>? lstProductApply;
  List<ProductPromotionDto>? lstProductResult;
  // int? productId;
  // String? productName;
  // double? resultQty;
  // String? typeResult;
  bool? isAllowed;
  int priority;

  SchemePromotionDto(
      {this.programId,
      this.schemeId,
      this.schemeContent,
      this.isChoose = false,
      this.lstProductApply,
      this.lstProductResult,
      this.isAllowed,
      this.priority = 0});

  factory SchemePromotionDto.fromMap(Map<dynamic, dynamic> map) {
    return SchemePromotionDto(
      programId: map['program_id'],
      schemeId: map['scheme_id'],
      schemeContent: map['scheme_content'],
    );
  }
}
