import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer/customer.dart';
import 'package:horeca/screen/customer_detail/product/cubit/cancel_visit_dialog_cubit.dart';
import 'package:horeca/screen/customer_detail/product/cubit/cancel_visit_dialog_state.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca_service/horeca_service.dart';

class CancelVisitDialog extends StatelessWidget {
  final double width;
  final double height;
  final int routeId;
  final int customerId;
  final int customerAddressId;

  const CancelVisitDialog(
      {Key? key,
      required this.width,
      required this.height,
      required this.routeId,
      required this.customerId,
      required this.customerAddressId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CancelVisitDialogCubit(context)..init(),
        child: CancelVisitDialogBody(
          width: width,
          height: height,
          routeId: routeId,
          customerId: customerId,
          customerAddressId: customerAddressId,
        ));
  }
}

class CancelVisitDialogBody extends StatefulWidget {
  final double width;
  final double height;
  final int routeId;
  final int customerId;
  final int customerAddressId;
  const CancelVisitDialogBody(
      {Key? key,
      required this.width,
      required this.height,
      required this.routeId,
      required this.customerId,
      required this.customerAddressId})
      : super(key: key);

  @override
  State<CancelVisitDialogBody> createState() => _CancelVisitDialogBodyState(
      width: width, height: height, customerId: customerId);
}

class _CancelVisitDialogBodyState extends State<CancelVisitDialogBody> {
  final double width;
  final double height;
  final int customerId;

  _CancelVisitDialogBodyState(
      {required this.width, required this.height, required this.customerId});

  List<Reason> lstReason = [];

  // List<String> items = [];
  // String selectedValue = '';
  List<int> items = [];
  int selectedValue = -1;
  @override
  Widget build(BuildContext context) {
    void updateReasonCancel(int? value) {
      setState(() {
        selectedValue = value!;
      });
    }

    void cancelOnClick() {
      context.read<CancelVisitDialogCubit>().cancelVisit(
          widget.routeId, customerId, widget.customerAddressId, selectedValue);
    }

    Widget dialogContent(BuildContext context) {
      // double width = MediaQuery.of(context).size.width;
      AppLocalizations multiLang = AppLocalizations.of(context)!;
      return Container(
        color: Colors.white,
        width: 500,
        height: 220,
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
                      multiLang.selectReasonCancelVisit,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),

                      // dropdown below..
                      child: DropdownButton<int>(
                        value: selectedValue,
                        // items: items
                        //     .map<DropdownMenuItem<String>>(
                        //         (String value) => DropdownMenuItem<String>(
                        //               value: value,
                        //               child: Text(value),
                        //             ))
                        //     .toList(),
                        items: items
                            .map<DropdownMenuItem<int>>(
                                (value) => DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(lstReason
                                          .firstWhere((element) =>
                                              element.reasonId == value)
                                          .reasonContent!),
                                    ))
                            .toList()
                            .cast(),

                        // add extra sugar..
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                        underline: const SizedBox(),
                        onChanged: (int? value) {
                          updateReasonCancel(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AppButton(
                            backgroundColor: AppColor.mainAppColor,
                            height: 55,
                            width: 200,
                            title: multiLang.confirm,
                            onPress: () {
                              // print('hủy');
                              cancelOnClick();
                              // Navigator.of(context).pop();
                            },
                          )),
                    ],
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

    return BlocConsumer<CancelVisitDialogCubit, CancelVisitDialogState>(
      listener: (context, state) {
        if (state is LoadingInit) {
          lstReason = state.lstReason;
          lstReason.forEach((element) {
            items.add(element.reasonId!);
          });
          selectedValue = items.first;
        }
        if (state is CancelVisitSuccessfully) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Fluttertoast.showToast(
              // msg: "Hủy viếng thăm thành công.",
              msg: CommonUtils.firstLetterUpperCase(state.msg),
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.successColor,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            Navigator.of(context).pop();
          });

          Navigator.pop(context, () {
            const CustomerScreen();
          });
        }
        if (state is CancelVisitFailed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Fluttertoast.showToast(
              msg: CommonUtils.firstLetterUpperCase(state.error.toString()),
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.errorColor,
              textColor: Colors.white,
              fontSize: 14.0,
            );
          });
        }

        if (state is ClickCancelVisit) {}
      },
      builder: (context, state) {
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
