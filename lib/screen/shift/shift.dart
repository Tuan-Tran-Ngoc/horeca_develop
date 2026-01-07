import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/contants/contants.dart';

import 'package:horeca/screen/shift/cubit/shift_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/shift_report.dart';
import 'package:horeca_service/sqflite_database/dto/shift_header_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/datatable.dart';

class ShiftScreen extends StatelessWidget {
  const ShiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShiftCubit(context)..init(),
      child: const ShiftBody(),
    );
  }
}

class ShiftBody extends StatefulWidget {
  const ShiftBody({super.key});

  @override
  State<ShiftBody> createState() => _ShiftBodyState();
}

class _ShiftBodyState extends State<ShiftBody> {
  List<ListOrderInShift> lstOrder = [];
  List<List<String>> rowDataNull = [];
  List<List<String>> rowDataProducts = [];
  List<List<String>> rowDataOrders = [];
  final DatatableController _datatableController = DatatableController(-1);
  final DatatableController _datatableOrderController = DatatableController(-1);
  ShiftReport? shiftReport;
  ShiftReportHeaderDTO? shiftReportHeader;
  bool isReloadControl = false;

  @override
  void initState() {
    _datatableOrderController.selectIndex.addListener(() {
      if (lstOrder.isNotEmpty) {
        final orderId =
            lstOrder[_datatableOrderController.selectIndex.value].orderId;
        if (_datatableOrderController.selectIndex.value != -1 && orderId! > 0) {
          context.push('/orderdetail',
              extra: {"customerId": 0, "customerVisitId": 0, "id": orderId});
        }
        _datatableOrderController.selectIndex.value = -1;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    List<Map<String, dynamic>> columnProducts = [
      {'title': multiLang.no, 'width': .1},
      {'title': multiLang.productCode, 'width': .15},
      {'title': multiLang.productName, 'width': .4},
      {'title': multiLang.totalQuantity, 'width': .12},
      {'title': multiLang.totalAmount, 'width': .15},
    ];
    List<Map<String, dynamic>> columnOrders = [
      {'title': multiLang.no, 'width': .05},
      {
        'title': multiLang.orderNo,
        'width': .15,
        'type': Constant.dataTypeInput
      },
      {'title': multiLang.customerName, 'width': .2},
      {'title': multiLang.deliveryAddress, 'width': .3},
      {'title': multiLang.totalAmount, 'width': .15},
      {'title': multiLang.status, 'width': .15}
    ];

    return BlocConsumer<ShiftCubit, ShiftState>(
      listener: (context, state) {
        if (state is EndShiftSucces) {
          if (isReloadControl) {
            isReloadControl = false;
            Navigator.pop(context);
          }

          String messageTemp = [multiLang.endShift, multiLang.failed].join(" ");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Fluttertoast.showToast(
              msg: CommonUtils.firstLetterUpperCase(state.msg ?? messageTemp),
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.successColor,
              textColor: Colors.white,
              fontSize: 14.0,
            );

            Navigator.of(context).pop();
          });
        }
        if (state is EndShiftFailed) {
          if (isReloadControl) {
            isReloadControl = false;
            Navigator.pop(context);
          }

          String messageTemp = [multiLang.endShift, multiLang.failed].join(" ");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Fluttertoast.showToast(
              msg: CommonUtils.firstLetterUpperCase(
                  state.error.toString() ?? messageTemp),
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.errorColor,
              textColor: Colors.white,
              fontSize: 14.0,
            );
          });
        }
      },
      builder: (context, state) {
        if (state is ReloadControl) {
          isReloadControl = true;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialog(
              context: context,
              barrierDismissible:
                  false, // prevent user from dismissing the dialog
              builder: (BuildContext context) {
                return const SpinKitCircle(
                  color: Colors.blue,
                  size: 50.0,
                );
              },
            );
          });
        }

        if (state is ShiftInitSuccess) {
          lstOrder = state.listOrderInShift;
          rowDataOrders = state.rowDataOrders;
          rowDataProducts = state.rowDataProducts;
          shiftReport = state.shiftReport;
          shiftReportHeader = state.shiftReportHeader;
        }
        return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.mainAppColor,
              title: Center(
                  child: Text(
                multiLang
                    .workShift(shiftReportHeader?.workingDate ?? '')
                    .toUpperCase(),
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
            body: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      InformationView(
                        shiftReportHeader: shiftReportHeader,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DatatableWidget(
                        datatableController: _datatableController,
                        columnData: columnProducts,
                        rowData: rowDataProducts,
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DatatableWidget(
                        datatableController: _datatableOrderController,
                        columnData: columnOrders,
                        rowData: rowDataOrders,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
              ),
              ButtonEndShift(shiftReport: shiftReport)
            ]));
      },
    );
  }
}

class ButtonEndShift extends StatelessWidget {
  const ButtonEndShift({
    super.key,
    required this.shiftReport,
  });

  final ShiftReport? shiftReport;

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppButton(
            backgroundColor: AppColor.mainAppColor,
            // height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width / 2 - 50,
            height: Contants.heightButton,
            title: multiLang.finishShift,
            onPress: () {
              context.read<ShiftCubit>().endShift(shiftReport);
            },
          ),
        ));
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
  ShiftReportHeaderDTO? shiftReportHeader;
  InformationView({
    Key? key,
    required this.shiftReportHeader,
  }) : super(key: key);

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
              shiftReportHeader?.startTime, Constant.dateFormatterYYYYMMDDHHMM),
          value2: CommonUtils.convertDate(
              shiftReportHeader?.endTime, Constant.dateFormatterYYYYMMDDHHMM),
        ),
        InformationCell(
          title1: multiLang.numberVisitor,
          title2: multiLang.numberCancelVisitor,
          value1:
              '${shiftReportHeader?.visitedQuantity ?? 0}/${shiftReportHeader?.visitPlanQuantity ?? 0}',
          value2:
              '${shiftReportHeader?.cancelledQuantity ?? 0}/${shiftReportHeader?.visitPlanQuantity ?? 0}',
        ),
        InformationCell(
          title1: multiLang.numberOfflineVisitor,
          title2: multiLang.totalOrderShift,
          value1: shiftReportHeader?.customerOffline?.toString() ?? '0',
          value2: shiftReportHeader?.totalOrderQuantity?.toString() ?? '0',
        ),
        InformationCell(
          title1: multiLang.totalProductPurchase,
          title2: multiLang.totalOrderAmount,
          value1: shiftReportHeader?.totalProductQuantity.toString() ?? '',
          value2: CommonUtils.formatCurrency(
              shiftReportHeader?.totalOrderAmount ?? 0),
        ),
      ]),
    );
  }
}
