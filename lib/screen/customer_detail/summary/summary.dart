import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/summary/cubit/summary_cubit.dart';
import 'package:horeca/screen/customer_detail/summary/cubit/summary_state.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/api_button.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/order_check_out_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_checkout_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummaryScreen extends StatelessWidget {
  int customerVisitId;
  int customerId;
  int customerAddressId;
  String statusVisit;
  SummaryScreen(
      {Key? key,
      required this.customerVisitId,
      required this.customerId,
      required this.customerAddressId,
      required this.statusVisit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SummaryCubit(context)
          ..init(customerVisitId, customerId, customerAddressId),
        child: SummaryBody(
          customerVisitId: customerVisitId,
          customerId: customerId,
          statusVisit: statusVisit,
        ));
  }
}

class SummaryBody extends StatefulWidget {
  // const SummaryBody({super.key});
  int customerId;
  int customerVisitId;
  String statusVisit;
  SummaryBody(
      {Key? key,
      required this.customerVisitId,
      required this.customerId,
      required this.statusVisit})
      : super(key: key);

  @override
  State<SummaryBody> createState() => _SummaryBodyState();
}

class _SummaryBodyState extends State<SummaryBody> {
  CustomerVisit? customerVisit = CustomerVisit();
  List<ProductCheckoutDto> lstProduct = [];
  List<OrderCheckOutDTO> lstOrder = [];
  List<List<String>> rowDataDTC = [];
  List<List<String>> rowDataOrder = [];
  CustomerLiabilities? customerLiabilities = CustomerLiabilities();
  final DatatableController _datatableController = DatatableController(-1);
  final DatatableController _datatableOrderController = DatatableController(-1);

  @override
  void initState() {
    _datatableOrderController.selectIndex.addListener(() {
      if (lstOrder.isNotEmpty) {
        final orderId =
            lstOrder[_datatableOrderController.selectIndex.value].orderId;

        // print('_customerId $customerId');
        if (_datatableOrderController.selectIndex.value != -1 && orderId! > 0) {
          //context.push('/orderdetail', extra: {"id": orderId});
          GoRouter.of(context).push('/orderdetail',
              extra: {"customerId": 0, "customerVisitId": 0, "id": orderId});
        }
        _datatableOrderController.selectIndex.value = -1;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width =
        MediaQuery.of(context).size.width - Contants.widthLeftMenu - 20;
    // print('customer id in summary screen ${widget.customerId}');
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    List<Map<String, dynamic>> columnDataProduct = [
      {'title': multiLang.no, 'width': .05},
      {'title': multiLang.productCode, 'width': .15},
      {'title': multiLang.productName, 'width': .4},
      {'title': multiLang.totalQuantity, 'width': .2},
      {'title': multiLang.totalAmount, 'width': .2}
    ];
    List<Map<String, dynamic>> columnDataOrder = [
      {'title': multiLang.no, 'width': .05},
      {'title': multiLang.orderNo, 'width': .2, 'type': Constant.dataTypeInput},
      {'title': multiLang.deliveryAddress, 'width': .45},
      {'title': multiLang.totalAmount, 'width': .15},
      {'title': multiLang.status, 'width': .15},
    ];

    print('statusVisit ${widget.statusVisit}');
    Widget content(BuildContext context) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  InformationView(
                    customerVisit: customerVisit,
                    lstProduct: lstProduct,
                    lstOrder: lstOrder,
                    customerLiabilities: customerLiabilities,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DatatableWidget(
                      datatableController: _datatableController,
                      columnData: columnDataProduct,
                      rowData: rowDataDTC,
                      width: width),
                  const SizedBox(
                    height: 20,
                  ),
                  DatatableWidget(
                      datatableController: _datatableOrderController,
                      heightHeader: 50,
                      columnData: columnDataOrder,
                      rowData: rowDataOrder,
                      width: width),
                ],
              ),
            ),
          ),
          (widget.statusVisit == '01')
              ? ButtonFinishVisit(customerVisit: customerVisit)
              : const SizedBox()
        ],
      );
    }

    return BlocConsumer<SummaryCubit, SummaryState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Fluttertoast.showToast(
                // msg: 'Kết thúc viếng thăm thành công',
                msg: CommonUtils.firstLetterUpperCase(state.msg),
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
                backgroundColor: AppColor.successColor,
                textColor: Colors.white,
                fontSize: 14.0);
            Navigator.of(context).pop();
          });
        }
        if (state is CheckoutFailed) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Fluttertoast.showToast(
                msg: CommonUtils.firstLetterUpperCase(state.error),
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
                backgroundColor: AppColor.errorColor,
                textColor: Colors.white,
                fontSize: 14.0);
            // Navigator.of(context).pop();
          });
        }
      },
      builder: (context, state) {
        if (state is LoadingInit) {
          customerVisit = state.customerVisit;
          lstProduct = state.lstProduct;
          lstOrder = state.lstOrder;
          customerLiabilities = state.customerLiabilities;
          int indexProduct = 0;
          rowDataDTC = lstProduct.map((product) {
            indexProduct++;
            List<String> result = [];
            result.add(indexProduct.toString());
            result.add(product.productCd ?? '');
            result.add(product.productName ?? '');
            result.add(product.totalQty.toString());
            result.add(NumberFormat.currency(locale: 'vi')
                .format(product.totalAmount));
            return result;
          }).toList();

          int indexOrder = 0;
          rowDataOrder = lstOrder.map((order) {
            indexOrder++;
            List<String> result = [];
            result.add(indexOrder.toString());
            result.add(order.orderCd ?? '');
            result.add(order.fullAddress ?? '');
            result.add(NumberFormat.currency(locale: 'vi')
                .format(order.grandTotalAmount));
            result.add(CodeListUtils.getMessage(
                    Constant.clHorecaSts, order.horecaStatus) ??
                '');
            return result;
          }).toList();
        }

        return content(context);
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
    double width =
        (MediaQuery.of(context).size.width - Contants.widthLeftMenu) / 2 - 64;
    double widthTitle = width / 2 + 40;
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
              Text(value1)
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
              Text(value2)
            ],
          ),
        ),
      ]),
    );
  }
}

