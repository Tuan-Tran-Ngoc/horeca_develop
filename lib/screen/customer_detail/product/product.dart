// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/buy/product/product_popup.dart';
import 'package:horeca/screen/customer_detail/product/cancel_visit.dart';
import 'package:horeca/screen/customer_detail/product/cubit/product_cubit.dart';
import 'package:horeca/screen/setting/setting.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca/widgets/dropdown.dart';
import 'package:horeca_service/sqflite_database/dto/address_visit_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductScreen extends StatelessWidget {
  final int routeId;
  final int customerId;
  final int customerVisitId;
  String statusVisit;
  final int customerAddressId;
  final void Function(int, String, int)
      onResultCustomerVisitId; // customerVisitId - statusVisit

  ProductScreen(
      {Key? key,
      required this.routeId,
      required this.customerId,
      required this.customerVisitId,
      required this.statusVisit,
      required this.customerAddressId,
      required this.onResultCustomerVisitId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(context)
        ..init(customerId, customerVisitId, customerAddressId),
      child: ProductBody(
          routeId: routeId,
          customerId: customerId,
          statusVisit: statusVisit,
          onResultCustomerVisitId: onResultCustomerVisitId),
    );
  }
}

class ProductBody extends StatefulWidget {
  final int routeId;
  final int customerId;
  String statusVisit;
  final void Function(int, String, int) onResultCustomerVisitId;
  ProductBody(
      {super.key,
      required this.routeId,
      required this.customerId,
      required this.statusVisit,
      required this.onResultCustomerVisitId});

