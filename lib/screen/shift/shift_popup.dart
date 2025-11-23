import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/shift/cubit/shift_popup_cubit.dart';
import 'package:horeca/screen/shift/cubit/shift_popup_state.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int? shiftReportId;

class ShiftPopup extends StatelessWidget {
  final double width;
  final double height;

  const ShiftPopup({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShiftPopupCubit(context)..init(),
      child: ShiftPopupBody(width: width, height: height),
    );
  }
}

class ShiftPopupBody extends StatefulWidget {
  final double width;
  final double height;
  const ShiftPopupBody({super.key, required this.width, required this.height});

  @override
  State<ShiftPopupBody> createState() =>
      _ShiftPopupBodyState(width: width, height: height);
}

class _ShiftPopupBodyState extends State<ShiftPopupBody> {
  final ValueNotifier<int> _selectIndex = ValueNotifier(0);
  final DatatableController _datatableController = DatatableController(-1);
  final double width;
  final double height;

  _ShiftPopupBodyState({
    required this.width,
    required this.height,
  });

  bool isLoadingScreen = false;
  bool isLoadingItems = false;
  List<Map<String, dynamic>> columnDataShift = [
    {'title': 'STT', 'width': .05},
    {'title': 'Ca', 'width': .35},
    {'title': 'Thời gian bắt đầu', 'width': .3},
    {'title': 'Thời gian kết thúc', 'width': .15},
  ];

  List<Shift> lstShift = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('widthPopup $width');
    Widget dialogContent(BuildContext context) {
      return Container(
        color: Colors.white,
        width: width,
        height: height,
        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: Stack(
          children: <Widget>[
            Container(
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
                      AppLocalizations.of(context)!.shfitManagement,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                      child: TableShift(
                    lstInitialShift: lstShift,
                    width: width,
                    height: height,
                  )),
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

    return BlocConsumer<ShiftPopupCubit, ShiftPopupState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is ChooseShiftSuccess) {}
        if (state is StartShiftSuccess) {
          Navigator.of(context).pop();
          context.push('/customer');
        }

        if (state is StartShiftFail) {
          Fluttertoast.showToast(
            msg: (state).error ?? 'Bắt đầu ca làm việc thất bại',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }
      },
      builder: (context, state) {
        print('state: $state');

        if (state is ShiftPopupInitialSuccess) {
          lstShift = state.lstShift;
        }

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
        );
      },
    );
  }
}

class TableShift extends StatelessWidget {
  final List<Shift> lstInitialShift;
  final double width;
  final double height;

  const TableShift({
    Key? key,
    required this.lstInitialShift,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> rate = [.05, .35, .3, .3];
    DataRow rowData(BuildContext context, String stt, String shiftName,
        String? startTime, String? endTime, String? shiftCode) {
      // final width = MediaQuery.of(context).size.width;
      print('width: ${width}');
      return DataRow(
          onSelectChanged: (value) async {
            context
                .read<ShiftPopupCubit>()
                .insertShiftReport(shiftCode!)
                .then((value) {});
          },
          cells: [
            DataCell(ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: width * rate[0]), //SET max width
              child: Center(
                child: Text(
                  stt,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
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
                      shiftName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
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
                      startTime!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
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
                      endTime!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ))),
          ]);
    }

    List<DataRow> lstView = [];
    for (var index = 0; index < lstInitialShift.length; index++) {
      Shift shiftItem = lstInitialShift[index];
      DataRow record = rowData(
          context,
          (index + 1).toString(),
          shiftItem.shiftName ?? '',
          shiftItem.startTime ?? '',
          shiftItem.endTime ?? '',
          shiftItem.shiftCode);
      lstView.add(record);
    }

    // final width = MediaQuery.of(context).size.width;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                showCheckboxColumn: false,
                headingRowHeight: 60,
                columnSpacing: 1,
                dataRowMaxHeight: 60,
                dataRowMinHeight: 30,
                headingRowColor: MaterialStateProperty.all<Color>(
                    AppColor.disableBackgroundColor),
                columns: [
                  DataColumn(
                      label: SizedBox(
                    width: width * rate[0],
                    child: Text(
                      AppLocalizations.of(context)!.no,
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
                        AppLocalizations.of(context)!.shift,
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
                        AppLocalizations.of(context)!.startTime,
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
                        AppLocalizations.of(context)!.endTime,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                ],
                rows: lstView),
          ),
        ));
  }
}
