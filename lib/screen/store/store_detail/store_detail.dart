// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:horeca/themes/app_color.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoreDetailBody();
  }
}

class StoreDetailBody extends StatefulWidget {
  const StoreDetailBody({super.key});

  @override
  State<StoreDetailBody> createState() => _StoreDetailBodyState();
}

class _StoreDetailBodyState extends State<StoreDetailBody> {
  List<List<String>> rowDataProduct = [
    [
      '1',
      'Mì hảo hảo chua cay',
      'Mì',
      '30',
      'Thùng',
    ],
  ];

  final DatatableController _datatableController = DatatableController(-1);
  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    List<Map<String, dynamic>> columnDataProduct = [
      {'title': multiLang.no, 'width': .05},
      {'title': multiLang.productName, 'width': .3},
      {'title': multiLang.type, 'width': .5},
      {'title': multiLang.quantity, 'width': .15},
      {'title': multiLang.unit, 'width': .15},
    ];
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainAppColor,
          title: Center(
              child: Text(
            multiLang.detail,
            style: TextStyle(
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
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const InformationView(),
                const SizedBox(
                  height: 30,
                ),
                DatatableWidget(
                    datatableController: _datatableController,
                    columnData: columnDataProduct,
                    rowData: rowDataProduct,
                    width: width)
              ],
            ),
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
  const InformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Column(children: [
        InformationCell(
          title1: 'Mã phân bổ',
          title2: 'Thời gian kết thúc',
          value1: 'ACHCM_BA1112023120501',
          value2: '05/12/2023',
        ),
        InformationCell(
          title1: 'Trạng thái',
          title2: 'Ngày nhận hàng',
          value1: 'Đã xác nhận',
          value2: '05/12/2023',
        ),
      ]),
    );
  }
}