class InformationView extends StatelessWidget {
  CustomerVisit? customerVisit;
  List<ProductCheckoutDto> lstProduct;
  List<OrderCheckOutDTO> lstOrder;
  CustomerLiabilities? customerLiabilities;

  InformationView(
      {required this.customerVisit,
      required this.lstProduct,
      required this.lstOrder,
      required this.customerLiabilities,
      super.key});

  double countProduct(List<ProductCheckoutDto> lstProduct) {
    return lstProduct.fold<double>(0, (previousValue, product) {
      return previousValue + (product.totalQty ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Column(children: [
        InformationCell(
          title1: multiLang.startTime,
          title2: multiLang.endTime,
          value1: CommonUtils.convertDate(
              customerVisit?.startTime, Constant.dateFormatterYYYYMMDDHHMM),
          value2: CommonUtils.convertDate(
              customerVisit?.endTime, Constant.dateFormatterYYYYMMDDHHMM),
        ),
        InformationCell(
          title1: multiLang.debtLimit,
          title2: multiLang.availableDebt,
          value1: NumberFormat.currency(locale: 'vi')
              .format(customerLiabilities?.orderDebtLimit ?? 0),
          value2: NumberFormat.currency(locale: 'vi')
              .format((customerLiabilities?.remainDebtLimit ?? 0) * (-1)),
        ),
        InformationCell(
          title1: multiLang.totalProductPurchase,
          title2: multiLang.totalOrderAmount,
          value1: countProduct(lstProduct).toInt().toString(),
          value2: NumberFormat.currency(locale: 'vi').format(lstOrder.fold(
              0.0,
              (previousValue, element) =>
                  previousValue + (element.grandTotalAmount ?? 0))),
        ),
      ]),
    );
  }
}

class ButtonFinishVisit extends StatelessWidget {
  CustomerVisit? customerVisit;
  ButtonFinishVisit({required this.customerVisit, super.key});
  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: ApiButton(
            apiKey: 'endVisit_${customerVisit?.customerVisitId}',
            text: multiLang.endVisit,
            backgroundColor: AppColor.mainAppColor,
            height: 55,
            width: MediaQuery.of(context).size.width / 2 - 50,
            cooldownDuration: Duration(seconds: 3),
            onPressed: () async {
              context.read<SummaryCubit>().clickButtonChangeState();
              await context.read<SummaryCubit>().checkout(customerVisit);
            },
          ),
        ));
  }
}
