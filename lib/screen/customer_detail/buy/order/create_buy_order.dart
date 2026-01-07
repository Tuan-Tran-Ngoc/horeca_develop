// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/buy/order/cubit/create_buy_order_cubit.dart';
import 'package:horeca/screen/customer_detail/buy/order/generate_pdf_order_create.dart';
import 'package:horeca/screen/customer_detail/buy/order/promotion_popup.dart';
import 'package:horeca/screen/customer_detail/buy/product/product_popup.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca/widgets/api_button.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca/widgets/text_field.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/discount_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/order_header_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/summary_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class CreateBuyOrderScreen extends StatelessWidget {
  int customerId;
  int customerVisitId;
  int? orderIdCopy;
  CreateBuyOrderScreen(
      {Key? key,
      required this.customerId,
      required this.customerVisitId,
      this.orderIdCopy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateBuyOrderCubit(context)
        ..init(customerId, customerVisitId, orderIdCopy ?? 0),
      child: CreateBuyOrderBody(
        customerId: customerId,
        customerVisitId: customerVisitId,
      ),
    );
  }
}

class CreateBuyOrderBody extends StatefulWidget {
  int customerId;
  int customerVisitId;
  CreateBuyOrderBody(
      {Key? key, required this.customerId, required this.customerVisitId})
      : super(key: key);

  @override
  State<CreateBuyOrderBody> createState() => _CreateBuyOrderBodyState();
}

class _CreateBuyOrderBodyState extends State<CreateBuyOrderBody> {
  List<List<String>> rowDataNull = [];
  final DatatableController _datatableController = DatatableController(-1);

  List<ProductDto> lstAllProduct = [];
  List<ProductDto> lstProduct = [];
  List<DiscountResultOrderDto> lstDiscount = [];
  List<PromotionResultOrderDto> lstPromotion = [];
  List<List<String>> rowDataProduct = [];
  OrderHeaderDto orderHeader = OrderHeaderDto();
  SummaryOrderDto summaryOrder = SummaryOrderDto();
  List<SchemePromotionDto> lstScheme = [];
  List<List<String>> rowDataPromotion = [];
  List<List<String>> rowDataDiscount = [];
  bool isCheckLiabilities = true;
  //bool isCreated = false;

  @override
  void initState() {
    super.initState();
  }

