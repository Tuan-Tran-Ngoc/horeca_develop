import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/sync/cubit/sync_cubit.dart';
import 'package:horeca/screen/sync/cubit/sync_state.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/widgets/button.dart';

import '../../utils/constants.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return const SyncBody();
    return BlocProvider(
        create: (context) => SyncCubit(context)..init(),
        child: const SyncBody());
  }
}

class SyncBody extends StatefulWidget {
  const SyncBody({super.key});

  @override
  State<SyncBody> createState() => _SyncBodyState();
}

class _SyncBodyState extends State<SyncBody> {
  bool isReloadControl = false;
  String lastestUpdate = '';
  List<Map<String, dynamic>> lstDataSynchronize = [];

  @override
  void initState() {
    super.initState();
    isReloadControl = false;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    return BlocConsumer<SyncCubit, SyncState>(
      listener: (context, state) {
        if (state is LoadingInit) {
          lastestUpdate = state.lastestUpdate;
          lstDataSynchronize = state.lstDataSynchronize;
        }
        if (state is OnClickUpdateData) {}
        if (state is UpdateDataSuccess) {
          isReloadControl = false;
          lastestUpdate = state.lastestUpdate;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(state.msg),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.successColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is UpdateDataFail) {
          if (isReloadControl) {
            Navigator.of(context).pop();
            isReloadControl = false;
          }
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(state.error),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is SynchronizeDataSuccess) {
          // isReloadControl = false;
          // Navigator.of(context).pop();
          Fluttertoast.showToast(
            // msg: 'Đồng bộ dữ liệu thành công',
            msg: CommonUtils.firstLetterUpperCase(state.msg),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.successColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is SynchronizeDataFail) {
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(state.error),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is InitialDataSuccess) {
          isReloadControl = false;
          //Navigator.of(context).pop();
          lstDataSynchronize = [];
          if (isReloadControl) {
            Navigator.of(context).pop();
            isReloadControl = false;
          }
          Fluttertoast.showToast(
            msg: CommonUtils.firstLetterUpperCase(
                [multiLang.initialData, multiLang.success].join(" ")),
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.successColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }

        if (state is InitialDataFail) {
          if (isReloadControl) {
            Navigator.of(context).pop();
            isReloadControl = false;
          }
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
            backgroundColor: AppColor.errorColor,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }
      },
      builder: (context, state) {
        if (state is ReloadControl) {
          if (!isReloadControl) {
            isReloadControl = true;
          } else {
            Navigator.of(context).pop();
          }
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialog(
              context: context,
              barrierDismissible:
                  false, // prevent user from dismissing the dialog
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(state.message),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //CircularProgressIndicator(),
                      // const SizedBox(height: 8),
                      Text(multiLang.waiting),
                    ],
                  ),
                );
              },
            );
          });
        }

        return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.mainAppColor,
              title: Center(
                  child: Text(
                multiLang.syncManagement,
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
              lstDataSynchronize.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(
                            showCheckboxColumn: false,
                            headingRowHeight: 60,
                            columnSpacing: 1,
                            dataRowMaxHeight: 60,
                            dataRowMinHeight: 30,
                            headingRowColor: MaterialStateProperty.all<Color>(
                                AppColor.disableBackgroundColor),
                            columns: <DataColumn>[
                              DataColumn(
                                  label: Expanded(
                                      child: Text(multiLang.contentSync))),
                              DataColumn(
                                  label: Expanded(
                                      child: Text(multiLang.startDate))),
                              DataColumn(
                                  label:
                                      Expanded(child: Text(multiLang.endDate))),
                              DataColumn(
                                  label:
                                      Expanded(child: Text(multiLang.status))),
                            ],
                            rows: lstDataSynchronize
                                .map(
                                  (e) => DataRow(cells: [
                                    DataCell(SizedBox(
                                        width: width * 0.35,
                                        child: Text(e['syncName']))),
                                    DataCell(SizedBox(
                                        width: width * 0.25,
                                        child: Text(e['startDate']))),
                                    DataCell(SizedBox(
                                        width: width * 0.25,
                                        child: Text(e['endDate']))),
                                    DataCell(SizedBox(
                                        width: width * 0.15,
                                        child: Text(e['status']))),
                                  ]),
                                )
                                .toList()),
                      ),
                    )
                  : Expanded(
                      child: Text(
                      lastestUpdate,
                      style: const TextStyle(
                        fontSize: 40,
                      ),
                    )),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      width: width * 0.66,
                      child: Row(children: [
                        SizedBox(
                          //height: height * 0.1,
                          child: Center(
                            child: SizedBox(
                              width: width * 0.22,
                              height: height * 0.05,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: Contants.heightButton,
                                  title: multiLang.initialData,
                                  onPress: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        final ButtonStyle flatButtonStyle =
                                            TextButton.styleFrom(
                                          minimumSize: const Size(20, 20),
                                          backgroundColor: Colors.grey,
                                          padding: const EdgeInsets.all(0),
                                        );
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .notification
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                multiLang.waringInitialData,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      super
                                                          .context
                                                          .read<SyncCubit>()
                                                          .initialData();
                                                    },
                                                    child: Text(
                                                        multiLang.yesAnswer),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                        multiLang.noAnswer),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          //height: height * 0.1,
                          child: Center(
                            child: SizedBox(
                              width: width * 0.22,
                              height: height * 0.05,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: Contants.heightButton,
                                  title: multiLang.update,
                                  onPress: () {
                                    context.read<SyncCubit>().getUpdateData();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          //height: height * 0.1,
                          child: Center(
                            child: SizedBox(
                              width: width * 0.22,
                              height: height * 0.05,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: AppButton(
                                  backgroundColor: AppColor.mainAppColor,
                                  height: Contants.heightButton,
                                  title: multiLang.sync,
                                  onPress: () {
                                    context.read<SyncCubit>().synchronize();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])))
            ]));
      },
    );
  }
}

class ReLoginPopup extends StatelessWidget {
  final Function onOkPressed;

  const ReLoginPopup({Key? key, required this.onOkPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(multiLang.loginAgain),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Đóng popup
            Navigator.of(context).pop();
          },
          child: Text(multiLang.cancel),
        ),
        TextButton(
          onPressed: () {
            // Gọi hàm khi nhấn OK
            onOkPressed();
            // Đóng popup
            Navigator.of(context).pop();
          },
          child: Text(multiLang.confirm),
        ),
      ],
    );
  }
}
