import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/buy/main/cubit/buy_cubit.dart';
import 'package:horeca/screen/customer_detail/buy/order/create_buy_order.dart';
import 'package:horeca/screen/customer_detail/buy/order_detail/order_detail.dart';
import 'package:horeca/screen/survey/survey.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca_service/model/shift_report.dart';
import 'package:horeca_service/sqflite_database/dto/survey_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuyScreen extends StatelessWidget {
  int customerId;
  int customerVisitId;
  String statusVisit;
  BuyScreen({
    Key? key,
    required this.customerId,
    required this.customerVisitId,
    required this.statusVisit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyCubit()..init(customerId, customerVisitId),
      child: BuyBody(
        customerId: customerId,
        customerVisitId: customerVisitId,
        statusVisit: statusVisit,
      ),
    );
  }
}

class BuyBody extends StatefulWidget {
  int customerId;
  int customerVisitId;
  String statusVisit;
  BuyBody(
      {Key? key,
      required this.customerId,
      required this.customerVisitId,
      required this.statusVisit})
      : super(key: key);

  @override
  State<BuyBody> createState() => _BuyBodyState();
}

class _BuyBodyState extends State<BuyBody> {
  bool isLoadingScreen = false;
  bool isLoadingItems = false;

  final DatatableController _datatableOrderController = DatatableController(-1);
  final ValueNotifier<int> _selectOrderIndex = ValueNotifier(0);
  final DatatableController _datatableSurveyController =
      DatatableController(-1);
  final ValueNotifier<int> _selectSurveyIndex = ValueNotifier(0);

