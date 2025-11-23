import 'package:horeca_service/sqflite_database/dto/product_promotion_dto.dart';

class SchemeDto {
  int? programId;
  int? schemeId;
  String? schemeContent;
  bool? isChoose;
  List<ProductPromotionDto>? lstProductApply;
  int? productId;
  String? productName;
  double? resultQty;
  String? typeResult;
  bool? isAllowed;

  SchemeDto(
      {this.programId,
      this.schemeId,
      this.schemeContent,
      this.isChoose = false,
      this.lstProductApply,
      this.productId,
      this.productName,
      this.resultQty,
      this.typeResult,
      this.isAllowed});

  factory SchemeDto.fromMap(Map<dynamic, dynamic> map) {
    return SchemeDto(
        programId: map['program_id'],
        schemeId: map['scheme_id'],
        schemeContent: map['scheme_content'],
        productId: map['product_id'],
        productName: map['product_name'],
        resultQty: map['result_qty']);
  }
}
