// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer/cubit_customer/customer_cubit.dart';
import 'package:horeca/screen/customer/customer_detail.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca_service/sqflite_database/dto/shift_visit_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerCubit(context)..init(),
      child: const CustomerBody(),
    );
  }
}

class CustomerBody extends StatefulWidget {
  const CustomerBody({super.key});

  @override
  State<CustomerBody> createState() => _CustomerBodyState();
}

class _CustomerBodyState extends State<CustomerBody> {
  final DatatableController _datatableController = DatatableController(-1);
  List<List<String>> rowDataCustomerVisit = [];
  List<ShiftVisitDto> listCustomerVisit = [];
  List<String> daysOfWeek = [];
  List<String> lstShiftName = [];
  List<int> lstIndDays = [];
  List<int> lstIndShift = [];
  List<int> lstInitialDays = [];
  List<int> lstInitialShift = [];

  String customerName = '';

  final ValueNotifier<int> _selectIndex = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _datatableController.selectIndex.addListener(() {
      print(
          '_selectIndex $_selectIndex ${_datatableController.selectIndex.value}');
      if (listCustomerVisit.isNotEmpty) {
        final customerId =
            listCustomerVisit[_datatableController.selectIndex.value]
                .customerId;
        final customerVisitId =
            listCustomerVisit[_datatableController.selectIndex.value]
                .customerVisitId;
        final routeId =
            listCustomerVisit[_datatableController.selectIndex.value].routeId;
        print('_customerId $customerId');
        if (_datatableController.selectIndex.value != -1) {
          // context.push('/customerdetail', extra: {
          //   'customerId': customerId ?? 0,
          //   "customerVisitId": customerVisitId ?? 0
          // });
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => CustomerDetailScreen(
              routeId: routeId ?? 0,
              customerId: customerId ?? 0,
              customerVisitId: customerVisitId ?? 0,
            ),
          ))
              .then((result) {
            print('back to back');
            context.read<CustomerCubit>().reload();
          });
        }

        _datatableController.selectIndex.value = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> columnDataCustomerVisit = [
      {'title': multiLang.no, 'width': .05},
      {'title': multiLang.customerCode, 'width': .1},
      {'title': multiLang.customerName, 'width': .18},
      {'title': multiLang.shift, 'width': .15},
      {'title': multiLang.visitDate, 'width': .1},
      {'title': multiLang.startVisit, 'width': .15},
      {'title': multiLang.endVisit, 'width': .15},
      {'title': multiLang.numberOfVisits, 'width': .05},
    ];

    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is StartSearchRouteAssign) {}
        if (state is SearchRouteAssignSuccess) {
          rowDataCustomerVisit = state.rowDataShiftVisit;
          listCustomerVisit = state.listShiftVisit;
        }
      },
      builder: (context, state) {
        if (state is CustomerInitSuccess) {
          rowDataCustomerVisit = state.rowDataShiftVisit;
          listCustomerVisit = state.listShiftVisit;
          daysOfWeek = state.daysOfWeek;
          lstShiftName = state.lstShiftName;
          lstIndDays = state.lstChooseDay;
          lstIndShift = state.lstChooseShift;
          lstInitialDays = List.from(state.lstChooseDay);
          lstInitialShift = List.from(state.lstChooseShift);
          print('CustomerInitSuccess');
        }

        if (state is StartReload) {}

        if (state is ReloadSuccess) {
          rowDataCustomerVisit = state.rowDataShiftVisit;
          listCustomerVisit = state.listShiftVisit;
          daysOfWeek = state.daysOfWeek;
          lstShiftName = state.lstShiftName;
          lstIndDays = state.lstChooseDay;
          lstIndShift = state.lstChooseShift;
          lstInitialDays = List.from(state.lstChooseDay);
          lstInitialShift = List.from(state.lstChooseShift);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.mainAppColor,
            title: Center(
                child: Text(
              CommonUtils.firstLetterUpperCase(
                  multiLang.listOf(multiLang.customer))
              //  multiLang
              // .listOf( multiLang.customer)
              ,
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
              PopupMenuButton(
                  offset: const Offset(0, 52),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(
                      minWidth: 380, maxWidth: 380, maxHeight: 340),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            height: 0,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: PopupFilter(
                              daysOfWeek: daysOfWeek,
                              lstShiftName: lstShiftName,
                              lstDayInititalVisit: lstInitialDays,
                              lstIndDaysOfWeek: lstIndDays,
                              lstShiftInititalVisit: lstInitialShift,
                              lstIndShiftName: lstIndShift,
                              onResult: (customerName, days, shift) {
                                customerName = customerName;
                                lstIndDays = days;
                                lstIndShift = shift;
                                Navigator.of(context).pop();
                                print('days $days');
                                print('shift $shift');
                                context
                                    .read<CustomerCubit>()
                                    .searchPlanRouteAssignment(
                                        customerName, lstIndDays, lstIndShift);
                              },
                            ))
                      ],
                  child: const Icon(
                    Icons.filter_alt_outlined,
                    size: 30,
                  )),
              const SizedBox(
                width: 10,
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
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: DatatableWidget(
                    datatableController: _datatableController,
                    columnData: columnDataCustomerVisit,
                    rowData: rowDataCustomerVisit,
                    width: width,
                    colorRow: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PopupFilter extends StatefulWidget {
  List<String> daysOfWeek;
  List<String> lstShiftName;
  List<int> lstDayInititalVisit;
  List<int> lstIndDaysOfWeek;
  List<int> lstShiftInititalVisit;
  List<int> lstIndShiftName;
  void Function(String, List<int>, List<int>) onResult;

  PopupFilter(
      {Key? key,
      required this.daysOfWeek,
      required this.lstShiftName,
      required this.lstDayInititalVisit,
      required this.lstIndDaysOfWeek,
      required this.lstShiftInititalVisit,
      required this.lstIndShiftName,
      required this.onResult})
      : super(key: key);

  @override
  _OptionFiterState createState() => _OptionFiterState();
}

class _OptionFiterState extends State<PopupFilter> {
  late List<String> daysOfWeek;
  late List<String> lstShiftName;
  late List<int> lstIndDaysOfWeek;
  late List<int> lstDayInititalVisit;
  late List<int> lstIndShiftName;
  late List<int> lstShiftInititalVisit;
  late void Function(String, List<int>, List<int>) onResult;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    daysOfWeek = widget.daysOfWeek;
    lstShiftName = widget.lstShiftName;
    lstIndDaysOfWeek = widget.lstIndDaysOfWeek;
    lstDayInititalVisit = widget.lstDayInititalVisit;
    lstIndShiftName = widget.lstIndShiftName;
    lstShiftInititalVisit = widget.lstShiftInititalVisit;
    onResult = widget.onResult;
  }

  @override
  Widget build(BuildContext context) {
    print('lstIndDaysOfWeek $lstIndDaysOfWeek');
    print('lstIndShiftName $lstIndShiftName');
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 260,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                const SizedBox(height: Contants.spacingRow10),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        border: const OutlineInputBorder(),
                        hintText: multiLang.enterKeyWordForSearching,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: Contants.spacingRow10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            lstIndDaysOfWeek = lstDayInititalVisit;
                          });
                        },
                        child: Text(
                          multiLang.daysOfWeek,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (lstIndDaysOfWeek.length == daysOfWeek.length) {
                              lstIndDaysOfWeek = [];
                            } else {
                              lstIndDaysOfWeek = List<int>.generate(
                                daysOfWeek.length,
                                (index) => index,
                              );
                            }
                          });
                        },
                        child: Text(
                          multiLang.allDaysOfWeek,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Contants.spacingRow10),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      daysOfWeek.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            if (lstIndDaysOfWeek.contains(index)) {
                              lstIndDaysOfWeek.remove(index);
                            } else {
                              lstIndDaysOfWeek.add(index);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: lstIndDaysOfWeek.contains(index)
                                ? Colors.blue
                                : null,
                          ),
                          child: Text(daysOfWeek[index]),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: Contants.spacingRow10),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            lstIndShiftName = lstShiftInititalVisit;
                          });
                        },
                        child: Text(
                          multiLang.shift,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (lstIndShiftName.length == lstShiftName.length) {
                              lstIndShiftName = [];
                            } else {
                              lstIndShiftName = List<int>.generate(
                                lstShiftName.length,
                                (index) => index,
                              );
                            }
                          });
                        },
                        child: Text(
                          multiLang.all,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Contants.spacingRow10),
                // OptionSearch(
                //   lstItem: lstShiftName,
                //   lstIndChoose: lstIndShiftName,
                //   type: 'lstShiftName',
                //   lstIndex: (result) {
                //     lstIndShiftName = result;
                //     print('onResultShift $lstIndShiftName');
                //   },
                // ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      lstShiftName.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            if (lstIndShiftName.contains(index)) {
                              lstIndShiftName.remove(index);
                            } else {
                              lstIndShiftName.add(index);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: lstIndShiftName.contains(index)
                                ? Colors.blue
                                : null,
                          ),
                          child: Text(lstShiftName[index]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Contants.spacingRow10),
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: AppButton(
              backgroundColor: AppColor.mainAppColor,
              height: 50,
              width: 320,
              title: multiLang.search,
              onPress: () {
                onResult(
                    _searchController.text, lstIndDaysOfWeek, lstIndShiftName);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class OptionSearch extends StatefulWidget {
  final List<String> lstItem;
  final List<int> lstIndChoose;
  final String type;
  final void Function(List<int>) lstIndex;

  const OptionSearch({
    Key? key,
    required this.lstItem,
    required this.lstIndChoose,
    required this.type,
    required this.lstIndex,
  }) : super(key: key);

  @override
  _OptionSearchState createState() => _OptionSearchState();
}

class _OptionSearchState extends State<OptionSearch> {
  //List<String> selectedItems = ['T2'];
  List<int> selectedItems = [];
  late final List<String> lstSearchItem;
  late final String type;

  @override
  void initState() {
    super.initState();
    lstSearchItem = widget.lstItem;
    type = widget.type;
    selectedItems = widget.lstIndChoose;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        lstSearchItem.length,
        (index) => InkWell(
          onTap: () {
            setState(() {
              if (selectedItems.contains(index)) {
                selectedItems.remove(index);
              } else {
                selectedItems.add(index);
              }

              widget.lstIndex(selectedItems);

              print('widget.lstIndex ${widget.lstIndex}');
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
              color: selectedItems.contains(index) ? Colors.blue : null,
            ),
            child: Text(lstSearchItem[index]),
          ),
        ),
      ),
    );
  }
}