  @override
  void initState() {
    _datatableOrderController.selectIndex.addListener(() {
      print(
          '_selectOrderIndex $_selectOrderIndex ${_datatableOrderController.selectIndex.value}');
      if (lstOrder.isNotEmpty) {
        final orderId =
            lstOrder[_datatableOrderController.selectIndex.value].orderId;

        // print('_customerId $customerId');
        if (_datatableOrderController.selectIndex.value != -1 && orderId! > 0) {
          // context.push('/orderdetail', extra: {
          //   "customerId": customerId,
          //   "customerVisitId": customerVisitId,
          //   "id": orderId
          // });

          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              customerId: customerId,
              customerVisitId: (widget.statusVisit == Constant.visiting)
                  ? customerVisitId
                  : 0,
              orderId: orderId,
            ),
          ))
              .then((result) {
            context.read<BuyCubit>().init(customerId, customerVisitId);
          });
        }
        _datatableOrderController.selectIndex.value = -1;
      }
    });

    _datatableSurveyController.selectIndex.addListener(() {
      print(
          '_selectSurveyIndex $_selectSurveyIndex ${_datatableSurveyController.selectIndex.value}');
      if (lstSurvey.isNotEmpty) {
        final surveyId =
            lstSurvey[_datatableSurveyController.selectIndex.value].surveyId;
        if (_datatableSurveyController.selectIndex.value != -1) {
          // context.push('/survey', extra: {
          //   "surveyId": surveyId,
          //   "customerVisitId": widget.customerVisitId
          // });
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => SurveyScreen(
              surveyId: surveyId ?? 0,
              customerVisitId: widget.customerVisitId,
            ),
          ))
              .then((result) {
            context
                .read<BuyCubit>()
                .init(widget.customerId, widget.customerVisitId);
          });
        }
        _datatableSurveyController.selectIndex.value = -1;
      }
    });
    super.initState();
  }

  int currentIndex = 0;
  bool isSelectCustomer = false;
  List<ListOrderInShift> lstOrder = [];
  List<List<String>> lstOrderStr = [];
  List<SurveyDto> lstSurvey = [];
  List<List<String>> lstSurveyStr = [];
  late int customerId;
  late int customerVisitId;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width =
        MediaQuery.of(context).size.width - Contants.widthLeftMenu;

    print(
        'Buy<->customerId ${widget.customerId}<->customerVisitId ${widget.customerVisitId}');
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    List<Map<String, dynamic>> columnOrder = [
      {'title': multiLang.no, 'width': .05},
      {
        'title': multiLang.orderNo,
        'width': .23,
        'type': Constant.dataTypeInput
      },
      {'title': multiLang.deliveryAddress, 'width': .3},
      {'title': multiLang.salesDate, 'width': .12},
      {'title': multiLang.totalAmount, 'width': .15},
      {'title': multiLang.status, 'width': .15},
    ];

    List<Map<String, dynamic>> columnSurvey = [
      {'title': multiLang.no, 'width': .08},
      {
        'title': multiLang.surverProgram,
        'width': .4,
        'type': Constant.dataTypeInput
      },
      {'title': multiLang.fromDate, 'width': .12},
      {'title': multiLang.toDate, 'width': .12},
      {'title': multiLang.surveryed, 'width': .12},
    ];

    List<String> listTab = [
      CommonUtils.firstLetterUpperCase(multiLang.listOf(multiLang.order)),
      multiLang.survey
    ];

    void updateLstOrder(List<ListOrderInShift> lstOrder) {
      int index = 0;
      lstOrderStr = lstOrder.map((data) {
        index++;
        List<String> result = [];
        result.add(index.toString());
        result.add(data.orderCd.toString());
        result.add(data.fullAddress ?? '');
        result.add(CommonUtils.convertDate(
            data.orderDate.toString(), Constant.dateFormatterDDMMYYYY));

        result.add(CommonUtils.displayCurrency(data.grandTotalAmount ?? 0));

        result.add(
            CodeListUtils.getMessage(Constant.clHorecaSts, data.horecaStatus) ??
                '');
        return result;
      }).toList();
    }

    void updateLstSurvey(List<SurveyDto> lstSurvey) {
      int index = 0;
      lstSurveyStr = lstSurvey.map((mSurvey) {
        index++;
        List<String> result = [];
        result.add(index.toString());
        result.add(mSurvey.surveyCode ?? '');
        result.add(mSurvey.startDate ?? '');
        result.add(mSurvey.endDate ?? '');
        if (mSurvey.isComplete != null && (mSurvey.isComplete ?? 0) > 0) {
          result.add('Đã hoàn thành');
        } else {
          result.add('Chưa hoàn thành');
        }
        // result.add((m));
        return result;
      }).toList();
    }

    return BlocConsumer<BuyCubit, BuyState>(
      listener: (context, state) {
        if (state is OnClickSearch) {}

        if (state is StartInitialData) {}
        if (state is SearchCondtionSuccess) {
          lstOrder = state.lstOrder;
          updateLstOrder(lstOrder);
        }
      },
      builder: (context, state) {
        // if (state is LoadingInit) {
        //   isLoadingScreen = true;
        // }
        if (state is LoadingItem) {
          isLoadingItems = true;
        }
        if (state is ChangeTabSuccess) {
          isLoadingItems = false;
          currentIndex = state.index;
          isSelectCustomer = false;
        }
        if (state is SelectCustomerSuccess) {
          isLoadingItems = false;
          isSelectCustomer = state.value;
        }
        if (state is BuyInitialSuccess) {
          lstOrder = state.lstOrder;
          lstSurvey = state.lstSurvey;
          customerId = widget.customerId;
          customerVisitId = widget.customerVisitId;
          updateLstOrder(lstOrder);
          updateLstSurvey(lstSurvey);
        }

        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: Contants.heightTab,
                child: Row(
                  children: listTab.map((e) {
                    return InkWell(
                      onTap: () {
                        context.read<BuyCubit>().changeTab(listTab.indexOf(e));
                      },
                      child: SizedBox(
                        width: width / listTab.length,
                        height: Contants.heightTab,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 10),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 5,
                              color: currentIndex == listTab.indexOf(e)
                                  ? AppColor.mainAppColor
                                  : AppColor.transparent,
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: currentIndex == 0
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Row(
                                children: [
                                  Text(
                                    multiLang.product,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 300,
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),
                                        border: const OutlineInputBorder(),
                                        hintText:
                                            multiLang.enterKeyWordForSearching,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      String searchTerm =
                                          _searchController.text;
                                      context
                                          .read<BuyCubit>()
                                          .searchOrderCondition(
                                              widget.customerId, searchTerm);
                                    },
                                    icon: const Icon(Icons.search),
                                  )
                                ],
                              ),
                            ),
                            DatatableWidget(
                              datatableController: _datatableOrderController,
                              columnData: columnOrder,
                              rowData: lstOrderStr,
                              width: width,
                            ),
                          ],
                        ),
                      )
                    : DatatableWidget(
                        datatableController: _datatableSurveyController,
                        columnData: columnSurvey,
                        rowData: lstSurveyStr,
                        width: width,
                      ),
              ),
              if (widget.statusVisit == Constant.visiting)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: isSelectCustomer || currentIndex == 0
                          ? AppButton(
                              backgroundColor: AppColor.mainAppColor,
                              height: 55,
                              width: width / 3,
                              title: CommonUtils.firstLetterUpperCase([
                                multiLang.addNew,
                                multiLang.order
                              ].join(" ")),
                              onPress: () async {
                                if (!(await CommonUtils.checkShiftForToday())) {
                                  Fluttertoast.showToast(
                                    msg: CommonUtils.firstLetterUpperCase(
                                        multiLang.mandatoryFinishShift),
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb:
                                        Constant.SHOW_TOAST_TIME,
                                    backgroundColor: AppColor.errorColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0,
                                  );
                                } else {
                                  if (!mounted) return;
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => CreateBuyOrderScreen(
                                      customerId: widget.customerId,
                                      customerVisitId: widget.customerVisitId,
                                    ),
                                  ))
                                      .then((result) {
                                    context.read<BuyCubit>().init(
                                        widget.customerId,
                                        widget.customerVisitId);
                                  });
                                }
                              },
                            )
                          : SizedBox(
                              width: width / 4.8,
                            ),
                    ),
                  ],
                )
              else
                const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
