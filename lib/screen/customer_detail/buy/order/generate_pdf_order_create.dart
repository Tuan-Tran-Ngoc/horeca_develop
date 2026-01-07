import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/sqflite_database/dto/discount_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/order_header_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/summary_order_dto.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GeneratePdfOrderCreate {
  final BuildContext context;
  final PdfPageFormat format;
  final OrderHeaderDto orderHeader;
  final List<ProductDto> lstProduct;
  final List<SchemePromotionDto> lstPromotion;
  final List<DiscountResultOrderDto> lstDiscount;
  final SummaryOrderDto summaryOrder;

  const GeneratePdfOrderCreate(
      {required this.context,
      required this.format,
      required this.orderHeader,
      required this.lstProduct,
      required this.lstPromotion,
      required this.lstDiscount,
      required this.summaryOrder});

  Future<Uint8List> generatePdf(String title) async {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.sourceSans3Regular();
    final boldFont = await PdfGoogleFonts.sourceSans3Bold();
    int index = 0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) {
          return [
            pw.Column(
              children: [
                pw.SizedBox(height: 20),
                pw.Container(
                  width: double.infinity,
                  child: pw.Text(
                    title,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 50,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                buildInformationViewPdf(orderHeader, multiLang, font, boldFont),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.only(left: 20),
                  alignment: pw.Alignment.topLeft,
                  child: pw.Text(
                    'I.Danh sách sản phẩm',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('STT',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Tên sản phẩm',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Số lượng',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Đơn vị',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Đơn giá trước VAT',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Tỉ lệ chiết khấu',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Đơn giá chiết khấu',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Tổng cộng',
                              style: pw.TextStyle(font: boldFont, fontSize: 12))
                        ],
                      ),
                      for (var i = 0; i < lstProduct.length; i++)
                        pw.TableRow(
                          children: [
                            pw.Text('${i + 1}',
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(lstProduct[i].productName ?? '',
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(
                                NumberFormat.decimalPattern()
                                    .format(lstProduct[i].quantity ?? 0),
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(lstProduct[i].uomName ?? '',
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(
                                NumberFormat.currency(locale: 'vi')
                                    .format(lstProduct[i].salesPrice ?? 0),
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(lstProduct[i].discountRate ?? '',
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(
                                NumberFormat.currency(locale: 'vi').format(
                                    lstProduct[i].priceCostDiscount ?? 0),
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(
                                NumberFormat.currency(locale: 'vi').format(
                                    lstProduct[i].quantity! *
                                        (lstProduct[i].priceCostDiscount ?? 0)),
                                style: pw.TextStyle(font: font, fontSize: 12)),
                          ],
                        ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.only(left: 20),
                  alignment: pw.Alignment.topLeft,
                  child: pw.Text(
                    'II.Danh sách khuyến mãi',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('STT',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Sản phẩm khuyến mãi',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Số lượng',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Chú thích',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                        ],
                      ),
                      for (var i = 0; i < lstPromotion.length; i++)
                        for (var y = 0;
                            y < (lstPromotion[i].lstProductResult ?? []).length;
                            y++)
                          pw.TableRow(
                            children: [
                              pw.Text('${index++}',
                                  style:
                                      pw.TextStyle(font: font, fontSize: 12)),
                              pw.Text(
                                  lstPromotion[i]
                                          .lstProductResult?[y]
                                          .productName ??
                                      '',
                                  style:
                                      pw.TextStyle(font: font, fontSize: 12)),
                              pw.Text(
                                  NumberFormat.decimalPattern().format(
                                      lstPromotion[i]
                                              .lstProductResult?[y]
                                              .totalQuatity ??
                                          0),
                                  style:
                                      pw.TextStyle(font: font, fontSize: 12)),
                              pw.Text(lstPromotion[i].schemeContent ?? '',
                                  style:
                                      pw.TextStyle(font: font, fontSize: 12)),
                            ],
                          )
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.only(left: 20),
                  alignment: pw.Alignment.topLeft,
                  child: pw.Text(
                    'I.Danh sách chiết khấu',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('STT',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Loại',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Tổng chiết khấu',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                          pw.Text('Chú thích',
                              style:
                                  pw.TextStyle(font: boldFont, fontSize: 12)),
                        ],
                      ),
                      for (var i = 0; i < lstDiscount.length; i++)
                        pw.TableRow(
                          children: [
                            pw.Text('${i + 1}',
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(
                                CodeListUtils.getMessage('cl.discount.type',
                                        lstDiscount[i].conditionType) ??
                                    '',
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(
                                NumberFormat.currency(locale: 'vi')
                                    .format(lstDiscount[i].totalDiscount ?? 0),
                                style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.Text(lstDiscount[i].remark ?? '',
                                style: pw.TextStyle(font: font, fontSize: 12)),
                          ],
                        ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.only(left: 20),
                  alignment: pw.Alignment.topLeft,
                  child: pw.Text(
                    'IV.Tóm tắt',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(20, 5, 20, 20),
                    child: pw.Column(children: [
                      buildInformationCellSingle(
                          title: 'Tổng số lượng',
                          value: NumberFormat.decimalPattern()
                              .format(summaryOrder.totalQuantity ?? 0),
                          font: font,
                          boldFont: boldFont),
                      buildInformationCellSingle(
                          title: 'Tổng tiền mua hàng',
                          value: NumberFormat.currency(locale: 'vi')
                              .format(summaryOrder.totalAmount ?? 0),
                          font: font,
                          boldFont: boldFont),
                      buildInformationCellSingle(
                          title: 'Chiết khấu',
                          value: NumberFormat.currency(locale: 'vi')
                              .format(summaryOrder.discountAmount ?? 0),
                          font: font,
                          boldFont: boldFont),
                      buildInformationCellSingle(
                          title: 'Tổng khuyến mãi',
                          value: NumberFormat.currency(locale: 'vi')
                              .format(summaryOrder.promotionAmount ?? 0),
                          font: font,
                          boldFont: boldFont),
                      buildInformationCellSingle(
                          title: 'Tổng VAT',
                          value: NumberFormat.currency(locale: 'vi')
                              .format(summaryOrder.vatAmount ?? 0),
                          font: font,
                          boldFont: boldFont),
                      buildInformationCellSingle(
                          title: 'Tổng tiền',
                          value: NumberFormat.currency(locale: 'vi')
                              .format(summaryOrder.grandTotalAmount ?? 0),
                          font: font,
                          boldFont: boldFont)
                    ])),
              ],
            )
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget buildInformationViewPdf(
      OrderHeaderDto orderHeader,
      AppLocalizations multiLang,
      pw.Font font,
      pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(left: 32, right: 32),
      child: pw.Column(children: [
        buildInformationCell(
            title1: multiLang.orderNo,
            title2: multiLang.customerCode,
            value1: orderHeader.orderCd ?? '',
            value2: orderHeader.customerCode ?? '',
            font: font,
            boldFont: boldFont),
        buildInformationCell(
            title1: multiLang.salesDate,
            title2: multiLang.customerName,
            value1: CommonUtils.convertDate(
                orderHeader.orderDate, Constant.dateFormatterYYYYMMDD),
            value2: orderHeader.customerName ?? '',
            font: font,
            boldFont: boldFont),
        buildInformationCell(
            title1: multiLang.address,
            title2: multiLang.orderType,
            value1: orderHeader.address ?? '',
            value2: CodeListUtils.getMessage(
                    Constant.clTypeOrder, orderHeader.selectedTypeOrder) ??
                '',
            font: font,
            boldFont: boldFont),
        buildInformationCell(
            title1: multiLang.status,
            title2: multiLang.planDeliveryDate,
            value1: CodeListUtils.getMessage(
                    Constant.clHorecaSts, orderHeader.horecaStatus) ??
                '',
            value2: CommonUtils.convertDate(
                orderHeader.planShippingDate, Constant.dateFormatterYYYYMMDD),
            font: font,
            boldFont: boldFont),
        buildInformationCell(
            title1: multiLang.poNumber,
            title2: multiLang.note,
            value1: orderHeader.pOnumber ?? '',
            value2: orderHeader.remark ?? '',
            font: font,
            boldFont: boldFont)
      ]),
    );
  }

  pw.Widget buildInformationCell(
      {required String title1,
      required String title2,
      required String value1,
      required String value2,
      required pw.Font font,
      required pw.Font boldFont}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title1,
                  style: pw.TextStyle(
                      font: boldFont,
                      fontWeight: pw.FontWeight.bold)),
              pw.Text(value1,
                  style: pw.TextStyle(font: font)),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title2,
                  style: pw.TextStyle(
                      font: boldFont,
                      fontWeight: pw.FontWeight.bold)),
              pw.Text(value2,
                  style: pw.TextStyle(font: font)),
            ],
          ),
        )
      ],
    );
  }

  pw.Widget buildInformationCellSingle(
      {required String title,
      required String value,
      required pw.Font font,
      required pw.Font boldFont}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title,
                  style: pw.TextStyle(
                      font: boldFont,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 10),
              pw.Text(value,
                  style: pw.TextStyle(font: font)),
            ],
          ),
        ),
      ],
    );
  }
}


