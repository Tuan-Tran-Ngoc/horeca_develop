import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/summary_order_dto.dart';

class OrderHeaderDto extends SummaryOrderDto {
  String? orderCd;
  String? customerCode;
  String? orderDate;
  String? customerName;
  int? orderDebtLimit;
  int? remainDebtLimit;
  String? address;
  bool? orderStatus;
  String? planShippingDate;
  List<Resource>? lstTypeOrder;
  String? selectedTypeOrder;
  String? pOnumber;
  String? remark;
  String? horecaStatus;
  double? vatValue;

  OrderHeaderDto(
      {this.orderCd,
      this.customerCode,
      this.orderDate,
      this.customerName,
      this.orderDebtLimit,
      this.remainDebtLimit,
      this.address,
      this.orderStatus = false,
      this.planShippingDate,
      this.lstTypeOrder,
      this.selectedTypeOrder,
      this.pOnumber,
      this.remark,
      this.horecaStatus,
      super.totalAmount,
      super.discountAmount,
      super.promotionAmount,
      super.vatAmount,
      super.grandTotalAmount,
      this.vatValue});

  factory OrderHeaderDto.fromMap(Map<dynamic, dynamic> map) {
    return OrderHeaderDto(
        orderCd: map['order_cd'],
        customerCode: map['customer_code'],
        orderDate: map['order_date'],
        customerName: map['customer_name'],
        orderDebtLimit: map['order_debt_limit'],
        remainDebtLimit: map['remain_debt_limit'],
        address: map['address'],
        orderStatus: map['order_status'],
        planShippingDate: map['expect_delivery_date'],
        selectedTypeOrder: map['order_type'],
        pOnumber: map['po_no'],
        remark: map['remark'],
        totalAmount: (map['total_amount'] ?? 0),
        discountAmount: map['total_discount'],
        vatAmount: map['vat'],
        grandTotalAmount: map['grand_total_amount'],
        horecaStatus: map['horeca_status']);
  }
}
