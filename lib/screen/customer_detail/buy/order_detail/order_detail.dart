import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/buy/order/create_buy_order.dart';
import 'package:horeca/screen/customer_detail/buy/order_detail/cubit/order_detail_cubit.dart';
import 'package:horeca/screen/customer_detail/buy/order_detail/generate_pdf_order_detail.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca/widgets/text_field.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/discount_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/dto/order_header_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_dto.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderDetailScreen extends StatelessWidget {
  final int customerId;
  final int customerVisitId;
  final int orderId;
  const OrderDetailScreen(
      {Key? key,
      required this.customerId,
      required this.customerVisitId,
      required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailCubit()..init(orderId),
      child: OrderDetailBody(
        customerId: customerId,
        customerVisitId: customerVisitId,
        orderId: orderId,
      ),
    );
  }
}

class OrderDetailBody extends StatefulWidget {
  final int? customerId;
  final int? customerVisitId;
  final int orderId;
  const OrderDetailBody(
      {Key? key,
      required this.customerId,
      required this.customerVisitId,
      required this.orderId})
      : super(key: key);

  @override
  State<OrderDetailBody> createState() => _OrderDetailBodyState();
}

class _OrderDetailBodyState extends State<OrderDetailBody> {
  List<List<String>> rowDataNull = [];
  final DatatableController _datatableController = DatatableController(-1);

  List<ProductDto> lstAllProduct = [];
  List<SapOrderDtl> lstProduct = [];
  List<List<String>> rowDataProduct = [];
  List<SchemeDto> lstPromotionOrder = [];
  List<List<String>> rowDataPromotion = [];
  List<DiscountResultOrderDto> lstDiscountOrder = [];
  List<List<String>> rowDataDiscount = [];
  List<SapOrderDelivery> lstSapOrderDelivery = [];
  List<List<String>> rowDataStatusDelivery = [];
  OrderHeaderDto orderHeader = OrderHeaderDto();
  TextEditingController controller = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;

    List<ProductDto> getProductOrder(List<ProductDto> lstProduct) {
      return lstProduct.where((product) => product.quantity! > 0).toList();
    }

    void updateProductOrder(List<SapOrderDtl> lstProduct) {
      int index = 0;
      double totalQuantity = 0;
      rowDataProduct = lstProduct.map((product) {
        index++;
        List<String> result = [];

        // Calculate total quantity
        totalQuantity = totalQuantity + (product.qty ?? 0);

        // setting product order detail
        result.add(index.toString());
        result.add(product.productName ?? '');
        //result.add(product.productName ?? '');
        result.add(NumberFormat.decimalPattern().format(product.qty ?? 0));
        result
            .add(NumberFormat.decimalPattern().format(product.shippedQty ?? 0));
        result.add(product.unit ?? '');
        result.add(CommonUtils.displayCurrency(product.unitPrice ?? 0));
        result.add(
            CommonUtils.displayCurrency(product.unitPriceAfterDiscount ?? 0));
        result.add(CommonUtils.displayCurrency(product.netValue ?? 0));

        return result;
      }).toList();
      
      // Store total quantity in orderHeader
      orderHeader.totalQuantity = totalQuantity;
    }

    void updatePromotionOrder(List<SchemeDto> lstPromotion) {
      int index = 0;
      rowDataPromotion = lstPromotion.map((promotion) {
        index++;
        List<String> result = [];

        // setting product order detail
        result.add(index.toString());
        result.add(promotion.productName ?? '');
        result.add(NumberFormat.decimalPattern().format(promotion.resultQty));
        result.add(promotion.schemeContent ?? '');

        return result;
      }).toList();
    }

    void updateDiscountOrder(List<DiscountResultOrderDto> lstDiscount) {
      int index = 0;
      rowDataDiscount = lstDiscount.map((discount) {
        index++;
        List<String> result = [];

        // setting product order detail
        result.add(index.toString());
        result.add(CodeListUtils.getMessage(
                'cl.discount.type', discount.conditionType) ??
            '');
        result.add(CommonUtils.displayCurrency(discount.totalDiscount));
        result.add(discount.remark ?? '');

        return result;
      }).toList();
    }