  List<SchemePromotionDto> chooseSchemePromotion(
      List<PromotionDto> lstPromotion) {
    List<SchemePromotionDto> results = lstPromotion
        .map((promotion) =>
            promotion.lstSchemeOrder!.where((scheme) => scheme.isChoose!))
        .expand((schemes) => schemes)
        .toList();

    results.sort((a, b) => a.priority.compareTo(b.priority));

    return results;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<ProductDto> getProductOrder(List<ProductDto> lstProduct) {
      return lstProduct.where((product) => product.quantity! > 0).toList();
    }

    void updateProductOrder(List<ProductDto> results) {
      // Helper function to round money values
      double roundMoney(double value) {
        return value.roundToDouble();
      }

      summaryOrder.totalAmount = 0;
      lstAllProduct = results;
      lstProduct = getProductOrder(results);
      int index = 0;
      double totalAmount = 0;
      double totalQuantity = 0;
      double discountAmount = 0;
      double promotionAmount = 0;
      double vatAmount = 0;
      rowDataProduct = lstProduct.map((product) {
        index++;
        List<String> result = [];
        print('product_id: ${product.productId}');
        
        // Round salesPrice and priceCostDiscount with null safety
        product.salesPrice = roundMoney(product.salesPrice ?? 0);
        product.priceCostDiscount = roundMoney(product.priceCostDiscount ?? 0);
        
        // Calculate and round line total with validation
        double quantity = product.quantity ?? 0;
        double price = product.priceCostDiscount ?? 0;
        double lineTotal = roundMoney(quantity * price);
        
        // Validate lineTotal is not NaN or infinite
        if (lineTotal.isNaN || lineTotal.isInfinite) {
          lineTotal = 0;
        }
        
        totalAmount = totalAmount + lineTotal;
        totalQuantity = totalQuantity + quantity;
        // setting product order detail
        result.add(index.toString());
        result.add(product.productName ?? '');
        result.add(NumberFormat.decimalPattern().format(product.quantity));
        result.add(product.uomName ?? '');
        result.add(NumberFormat.currency(locale: 'vi')
            .format(product.salesPrice!));
        result.add(product.discountRate ?? '');
        result.add(NumberFormat.currency(locale: 'vi')
            .format(product.priceCostDiscount!));
        result.add(NumberFormat.currency(locale: 'vi')
            .format(lineTotal));

        return result;
      }).toList();

      // setting summary order with rounding
      summaryOrder.totalAmount = totalAmount.roundToDouble();
      summaryOrder.totalQuantity = totalQuantity.roundToDouble();
      summaryOrder.discountAmount = discountAmount.roundToDouble();
      summaryOrder.promotionAmount = promotionAmount.roundToDouble();
      summaryOrder.vatAmount = vatAmount.roundToDouble();
      summaryOrder.grandTotalAmount =
          (totalAmount - discountAmount - promotionAmount + vatAmount).roundToDouble();
    }

    void updateSummary() {
      if (orderHeader.isTax == 1) {
        summaryOrder.vatAmount = (((summaryOrder.totalAmount ?? 0) -
                (summaryOrder.discountAmount ?? 0)) *
            (orderHeader.vatValue ?? 0)).roundToDouble();
      } else {
        summaryOrder.vatAmount = 0;
      }
      summaryOrder.grandTotalAmount = ((summaryOrder.totalAmount ?? 0) -
          (summaryOrder.discountAmount ?? 0) -
          (summaryOrder.promotionAmount ?? 0) +
          (summaryOrder.vatAmount ?? 0)).roundToDouble();
    }

    void updateDiscountOrder(List<DiscountResultOrderDto> lstDiscount) {
      int index = 0;
      double totalDiscount = 0;
      rowDataDiscount = lstDiscount.map((discount) {
        index++;
        List<String> result = [];
        // setting product order detail
        result.add(index.toString());
        result.add(CodeListUtils.getMessage(
                'cl.discount.type', discount.conditionType) ??
            '');
        result.add(
            NumberFormat.currency(locale: 'vi').format(discount.totalDiscount));
        result.add(discount.remark ?? '');

        totalDiscount = totalDiscount + (discount.totalDiscount ?? 0);

        return result;
      }).toList();

      print('total discount ${totalDiscount}');
      summaryOrder.discountAmount =
          ((summaryOrder.discountAmount ?? 0) + totalDiscount).roundToDouble();
      updateSummary();
    }

    void updatePromotionOrder(List<SchemePromotionDto> lstScheme) {
      setState(() {
        int index = 0;
        rowDataPromotion = [];
        lstScheme.forEach((scheme) {
          (scheme.lstProductResult ?? []).forEach((productResult) {
            index++;
            List<String> result = [];

            // setting product order detail
            result.add(index.toString());
            result.add(productResult.productName ?? '');
            result.add(NumberFormat.decimalPattern()
                .format(productResult.totalQuatity));
            result.add(scheme.schemeContent ?? '');

            rowDataPromotion.add(result);
          });
        });
      });
    }

    Widget OrderContent(BuildContext context) {
      AppLocalizations multiLang = AppLocalizations.of(context)!;

      List<Map<String, dynamic>> columnDataProduct = [
        {'title': multiLang.no, 'width': .03},
        {'title': multiLang.productName, 'width': .15},
        {
          'title': multiLang.quantity,
          'width': .1,
          'type': Constant.dataTypeInput
        },
        {'title': multiLang.unit, 'width': .1},
        {'title': multiLang.unitPriceBeforeVAT, 'width': .15},
        {'title': multiLang.discountRate, 'width': .15},
        {'title': multiLang.discountUnitPrice, 'width': .15},
        {'title': multiLang.total, 'width': .15}
      ];

      List<Map<String, dynamic>> columnDataPromotion = [
        {'title': multiLang.no, 'width': .1},
        {'title': multiLang.promotionalProduct, 'width': .3},
        {'title': multiLang.quantity, 'width': .12},
        {'title': multiLang.note, 'width': .4},
      ];

      List<Map<String, dynamic>> columnDataRose = [
        {'title': multiLang.no, 'width': .1},
        {'title': multiLang.type, 'width': .2},
        {'title': multiLang.totalDiscount, 'width': .2},
        {'title': multiLang.note, 'width': .4},
      ];

      return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.mainAppColor,
            title: Center(
                child: Text(
              multiLang.salesDetails.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColor.background),
            )),
            leading: Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      'assets/icons_app/home.png',
                      fit: BoxFit.contain,
                    )),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () async {
                    // Navigator.of(context).pop();
                    print('click icon pdf');
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async {
                      GeneratePdfOrderCreate generatePdfOrder =
                          GeneratePdfOrderCreate(
                              context: context,
                              format: format,
                              orderHeader: orderHeader,
                              lstProduct: lstProduct,
                              lstPromotion: lstScheme,
                              lstDiscount: lstDiscount,
                              summaryOrder: summaryOrder);
                      return generatePdfOrder.generatePdf('Thông tin đơn hàng');
                    });
                  },
                  child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset('assets/icons_app/pdf_icon.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () {
                    if (lstProduct.isNotEmpty) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          final ButtonStyle flatButtonStyle =
                              TextButton.styleFrom(
                            minimumSize: const Size(20, 20),
                            backgroundColor: Colors.grey,
                            padding: const EdgeInsets.all(0),
                          );
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!
                                  .notification
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.blue, // Màu sắc của tiêu đề
                                fontWeight: FontWeight.bold, // Font chữ đậm
                                fontSize: 18.0, // Kích thước chữ
                              ),
                            ),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  multiLang.waringBackOrder,
                                  style: const TextStyle(
                                    color: Colors.black, // Màu sắc của nội dung
                                    fontSize: 16.0, // Kích thước chữ
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(multiLang.yesAnswer),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(multiLang.noAnswer),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset('assets/icons_app/back.png')),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                // width: width,
                // height: MediaQuery.of(context).size.height - 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      InformationView(
                        orderHeader: orderHeader,
                      ),
                      const SizedBox(
                        height: Contants.spacingRow10,
                      ),
                      Container(
                        height: Contants.heightHeader,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppColor.mainAppColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonUtils.firstLetterUpperCase(
                                  multiLang.listOf(multiLang.product)),
                              style: const TextStyle(
                                  color: AppColor.background,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ProductPopup(
                                        width: width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        customerId: widget.customerId,
                                        isCheckStock: false,
                                        availableProduct: lstProduct,
                                        onResultProduct: (result) {
                                          lstProduct = getProductOrder(result);
                                          this
                                              .context
                                              .read<CreateBuyOrderCubit>()
                                              .applyDiscountAndPromotion(
                                                  widget.customerId,
                                                  lstProduct);
                                          //updateProductOrder(result);
                                        },
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.add,
                                color: AppColor.background,
                              ),
                            )
                          ],
                        ),
                      ),
                      DatatableWidget(
                          datatableController: _datatableController,
                          columnData: columnDataProduct,
                          rowData: rowDataProduct,
                          width: width,
                          onCellTap: (rowIndex, columnIndex) {
                            print('rowIndex $rowIndex');
                            print('columnIndex $columnIndex');
                            if (columnIndex == 2) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final product = lstProduct[rowIndex];
                                  String message = [
                                    multiLang.edit,
                                    multiLang.quantity,
                                    multiLang.product
                                  ].join(" ");

                                  TextEditingController quantityController =
                                      TextEditingController(
                                    text: (product.quantity ?? 0) == 0
                                        ? ''
                                        : (product.quantity ?? 0)
                                            .toInt()
                                            .toString(),
                                  );

                                  quantityController.addListener(() {
                                    if (quantityController.text == '0') {
                                      quantityController.text = '';
                                      // Di chuyển con trỏ văn bản về cuối để tránh lỗi con trỏ khi đặt lại văn bản
                                      quantityController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset:
                                                quantityController.text.length),
                                      );
                                    }
                                  });

                                  return AlertDialog(
                                    // title: Text(
                                    //     'Chỉnh sửa ${isPriceColumn ? 'giá' : 'số lượng'} sản phẩm'),
                                    title: Text(
                                        CommonUtils.firstLetterUpperCase(
                                            message)),
                                    content: TextFormField(
                                      controller: quantityController,
                                      onChanged: (value) {
                                        setState(() {
                                          quantityController.text = value;
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+'))
                                      ],
                                      decoration: InputDecoration(
                                        labelText:
                                            // isPriceColumn ? 'Giá' : 'Số lượng',
                                            multiLang.quantity,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            product.quantity = double.tryParse(
                                                    quantityController.text) ??
                                                0;
                                          });
                                          this
                                              .context
                                              .read<CreateBuyOrderCubit>()
                                              .applyDiscountAndPromotion(
                                                  widget.customerId,
                                                  lstProduct);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }),
                      const SizedBox(
                        height: Contants.spacingRow10,
                      ),
                      Container(
                        height: Contants.heightHeader,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppColor.mainAppColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonUtils.firstLetterUpperCase(
                                  multiLang.listOf(multiLang.promotion)),
                              style: const TextStyle(
                                  color: AppColor.background,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () async {
                                  // Navigator.of(context).pop();
                                  print('click copy order');
                                  context
                                      .read<CreateBuyOrderCubit>()
                                      .calculatePromotion(
                                          widget.customerId, lstProduct);
                                },
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                        'assets/icons_app/calculator-icon.png')),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return PromotionPopup(
                                        width: width * 0.85,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        customerId: widget.customerId,
                                        lstProduct: lstProduct,
                                        lstSchemeAvailable: lstScheme,
                                        onResultScheme: (result) {
                                          lstScheme = result;
                                          updatePromotionOrder(lstScheme);
                                        },
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.add,
                                color: AppColor.background,
                              ),
                            )
                          ],
                        ),
                      ),
                      DatatableWidget(
                        datatableController: _datatableController,
                        columnData: columnDataPromotion,
                        rowData: rowDataPromotion,
                        width: width,
                      ),
                      const SizedBox(
                        height: Contants.spacingRow10,
                      ),
                      Container(
                        height: Contants.heightHeader,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppColor.mainAppColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonUtils.firstLetterUpperCase(
                                  multiLang.listOf(multiLang.discount)),
                              style: const TextStyle(
                                  color: AppColor.background,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      DatatableWidget(
                        datatableController: _datatableController,
                        columnData: columnDataRose,
                        rowData: rowDataDiscount,
                        width: width,
                      ),
                      const SizedBox(
                        height: Contants.spacingRow16,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColor.disableBackgroundColor,
                      ),
                      const SizedBox(
                        height: Contants.spacingRow16,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 270,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 16),
                                width: width * 0.6,
                                height: 270,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: Contants.spacingRow10,
                                    ),
                                    SizedBox(
                                        height: 40,
                                        child: Text(multiLang.note)),
                                    AppTextField(
                                      placeHolder: multiLang.note,
                                      maxLine: 8,
                                      onChanged: (value) {
                                        setState(() {
                                          orderHeader.remark = value;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.only(right: 32),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                                  31, 220, 220, 220)
                                              .withOpacity(0.5),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: ListView(children: [
                                        const SizedBox(
                                          height: Contants.spacingRow10,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    multiLang.totalProductPurchase,
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              const SizedBox(
                                                width: Contants.spacingRow10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                NumberFormat.decimalPattern()
                                                    .format(summaryOrder
                                                        .totalQuantity ?? 0),
                                                textAlign: TextAlign.right,
                                              )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    multiLang.totalAmount,
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              const SizedBox(
                                                width: Contants.spacingRow10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                NumberFormat.currency(
                                                        locale: 'vi')
                                                    .format(summaryOrder
                                                        .totalAmount),
                                                textAlign: TextAlign.right,
                                              )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    multiLang.discount,
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              const SizedBox(
                                                width: Contants.spacingRow10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                NumberFormat.currency(
                                                        locale: 'vi')
                                                    .format(summaryOrder
                                                        .discountAmount),
                                                textAlign: TextAlign.right,
                                              )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    multiLang
                                                        .totalPromotionValue,
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              const SizedBox(
                                                width: Contants.spacingRow10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                NumberFormat.currency(
                                                        locale: 'vi')
                                                    .format(summaryOrder
                                                        .promotionAmount),
                                                textAlign: TextAlign.right,
                                              )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    multiLang.totalVATValue,
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              const SizedBox(
                                                width: Contants.spacingRow10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                NumberFormat.currency(
                                                        locale: 'vi')
                                                    .format(
                                                        summaryOrder.vatAmount),
                                                textAlign: TextAlign.right,
                                              )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    multiLang.grandTotalAmount,
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              const SizedBox(
                                                width: Contants.spacingRow10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                NumberFormat.currency(
                                                        locale: 'vi')
                                                    .format(summaryOrder
                                                        .grandTotalAmount),
                                                textAlign: TextAlign.right,
                                              )),
                                            ],
                                          ),
                                        ),
                                      ])))
                            ]),
                      ),
                      const SizedBox(
                        height: Contants.spacingRow10,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ApiButton(
                      apiKey: 'createOrder_${widget.customerId}_${widget.customerVisitId}',
                      backgroundColor: AppColor.mainAppColor,
                      height: 55,
                      width: width / 4,
                      text: multiLang.finish,
                      onPressed: () async {
                        context.read<CreateBuyOrderCubit>().createOrder(
                            widget.customerId,
                            widget.customerVisitId,
                            orderHeader,
                            summaryOrder,
                            lstProduct,
                            lstScheme,
                            lstDiscount,
                            isCheckLiabilities);
                      },
                    ),
                  )),
            ],
          ));
    }

    return BlocConsumer<CreateBuyOrderCubit, CreateBuyOrderState>(
      listener: (context, state) {
        if (state is CreateOrderSuccess) {
          Fluttertoast.showToast(
            // msg: 'Lưu đơn hàng thành công',
            msg: CommonUtils.firstLetterUpperCase(state.msg),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.successColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          Navigator.of(context).pop();
        }
        if (state is CreateOrderFail) {
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(state.error),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is ClickButtonSave) {}

        if (state is CreateBuyOrderCubit) {}

        if (state is StartApplyDiscounPromotion) {}

        if (state is ValidateFailShowPopup) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(
                  AppLocalizations.of(context)!.notification.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.blue, // Màu sắc của tiêu đề
                    fontWeight: FontWeight.bold, // Font chữ đậm
                    fontSize: 18.0, // Kích thước chữ
                  ),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CommonUtils.firstLetterUpperCase(state.message),
                      style: const TextStyle(
                        color: Colors.black, // Màu sắc của nội dung
                        fontSize: 16.0, // Kích thước chữ
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            isCheckLiabilities = false;
                            Navigator.of(context).pop();
                            super
                                .context
                                .read<CreateBuyOrderCubit>()
                                .createOrder(
                                  widget.customerId,
                                  widget.customerVisitId,
                                  orderHeader,
                                  summaryOrder,
                                  lstProduct,
                                  lstScheme,
                                  lstDiscount,
                                  isCheckLiabilities,
                                );
                          },
                          child: Text(AppLocalizations.of(context)!.confirm),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }

        // if (state is EventCalculatePromotionSuccess) {
        //   lstScheme = chooseSchemePromotion(state.lstPromotion);
        //   updatePromotionOrder(lstScheme);
        // }
      },
      builder: (context, state) {
        bool isCalculating = state is StartApplyDiscounPromotion;
        
        if (state is LoadingInit) {
          orderHeader = state.orderHeader;
          lstProduct = state.lstProduct;
          //updateProductOrder(lstProduct);
          lstProduct = getProductOrder(lstProduct);
          this
              .context
              .read<CreateBuyOrderCubit>()
              .applyDiscountAndPromotion(widget.customerId, lstProduct);
        }

        if (state is ApplyDiscountAndPromotionSuccess) {
          lstProduct = state.lstProduct;
          lstDiscount = state.lstDiscount;
          lstPromotion = state.lstPromotion;
          updateProductOrder(lstProduct);
          updateDiscountOrder(lstDiscount);
        }

        if (state is EventCalculatePromotionSuccess) {
          lstScheme = chooseSchemePromotion(state.lstPromotion);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            updatePromotionOrder(lstScheme);
          });
        }
        return Stack(
          children: [
            AbsorbPointer(
              absorbing: isCalculating,
              child: OrderContent(context),
            ),
            if (isCalculating)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Vui lòng đợi...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
    //return OrderContent(context);
  }

  void _showAlertPromotionDialog(BuildContext context) {
    // show the dialog
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(multiLang.notification.toUpperCase())),
          content: Text(multiLang.noPromotionsApplyOrder),
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  multiLang.confirm,
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAlertRoseDialog(BuildContext context) {
    // show the dialog
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(multiLang.notification.toUpperCase())),
          content: Text(multiLang.noDiscountsApplyOrder),
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  multiLang.confirm,
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class InformationCell extends StatelessWidget {
  String title1;
  String title2;
  String value1;
  String value2;
  InformationCell({
    Key? key,
    required this.title1,
    required this.title2,
    required this.value1,
    required this.value2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2 - 32;
    double widthTitle = width / 2 + 20;
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(children: [
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: widthTitle,
                  child: Text(
                    title1,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: SizedBox(
                      width: width - widthTitle - 7,
                      child: Text(value1,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black))))
            ],
          ),
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: widthTitle,
                  child: Text(
                    title2,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: SizedBox(
                      width: width - widthTitle,
                      child: Text(value2,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black))))
            ],
          ),
        ),
      ]),
    );
  }
}