  @override
  State<ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {
  List<List<String>> rowDataProduct = [];

  Key dataTableKey = UniqueKey();

  // address
  List<AddressVisitDto> lstAddress = [];
  AddressVisitDto? addressChoose;
  List<String?> lstAddressStr = [];

  final ValueNotifier<int> _selectIndex = ValueNotifier(0);

  final DatatableController _datatableController = DatatableController(-1);

  @override
  void initState() {
    super.initState();
    _datatableController.selectIndex.addListener(() {
      print(
          '_selectIndex $_selectIndex ${_datatableController.selectIndex.value}');
      if (lstAddress.isNotEmpty) {
        final customerId = lstAddress[_datatableController.selectIndex.value]
            .customerAddressId;
        print('_customerAddressId $customerId');
        _selectIndex.value =
            -1; // Sử dụng _selectIndex, không phải _datatableController.selectIndex
        //context.push('/customerdetail', extra: {"customerId": customerId ?? 0});
      }
    });
  }

  TextEditingController typeController = TextEditingController();
  List<List<String>> rowDataDTC = [];

  bool isDTC = false;
  bool isLoadingScreen = false;
  bool isLoadingItems = false;
  //bool isStartVisit = false;
  List<ProductDto> lstAllProduct = [];
  List<ProductDto> lstCustomerStock = [];
  late int? customerVisitId;
  String? chooseAddress = '';
  @override
  Widget build(BuildContext context) {
    final double width =
        (MediaQuery.of(context).size.width - Contants.widthLeftMenu);

    List<ProductDto> getProductOrder(List<ProductDto> lstProduct) {
      return lstProduct.where((product) => product.quantity! > 0).toList();
    }

    AppLocalizations multiLang = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> columnDataProduct = [
      {'title': multiLang.no, 'width': .1},
      {'title': multiLang.productName, 'width': .3},
      {'title': multiLang.type, 'width': .1},
      {'title': multiLang.unit, 'width': .12},
      {
        'title': multiLang.priceAtPointSales,
        'width': .15,
        'type': Constant.dataTypeInput
      },
      {'title': multiLang.quantity, 'width': .1, 'type': Constant.dataTypeInput}
    ];

    List<Map<String, dynamic>> columnDataDTC = [
      {'title': multiLang.no, 'width': .05},
      {'title': multiLang.productName, 'width': .25},
      {'title': multiLang.type, 'width': .1},
      {'title': multiLang.unit, 'width': .1},
      {'title': multiLang.priceOfCompany, 'width': .15},
      {'title': multiLang.initAllocation, 'width': .1},
      {'title': multiLang.usedAllocation, 'width': .1},
      {'title': multiLang.availableAllocation, 'width': .1},
    ];
    List<List<String>> lstProductStr(List<ProductDto> lstProduct) {
      List<List<String>> results = [];

      int index = 0;
      results = lstProduct.map((product) {
        index++;
        List<String> result = [];
        print('product_id: ${product.productId}');
        result.add(index.toString());
        result.add(product.productName ?? '');
        result.add(product.typeName ?? '');
        result.add(product.uomName ?? '');
        result.add(
            NumberFormat.currency(locale: 'vi').format(product.priceCustomer));
        result.add(NumberFormat.decimalPattern().format(product.quantity));
        return result;
      }).toList();
      return results;
    }

    void updateCustomerStock(List<ProductDto> results) {
      setState(() {
        lstAllProduct = results;
        lstCustomerStock = getProductOrder(results);
        rowDataProduct = lstProductStr(lstCustomerStock);

        context.read<ProductCubit>().modifyProductSuccess();
      });
    }

    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is StartVisitSuccess) {
          //isStartVisit = state.isStartVisit;
          customerVisitId = state.customerVisitId;
          typeController.text = chooseAddress!;
          widget.statusVisit = Constant.visiting;
          widget.onResultCustomerVisitId(state.customerVisitId ?? 0,
              widget.statusVisit, state.customerAddressId);
        }

        if (state is StartVisitFail) {
          if (state.error.toString() ==
              MessageUtils.getMessages(code: Constant.SESSION_LOGIN_EXPIRED)) {
            CommonUtils.logout();
            GoRouter.of(context).go('/');
          }
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(state.error.toString()),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is RevisitSuccess) {
          // widget.statusVisit = state.statusVisit;

          // widget.onResultCustomerVisitId(
          //     customerVisitId ?? 0, widget.statusVisit);
          customerVisitId = state.customerVisitId;
          widget.statusVisit = Constant.visiting;
          widget.onResultCustomerVisitId(state.customerVisitId,
              widget.statusVisit, state.customerAddressId);

          Fluttertoast.showToast(
            // msg: 'Viếng thăm lại thành công',
            msg: CommonUtils.firstLetterUpperCase(state.msg),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.successColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is RevisitFail) {
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(state.error.toString()),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is SaveCustomerPriceSuccess) {
          Fluttertoast.showToast(
            // msg: 'Xác nhận tồn kho thành công',
            msg: CommonUtils.firstLetterUpperCase(state.msg),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.successColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is SaveCustomerPriceFail) {
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(state.error.toString()),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is ClickConfirmStockCustomer) {}

        if (state is EventChangeAddress) {}

        if (state is ChangeAddressSuccess) {
          customerVisitId = state.customerVisit.customerVisitId ?? 0;
          typeController.text = chooseAddress!;
          lstCustomerStock = state.listCustomerStock;
          widget.statusVisit =
              state.customerVisit.visitStatus ?? Constant.notYetVisit;
          widget.onResultCustomerVisitId(
              state.customerVisit.customerVisitId ?? 0,
              widget.statusVisit,
              state.customerAddressId);
        }
      },
      builder: (context, state) {
        if (state is ProductInitialSuccess) {
          isLoadingScreen = false;
          lstCustomerStock = state.listCustomerStock;
          rowDataDTC = state.rowDataDTC;
          //isStartVisit = state.isStartVisit;
          lstAddress = state.lstAddress;
          lstAddressStr = lstAddress.map((address) => address.address).toList();
          typeController.text = state.selectedAddval;
          customerVisitId = state.customerVisitId;
          addressChoose = lstAddress
              .where((address) => (address.address == state.selectedAddval))
              .firstOrNull;
          print('lstCustomerStock $lstCustomerStock');
        }
        if (state is LoadingInit) {
          isLoadingScreen = true;
        }
        if (state is LoadingItem) {
          isLoadingItems = true;
        }
        if (state is ClickTabSuccess) {
          isLoadingItems = false;
          isDTC = state.isDTC;
        }
        if (state is ModifyProductSucess) {}

        if (state is ClickStartVisit) {}

        if (state is ClickRevisitSuccess) {}

        return SizedBox(
          width: width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    multiLang.customerVisitAddress,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 600,
                    child: DropdownList(
                      onChanged: (newVal) {
                        typeController.text =
                            lstAddress[int.parse(newVal)].address ?? '';
                        chooseAddress =
                            lstAddress[int.parse(newVal)].address ?? '';
                        setState(() {
                          addressChoose = lstAddress[int.parse(newVal)];
                        });
                        context
                            .read<ProductCubit>()
                            .changeAddress(widget.customerId, addressChoose);
                      },
                      value: selectedValue,
                      enable: !(widget.statusVisit == Constant.visiting),
                      hintText: CommonUtils.firstLetterUpperCase(
                          multiLang.enter(multiLang.customerVisitAddress)),
                      textController: typeController,
                      items: lstAddress.isNotEmpty
                          ? lstAddress.map((item) {
                              return DropdownMenuItem<String>(
                                  value: lstAddress.indexOf(item).toString(),
                                  child: DropdownMenuItemSeparator(
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      name: item.address.toString()));
                            }).toList()
                          : [],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: Contants.heightTab,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () {
                    isDTC = false;
                    context.read<ProductCubit>().clickTab(isDTC);
                  },
                  child: SizedBox(
                    width: width / 2,
                    height: Contants.heightTab,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Text(
                            multiLang.salesInventory,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 5,
                          color: isDTC
                              ? AppColor.transparent
                              : AppColor.mainAppColor,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    isDTC = true;
                    context.read<ProductCubit>().clickTab(isDTC);
                  },
                  child: SizedBox(
                    width: width / 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Text(
                            multiLang.stockSalesStaff,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 5,
                          color: !isDTC
                              ? AppColor.transparent
                              : AppColor.mainAppColor,
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
            Expanded(
              child: !isDTC
                  ? DatatableWidget(
                      datatableController: _datatableController,
                      columnData: columnDataProduct,
                      rowData: lstProductStr(lstCustomerStock),
                      width: width,
                      onCellTap: (rowIndex, columnIndex) {
                        print('rowIndex $rowIndex');
                        print('columnIndex $columnIndex');
                        print('statusVisit ${widget.statusVisit}');
                        if ((widget.statusVisit == Constant.visiting) &&
                            (columnIndex == 4 || columnIndex == 5)) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final product = lstCustomerStock[rowIndex];
                              final isPriceColumn = columnIndex == 4;
                              String message = [
                                multiLang.edit,
                                isPriceColumn
                                    ? multiLang.price
                                    : multiLang.quantity,
                                multiLang.product
                              ].join(" ");

                              String initialValue = isPriceColumn
                                  ? (product.priceCustomer ?? 0)
                                      .toInt()
                                      .toString()
                                  : (product.quantity ?? 0).toInt().toString();

                              TextEditingController textEditingController =
                                  TextEditingController(
                                text: initialValue,
                              );

                              textEditingController.addListener(() {
                                if (textEditingController.text == '0') {
                                  textEditingController.text = '';
                                  textEditingController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset:
                                            textEditingController.text.length),
                                  );
                                }
                              });

                              return AlertDialog(
                                // title: Text(
                                //     'Chỉnh sửa ${isPriceColumn ? 'giá' : 'số lượng'} sản phẩm'),
                                title: Text(
                                    CommonUtils.firstLetterUpperCase(message)),
                                content: TextFormField(
                                  controller: textEditingController,
                                  onChanged: (value) {
                                    textEditingController.text = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+'))
                                  ],
                                  decoration: InputDecoration(
                                    labelText:
                                        // isPriceColumn ? 'Giá' : 'Số lượng',
                                        isPriceColumn
                                            ? multiLang.price
                                            : multiLang.quantity,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isPriceColumn) {
                                          product
                                              .priceCustomer = double.tryParse(
                                                  textEditingController.text) ??
                                              0;
                                        } else {
                                          product.quantity = double.tryParse(
                                                  textEditingController.text) ??
                                              0;
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                  : DatatableWidget(
                      datatableController: _datatableController,
                      columnData: columnDataDTC,
                      rowData: rowDataDTC,
                      width: width),
            ),
            // !isStartVisit
            (widget.statusVisit == Constant.notYetVisit ||
                    widget.statusVisit == Constant.visited ||
                    widget.statusVisit == Constant.canceledVisit)
                ? ((widget.statusVisit == Constant.visited ||
                        widget.statusVisit == Constant.canceledVisit)
                    ? (isDTC
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: 55,
                                  width: width / 3,
                                  title: CommonUtils.firstLetterUpperCase(
                                      multiLang.revisit),
                                  onPress: () {
                                    context.read<ProductCubit>().revisit(
                                        widget.customerId,
                                        customerVisitId ?? 0);
                                  },
                                ),
                              ),
                            ],
                          ))
                    : SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 2,
                              height: 55,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                ),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: 55,
                                  title: multiLang.cancelVisit,
                                  onPress: () {
                                    if (addressChoose != null) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CancelVisitDialog(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                routeId: widget.routeId,
                                                customerId: widget.customerId,
                                                customerAddressId: addressChoose
                                                        ?.customerAddressId ??
                                                    0);
                                          });
                                    } else {
                                      String message = multiLang.enter(
                                          multiLang.customerVisitAddress);
                                      Fluttertoast.showToast(
                                        // msg: 'Vui lòng chọn địa chỉ viếng thăm',
                                        msg: CommonUtils.firstLetterUpperCase(
                                            message),
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb:
                                            Constant.SHOW_TOAST_TIME,
                                        backgroundColor: AppColor.errorColor,
                                        textColor: Colors.white,
                                        fontSize: 14.0,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width / 2,
                              height: 55,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: 55,
                                  title: multiLang.startVisit,
                                  onPress: () {
                                    if (addressChoose != null &&
                                        addressChoose?.customerAddressId != 0) {
                                      context.read<ProductCubit>().startVisit(
                                          widget.routeId,
                                          widget.customerId,
                                          addressChoose?.customerAddressId);
                                    } else {
                                      String message = multiLang.enter(
                                          multiLang.customerVisitAddress);
                                      Fluttertoast.showToast(
                                        // msg: 'Vui lòng chọn địa chỉ viếng thăm',
                                        msg: CommonUtils.firstLetterUpperCase(
                                            message),
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb:
                                            Constant.SHOW_TOAST_TIME,
                                        backgroundColor: AppColor.errorColor,
                                        textColor: Colors.white,
                                        fontSize: 14.0,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                : (isDTC
                    ? const SizedBox()
                    : SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 2,
                              height: 55,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                ),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: 55,
                                  title: multiLang.addNew,
                                  onPress: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return ProductPopup(
                                            width: width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.9,
                                            customerId: widget.customerId,
                                            isCheckStock: true,
                                            availableProduct: lstCustomerStock,
                                            onResultProduct: (result) {
                                              updateCustomerStock(result);
                                            },
                                          );
                                        });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width / 2,
                              height: 55,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: 55,
                                  title: multiLang.submit,
                                  onPress: () {
                                    context
                                        .read<ProductCubit>()
                                        .saveCustomerStock(lstCustomerStock,
                                            widget.customerId, customerVisitId);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
          ]),
        );
      },
    );
  }
}