class TableProduct extends StatelessWidget {
  const TableProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    List<double> rate = [
      .05,
      .2,
      .05,
      .1,
      .1,
      .1,
      .12,
      .12,
    ];
    final double width = MediaQuery.of(context).size.width;
    DataRow rowData(
        String stt,
        String name,
        String quanity,
        String quanityPoint,
        String quanityDTC,
        String costPoint,
        String costManager,
        String total) {
      return DataRow(cells: [
        DataCell(ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: width * rate[0]), //SET max width
          child: Center(
            child: Text(
              stt,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        )),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[1]), //SET max width
            child: SizedBox(
              width: width * rate[1],
              child: Center(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[2]), //SET max width
            child: SizedBox(
              width: width * rate[2],
              child: Center(
                child: Text(
                  quanity,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[3]), //SET max width
            child: SizedBox(
              width: width * rate[3],
              child: Center(
                child: Text(
                  quanityPoint,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[4]), //SET max width
            child: SizedBox(
              width: width * rate[4],
              child: Center(
                child: Text(
                  quanityDTC,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[5]), //SET max width
            child: SizedBox(
              width: width * rate[5],
              child: Center(
                child: Text(
                  costPoint,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[6]), //SET max width
            child: SizedBox(
              width: width * rate[6],
              child: Center(
                child: Text(
                  costManager,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[7]), //SET max width
            child: SizedBox(
              width: width * rate[7],
              child: Center(
                child: Text(
                  total,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
      ]);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        // physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            headingRowHeight: 60,
            columnSpacing: 1,
            headingRowColor: MaterialStateProperty.all<Color>(
                AppColor.disableBackgroundColor),
            columns: [
              DataColumn(
                  label: SizedBox(
                width: width * rate[0],
                child: Text(
                  multiLang.no,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[1],
                child: Center(
                  child: Text(
                    multiLang.productName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[2],
                child: Center(
                  child: Text(
                    multiLang.quantity.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[3],
                child: Center(
                  child: Text(
                    multiLang.numberOfPointOfSales.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[4],
                child: Center(
                  child: Text(
                    multiLang.numberOfDTC.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[5],
                child: Center(
                  child: Text(
                    multiLang.amoutPaidToPointOfSalse.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[6],
                child: Center(
                  child: Text(
                    multiLang.amoutPaidToManager.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[7],
                child: Center(
                  child: Text(
                    multiLang.total.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
            ],
            rows: [
              rowData('1', 'Mì hảo hảo', '10', '20', '30', '350.000', '20.000',
                  '370.000')
            ]),
      ),
    );
  }
}

class TableOrder extends StatelessWidget {
  const TableOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    List<double> rate = [
      .1,
      .2,
      .4,
      .2,
    ];
    final double width = MediaQuery.of(context).size.width;
    DataRow rowData(String stt, String order, String name, String price) {
      return DataRow(cells: [
        DataCell(ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: width * rate[0]), //SET max width
          child: Center(
            child: Text(
              stt,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        )),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[1]), //SET max width
            child: SizedBox(
              width: width * rate[1],
              child: Center(
                child: Text(
                  order,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[2]), //SET max width
            child: SizedBox(
              width: width * rate[2],
              child: Center(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[3]), //SET max width
            child: SizedBox(
              width: width * rate[3],
              child: Center(
                child: Text(
                  price,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
      ]);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            headingRowHeight: 60,
            columnSpacing: 1,
            headingRowColor: MaterialStateProperty.all<Color>(
                AppColor.disableBackgroundColor),
            columns: [
              DataColumn(
                  label: SizedBox(
                width: width * rate[0],
                child: Text(
                  multiLang.no,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[1],
                child: Center(
                  child: Text(
                    multiLang.orderNo.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[2],
                child: Center(
                  child: Text(
                    multiLang.customerName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[3],
                child: Center(
                  child: Text(
                    multiLang.discountAmount.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
            ],
            rows: [
              rowData('1', 'DH00000001', 'Đại lý ABCD', '15.000.000')
            ]),
      ),
    );
  }
}

class TableOutlet extends StatelessWidget {
  const TableOutlet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    List<double> rate = [.05, .1, .15, .2, .05, .1];
    final double width = MediaQuery.of(context).size.width;
    DataRow rowData(String stt, String code, String name, String address,
        String trail, String price) {
      return DataRow(cells: [
        DataCell(ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: width * rate[0]), //SET max width
          child: Center(
            child: Text(
              stt,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        )),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[1]), //SET max width
            child: SizedBox(
              width: width * rate[1],
              child: Center(
                child: Text(
                  code,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[2]), //SET max width
            child: SizedBox(
              width: width * rate[2],
              child: Center(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[3]), //SET max width
            child: SizedBox(
              width: width * rate[3],
              child: Center(
                child: Text(
                  address,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[4]), //SET max width
            child: SizedBox(
              width: width * rate[4],
              child: Center(
                child: Text(
                  trail,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
        DataCell(ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: width * rate[5]), //SET max width
            child: SizedBox(
              width: width * rate[5],
              child: Center(
                child: Text(
                  price,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ))),
      ]);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            headingRowHeight: 60,
            columnSpacing: 1,
            headingRowColor: MaterialStateProperty.all<Color>(
                AppColor.disableBackgroundColor),
            columns: [
              DataColumn(
                  label: SizedBox(
                width: width * rate[0],
                child: Text(
                  multiLang.no,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[1],
                child: Center(
                  child: Text(
                    multiLang.customerCode.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[2],
                child: Center(
                  child: Text(
                    multiLang.customerName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[3],
                child: Center(
                  child: Text(
                    multiLang.address.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[4],
                child: Center(
                  child: Text(
                    'Trial'.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: width * rate[5],
                child: Center(
                  child: Text(
                    'Poly'.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
            ],
            rows: [
              rowData(
                  '1', 'OUT01111', 'outlet outlet', 'TP.HCM', '', '100.000.000')
            ]),
      ),
    );
  }
}