class InformationCell1 extends StatelessWidget {
  final String title1;
  final String title2;
  final String value1;
  final List<Resource> value2;
  String selectedTypeOrder;
  InformationCell1(
      {Key? key,
      required this.title1,
      required this.title2,
      required this.value1,
      required this.value2,
      required this.selectedTypeOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2 - 32;
    double widthTitle = width / 2 + 20;

    return Container(
      //padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(children: [
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: widthTitle,
                  child: Text(
                    title1,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: SizedBox(
                    child: Text(value1,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black))),
              )
            ],
          ),
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: widthTitle,
                  child: Text(
                    title2,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),

                // dropdown below..
                child: DropdownButton<String>(
                  value: selectedTypeOrder,
                  items: value2
                      .map<DropdownMenuItem<String>>(
                          (Resource m) => DropdownMenuItem<String>(
                                value: m.resourceCd,
                                child: Text(m.resourceCd ?? ''),
                              ))
                      .toList(),

                  // add extra sugar..
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 42,
                  underline: const SizedBox(),
                  onChanged: (String? value) {
                    selectedTypeOrder = value!;
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class InformationView extends StatefulWidget {
  OrderHeaderDto orderHeader;
  InformationView({
    Key? key,
    required this.orderHeader,
  }) : super(key: key);

  @override
  _InformationViewState createState() => _InformationViewState();
}

class _InformationViewState extends State<InformationView> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2 - 32;
    double widthTitle = width / 2 + 20;
    OrderHeaderDto orderHeader = widget.orderHeader;
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(children: [
        InformationCell(
          title1: multiLang.orderNo,
          title2: multiLang.customerCode,
          value1: orderHeader.orderCd ?? '',
          value2: orderHeader.customerCode ?? '',
        ),
        InformationCell(
          title1: multiLang.salesDate,
          title2: multiLang.customerName,
          value1: orderHeader.orderDate ?? '',
          value2: orderHeader.customerName ?? '',
        ),
        InformationCell(
          title1: multiLang.maxCreditAmount,
          title2: multiLang.currentCreditBalance,
          value1: NumberFormat.currency(locale: 'vi')
              .format(orderHeader.orderDebtLimit ?? 0),
          value2: NumberFormat.currency(locale: 'vi')
              .format(((orderHeader.remainDebtLimit ?? 0)) * -1),
        ),
        Row(children: [
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: widthTitle,
                    child: Text(
                      multiLang.address,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: SizedBox(
                      width: width - widthTitle - 7,
                      child: Text(orderHeader.address ?? '',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black))),
                )
              ],
            ),
          ),
          // SizedBox(
          //   width: width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       SizedBox(
          //           width: widthTitle,
          //           child: Text(
          //             multiLang.orderType,
          //             style: const TextStyle(
          //                 fontSize: 16, fontWeight: FontWeight.bold),
          //           )),
          //       Container(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10)),
          //         child: DropdownButton<String>(
          //           value: orderHeader.selectedTypeOrder,
          //           items: (orderHeader.lstTypeOrder ?? [])
          //               .map<DropdownMenuItem<String>>((Resource m) =>
          //                   DropdownMenuItem<String>(
          //                     value: m.resourceCd,
          //                     child:
          //                         Text(MessageUtils.getMessage(m.value1) ?? ''),
          //                   ))
          //               .toList(),
          //           icon: const Icon(Icons.arrow_drop_down),
          //           iconSize: width * 0.03,
          //           underline: const SizedBox(),
          //           onChanged: (String? value) {
          //             setState(() {
          //               orderHeader.selectedTypeOrder = value;
          //             });
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: widthTitle, // Adjust the width of the title
                  child: Text(
                    multiLang.orderType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Add this line to handle long titles
                  ),
                ),
                SizedBox(
                    width: 10), // Add some space between title and dropdown
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: orderHeader.selectedTypeOrder,
                      items: (orderHeader.lstTypeOrder ?? [])
                          .map<DropdownMenuItem<String>>(
                            (Resource m) => DropdownMenuItem<String>(
                              value: m.resourceCd,
                              child:
                                  Text(MessageUtils.getMessage(m.value1) ?? ''),
                            ),
                          )
                          .toList(),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: width * 0.03,
                      underline: const SizedBox(),
                      onChanged: (String? value) {
                        setState(() {
                          orderHeader.selectedTypeOrder = value;
                        });
                      },
                      // Set dropdown button's width constraint
                      // This ensures it doesn't exceed the available space
                      // Adjust the value as needed
                      isExpanded: true,
                      // Optionally, you can set a maximum height for the dropdown
                      // maxHeight: 200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
        Row(children: [
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: widthTitle,
                    child: Text(
                      multiLang.status,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Checkbox(
                  value: orderHeader.orderStatus,
                  onChanged: (bool? value) {
                    setState(() {
                      orderHeader.orderStatus = value;
                    });
                  },
                ),
                Text(
                  multiLang.draft,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: widthTitle,
                    child: Text(
                      multiLang.planDeliveryDate,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: orderHeader.planShippingDate != null
                          ? DateFormat('yyyy-MM-dd')
                              .parse(orderHeader.planShippingDate!)
                          : DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      locale: const Locale(
                          'vi', 'VN'), // Đặt ngôn ngữ và quốc gia cho lịch
                      initialEntryMode: DatePickerEntryMode
                          .calendar, // Hiển thị lịch lúc mở đầu
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          // Tùy chỉnh chủ đề của lịch
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary:
                                  AppColor.mainAppColor, // Màu chính của lịch
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      // Nếu người dùng đã chọn một ngày, cập nhật selectedDate và hiển thị nó trong văn bản
                      setState(() {
                        orderHeader.planShippingDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    } else {
                      // Nếu người dùng không chọn ngày nào, xóa ngày
                      setState(() {
                        orderHeader.planShippingDate = null;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        orderHeader.planShippingDate != null
                            ? orderHeader.planShippingDate!
                            : multiLang
                                .selectDate, // Hiển thị ngày đã chọn hoặc thông báo "Chọn ngày" nếu chưa có ngày được chọn
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ), // Biểu tượng lịch
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
        GestureDetector(
          onTap: () {
            // Yêu cầu FocusScope để loại bỏ chú ý khỏi TextField
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Row(children: [
            SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: widthTitle,
                      child: Text(
                        multiLang.poNumber,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      onTap: () {
                        // Yêu cầu FocusScope để chú ý vào TextField khi được nhấp vào
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      onChanged: (value) {
                        setState(() {
                          orderHeader.pOnumber = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: orderHeader.pOnumber,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0)),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
      ]),
    );
  }
}

class CustomRoseDialog extends StatelessWidget {
  final double width;
  final double height;
  const CustomRoseDialog({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    double widthTitle = width / 4;
    List<Map<String, dynamic>> columnData = [
      {'title': multiLang.no, 'width': .08},
      {'title': multiLang.discountCode, 'width': .15},
      {'title': multiLang.discountName, 'width': .3},
      {'title': multiLang.fromDate, 'width': .15},
      {'title': multiLang.toDate, 'width': .15},
    ];
    List<Map<String, dynamic>> rowData = [
      {'title': '1', 'width': .08},
      {'title': 'DP000000004', 'width': .15},
      {'title': 'CK26012024', 'width': .2},
      {'title': '26/01/2024', 'width': .15},
      {'title': '31/12/9999', 'width': .15},
    ];
    header(List<Map<String, dynamic>> columnData) {
      return columnData.map((column) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          width: width * column['width'],
          child: Text(
            column['title'],
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }).toList();
    }

    content() {
      return rowData.map((column) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          width: width * column['width'],
          child: column['title'] == 'checkbox'
              ? const Icon(Icons.check_box)
              : Text(
                  column['title'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
        );
      }).toList();
    }

    Widget dialogContent(BuildContext context) {
      AppLocalizations multiLang = AppLocalizations.of(context)!;

      return Container(
        color: Colors.white,
        width: width,
        height: height,
        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: Stack(
          children: <Widget>[
            Container(
              // margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                  color: AppColor.background,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: const Color.fromRGBO(232, 40, 37, 1),
                    height: Contants.heightHeader,
                    child: Center(
                        child: Text(
                      multiLang.discountManagement,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: AppColor.disableBackgroundColor,
                              height: Contants.heightTab,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: header(columnData),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  color: AppColor.disableBackgroundColor
                                      .withOpacity(.4),
                                  height: Contants.heightTab,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      children: content(),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: width,
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16, bottom: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Mua 1 Camel 2 bấm nhận 30.000 đồng',
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.left,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                          height: 1,
                                          thickness: 1,
                                          color:
                                              AppColor.disableBackgroundColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: AppButton(
                        backgroundColor: AppColor.mainAppColor,
                        height: 55,
                        width: width / 3,
                        title: multiLang.select,
                        onPress: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 10,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.close, color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