    void updateSapOrderDelivery(List<SapOrderDelivery> lstSapOrderDelivery) {
      int index = 0;
      rowDataStatusDelivery = lstSapOrderDelivery.map((delivery) {
        index++;
        List<String> result = [];

        result.add(index.toString());
        result.add(delivery.deliveryNo ?? '');
        result.add(CommonUtils.convertDate(
            delivery.deliveryDate, Constant.dateFormatterYYYYMMDD));
        result.add(delivery.deliveryStatus ?? '');
        result.add(delivery.truckId ?? '');
        result.add(delivery.remark ?? '');

        return result;
      }).toList();
    }

    Widget OrderContent(BuildContext context) {
      List<Map<String, dynamic>> columnDataProduct = [
        {'title': multiLang.no, 'width': .05},
        {'title': multiLang.productName, 'width': .15},
        {'title': multiLang.orderedQuantity, 'width': .1},
        {'title': multiLang.confirmedQuantity, 'width': .1},
        {'title': multiLang.unit, 'width': .1},
        {'title': multiLang.unitPriceBeforeVAT, 'width': .15},
        //{'title': 'Tỉ lệ chiết khấu', 'width': .15},
        {'title': multiLang.discountUnitPrice, 'width': .1},
        {'title': multiLang.total, 'width': .1}
      ];

      List<Map<String, dynamic>> columnDataPromotion = [
        {'title': multiLang.no, 'width': .1},
        {'title': multiLang.promotionalProduct, 'width': .3},
        {'title': multiLang.quantity, 'width': .12},
        {'title': multiLang.note, 'width': .4},
      ];

      List<Map<String, dynamic>> columnDataDiscount = [
        {'title': multiLang.no, 'width': .1},
        {'title': multiLang.type, 'width': .2},
        {'title': multiLang.totalDiscount, 'width': .2},
        {'title': multiLang.note, 'width': .4},
      ];

      List<Map<String, dynamic>> columnDataStatusDelivery = [
        {'title': multiLang.no, 'width': .05},
        {'title': multiLang.shippingCode, 'width': .18},
        {'title': multiLang.deliveryDate, 'width': .18},
        {'title': multiLang.shippingStatus, 'width': .18},
        {'title': multiLang.truckCode, 'width': .12},
        {'title': multiLang.note, 'width': .22},
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
              (widget.customerVisitId == 0)
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () async {
                          // Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => CreateBuyOrderScreen(
                              customerId: widget.customerId ?? 0,
                              customerVisitId: widget.customerVisitId ?? 0,
                              orderIdCopy: widget.orderId,
                            ),
                          ))
                              .then((result) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: SizedBox(
                            height: 24,
                            width: 24,
                            child:
                                Image.asset('assets/icons_app/copy-icon.png')),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () async {
                    // Navigator.of(context).pop();
                    print('click icon pdf');
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async {
                      GeneratePdfOrderDetail generatePdfOrder =
                          GeneratePdfOrderDetail(
                              context: context,
                              format: format,
                              orderHeader: orderHeader,
                              lstProduct: lstProduct,
                              lstPromotion: lstPromotionOrder,
                              lstDiscount: lstDiscountOrder);
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
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset('assets/icons_app/back.png')),
                ),
              ),
            ],
          ),
          body: Stack(children: [
            Column(
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
                            ],
                          ),
                        ),
                        DatatableWidget(
                          datatableController: _datatableController,
                          columnData: columnDataProduct,
                          rowData: rowDataProduct,
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
                                    multiLang.listOf(multiLang.promotion)),
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
                          columnData: columnDataDiscount,
                          rowData: rowDataDiscount,
                          width: width,
                        ),
                        const SizedBox(
                          height: Contants.spacingRow16,
                        ),
                        Container(
                          height: Contants.heightHeader,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: AppColor.mainAppColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                multiLang.shippingStatus,
                                style: const TextStyle(
                                    color: AppColor.background,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        DatatableWidget(
                          datatableController: _datatableController,
                          columnData: columnDataStatusDelivery,
                          rowData: rowDataStatusDelivery,
                          width: width,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: Contants.spacingRow10,
                                      ),
                                      SizedBox(
                                          height: 40,
                                          child: Text(multiLang.note)),
                                      AppTextField(
                                        maxLine: 8,
                                        enable: false,
                                        controller: controller,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 32),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    31, 220, 220, 220)
                                                .withOpacity(0.5),
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                      multiLang
                                                          .totalQuantityProduct,
                                                      textAlign:
                                                          TextAlign.right,
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
                                                      .format(orderHeader
                                                              .totalQuantity ??
                                                          0),
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
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                const SizedBox(
                                                  width: Contants.spacingRow10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  CommonUtils.displayCurrency(
                                                      orderHeader.totalAmount),
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
                                                      multiLang.totalDiscount,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                const SizedBox(
                                                  width: Contants.spacingRow10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  CommonUtils.displayCurrency(
                                                      orderHeader
                                                              .discountAmount ??
                                                          0),
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
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                const SizedBox(
                                                  width: Contants.spacingRow10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  CommonUtils.displayCurrency(
                                                      orderHeader
                                                              .promotionAmount ??
                                                          0),
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
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                const SizedBox(
                                                  width: Contants.spacingRow10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  CommonUtils.displayCurrency(
                                                      orderHeader.vatAmount ??
                                                          0),
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
                                                          .grandTotalAmount,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                const SizedBox(
                                                  width: Contants.spacingRow10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  CommonUtils.displayCurrency(
                                                      orderHeader
                                                              .grandTotalAmount ??
                                                          0),
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
              ],
            ),
          ]));
    }

    return BlocConsumer<OrderDetailCubit, OrderDetailState>(
      listener: (context, state) {
        if (state is LoadingInit) {
          orderHeader = state.orderHeader;
          lstProduct = state.lstProduct;
          lstPromotionOrder = state.lstPromotionOrder;
          lstDiscountOrder = state.lstDiscountOrder;
          lstSapOrderDelivery = state.lstSapOrderDelivery;
          controller = TextEditingController(text: orderHeader.remark);
          updateProductOrder(lstProduct);
          updatePromotionOrder(lstPromotionOrder);
          updateDiscountOrder(lstDiscountOrder);
          updateSapOrderDelivery(lstSapOrderDelivery);
        }
      },
      builder: (context, state) {
        return OrderContent(context);
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
    double widthTitle = width / 3;
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
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: SizedBox(
                    width: width - widthTitle - 7,
                    child: Text(value2,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black))),
              )
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
    OrderHeaderDto orderHeader = widget.orderHeader;
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32),
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
          value1: CommonUtils.convertDate(
              orderHeader.orderDate, Constant.dateFormatterYYYYMMDD),
          value2: orderHeader.customerName ?? '',
        ),
        InformationCell(
          title1: multiLang.address,
          title2: multiLang.orderType,
          value1: orderHeader.address ?? '',
          value2: CodeListUtils.getMessage(
                  Constant.clTypeOrder, orderHeader.selectedTypeOrder) ??
              '',
        ),
        InformationCell(
          title1: multiLang.status,
          title2: multiLang.planDeliveryDate,
          value1: CodeListUtils.getMessage(
                  Constant.clHorecaSts, orderHeader.horecaStatus) ??
              '',
          value2: CommonUtils.convertDate(
              orderHeader.planShippingDate, Constant.dateFormatterYYYYMMDD),
        ),
        InformationCell(
          title1: multiLang.poNumber,
          title2: '',
          value1: orderHeader.pOnumber ?? '',
          value2: '',
        ),
      ]),
    );
  }
}
