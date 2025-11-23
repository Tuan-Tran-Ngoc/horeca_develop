// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/constants.dart';

class DatatableController {
  final ValueNotifier<int> _selectIndex;

  DatatableController(int selectIndex)
      : _selectIndex = ValueNotifier(selectIndex);

  ValueNotifier<int> get selectIndex => _selectIndex;
  void dispose() {
    _selectIndex.dispose();
  }
}

class DatatableWidget extends StatelessWidget {
  DatatableController datatableController;
  List<Map<String, dynamic>> columnData;
  List<List<String>> rowData;
  final double width;
  double? heightHeader;
  void Function(bool?)? callback;
  final void Function(int rowIndex, int columnIndex)? onCellTap;
  bool? colorRow;
  DatatableWidget(
      {Key? key,
      required this.datatableController,
      required this.columnData,
      required this.rowData,
      required this.width,
      this.heightHeader = 60,
      this.callback,
      this.onCellTap,
      this.colorRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns(List<Map<String, dynamic>> columns) {
      return columns
          .map((column) => DataColumn(
                  label: SizedBox(
                width: width * column['width'],
                child: Text(
                  column['title'].toUpperCase(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )))
          .toList();
    }

    List<DataRow> rows(List<List<String>> rows) {
      return rows.map((e) {
        int rowIndex = rows.indexOf(e);

        return DataRow(
            color: MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (!(colorRow ?? false)) {
                return Colors.white;
              } else {
                String colorCode = e[e.length - 1];
                return Color(int.parse(colorCode, radix: 16)).withOpacity(0.5);
              }
            }),
            onSelectChanged: (value) {
              datatableController._selectIndex.value = rows.indexOf(e);
            },
            cells: ((colorRow ?? false)
                    ? e.take(e.length - 1).toList()
                    : e.toList())
                .asMap()
                .entries
                .map((entry) {
              int columnIndex = entry.key;
              String cellValue = entry.value;
              return DataCell(GestureDetector(
                onTap: () {
                  datatableController._selectIndex.value = rowIndex;
                  print('Row: $rowIndex, Cell: $columnIndex');
                  if (onCellTap != null) {
                    onCellTap!(rowIndex, columnIndex);
                  }
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: width *
                          columnData[columnIndex]['width']), //SET max width
                  child: SizedBox(
                    width: width * columnData[columnIndex]['width'],
                    child: SizedBox(
                      width: width * columnData[columnIndex]['width'],
                      child: (columnData[columnIndex]['type'] ==
                              Constant.dataTypeInput)
                          ? Text(
                              cellValue,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal),
                            )
                          : Text(
                              cellValue,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
                            ),
                    ),
                  ),
                ),
              ));
            }).toList());
      }).toList();
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: ValueListenableBuilder(
            valueListenable: datatableController._selectIndex,
            builder: (context, error, child) {
              return DataTable(
                  showCheckboxColumn: false,
                  headingRowHeight: heightHeader,
                  columnSpacing: 1,
                  headingRowColor: MaterialStateProperty.all<Color>(
                      AppColor.disableBackgroundColor),
                  columns: columns(columnData),
                  rows: rows(rowData));
            }),
      ),
    );
  }
}
