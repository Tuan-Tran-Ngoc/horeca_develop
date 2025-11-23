import 'package:horeca_service/sqflite_database/dto/scheme_dto.dart';

class DiscountDto {
  int? discountId;
  String? discountCode;
  String? discountName;
  String? startDate;
  String? endDate;
  List<SchemeDto>? lstShemeOrder;

  DiscountDto(
      {this.discountId,
      this.discountCode,
      this.discountName,
      this.startDate,
      this.endDate,
      this.lstShemeOrder});

  factory DiscountDto.fromMap(Map<dynamic, dynamic> map) {
    return DiscountDto(
      discountId: map['discount_id'],
      discountCode: map['discount_code'],
      discountName: map['discount_name'],
      startDate: map['start_date'],
      endDate: map['end_date'],
    );
  }
}
