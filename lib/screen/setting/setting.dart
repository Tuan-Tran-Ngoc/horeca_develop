import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/language_setting.dart';
import 'package:horeca/screen/setting/cubit/setting_cubit.dart';
import 'package:horeca/screen/setting/version_popup.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/dropdown.dart';
import 'package:horeca_service/sqflite_database/dto/setting_dto.dart';
import 'package:horeca_service/sqflite_database/dto/change_password_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

String? selectedValue;

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingCubit(context)..init(),
      child: const SettingBody(),
    );
  }
}

class SettingBody extends StatefulWidget {
  const SettingBody({super.key});

  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  TextEditingController typeController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  SettingDto info =
      SettingDto(lstLayoutType: [], lstlanguage: [], languageCodeCurrent: '');
  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    return BlocConsumer<SettingCubit, SettingState>(
      listener: (context, state) {
        if (state is LoadingInitSuccess) {
          info = state.info;
          languageController.text = info.lstlanguage
                  .firstWhere((element) =>
                      element.languageName == info.languageCodeCurrent)
                  .languageCode ??
              '';
          print('text ${languageController.text}');
        }
        if (state is ChangePasswordFailed) {
          Fluttertoast.showToast(
              msg: CommonUtils.firstLetterUpperCase(state.error.toString()),
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.errorColor,
              textColor: Colors.white,
              fontSize: 14.0);
        }
        if (state is ChangePasswordSuccessfully) {
          Fluttertoast.showToast(
              msg: CommonUtils.firstLetterUpperCase(state.msg),
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.successColor,
              textColor: Colors.white,
              fontSize: 14.0);
          Navigator.of(context).pop();
        }

        if (state is ChangeLanguageSuccessful) {
          Provider.of<LanguageSetting>(context, listen: false)
              .setLocale(state.newLocale);
          info.languageCodeCurrent = languageController.text;
          Fluttertoast.showToast(
              msg: CommonUtils.firstLetterUpperCase(state.msg),
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.successColor,
              textColor: Colors.white,
              fontSize: 14.0);
          Navigator.of(context).pop();
          GoRouter.of(context).go('/home');
        }

        if (state is EventUpradeVersionApp) {}

        if (state is UpgradeVersionAppSuccess) {
          String apkLink = state.filePath;
        }

        if (state is ExportDatabaseLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(multiLang.waiting),
                    ],
                  ),
                );
              },
            );
          });
        }

        if (state is ExportDatabaseSuccess) {
          Navigator.of(context).pop(); // Close loading dialog
          Fluttertoast.showToast(
              msg: state.msg,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.successColor,
              textColor: Colors.white,
              fontSize: 14.0);
        }

        if (state is ExportDatabaseFailed) {
          Navigator.of(context).pop(); // Close loading dialog
          Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
              backgroundColor: AppColor.errorColor,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.mainAppColor,
              title: Center(
                  child: Text(
                multiLang.settings,
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
            body: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // color: Colors.red[400],
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 400,
                          child: Center(
                            child: Text(multiLang.userInfo,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                ContentTemplate(
                    multiLang.account,
                    SizedBox(
                      width: ConstSetting.contentSizeboxLength,
                      child: Text(info.userName ?? ''),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    multiLang.currentPassword,
                    SizedBox(
                      width: ConstSetting.labelSizeboxLength,
                      height: 30,
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(5)),
                        controller: currentPassword,
                        onChanged: (value) => currentPassword.text = value,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    multiLang.newPassword,
                    SizedBox(
                      width: ConstSetting.labelSizeboxLength,
                      height: 30,
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(5)),
                        controller: newPassword,
                        onChanged: (value) => newPassword.text = value,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    multiLang.confirmPassword,
                    SizedBox(
                      width: ConstSetting.labelSizeboxLength,
                      height: 30,
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(5)),
                        controller: confirmPassword,
                        onChanged: (value) => confirmPassword.text = value,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    '',
                    SizedBox(
                      width: ConstSetting.labelSizeboxLength,
                      child: AppButton(
                        backgroundColor: AppColor.mainAppColor,
                        height: 40,
                        title: multiLang.changePassword,
                        onPress: () {
                          context.read<SettingCubit>().changePassword(
                              ChangePasswordDTO(currentPassword.text,
                                  newPassword.text, confirmPassword.text));
                        },
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  // color: Colors.red[400],
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 400,
                          child: Center(
                            child: Text(multiLang.appInfo,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                ContentTemplate(
                    multiLang.version,
                    SizedBox(
                        width: ConstSetting.contentSizeboxLength,
                        child: GestureDetector(
                          onTap: () {
                            // print('Click versionName');
                            // context.read<SettingCubit>().upgradeVersionApp();
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return VersionPopup(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                );
                              },
                            );
                          },
                          child: Text(
                            info.versionName ?? '',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ))),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    multiLang.server,
                    SizedBox(
                      width: ConstSetting.contentSizeboxLength,
                      child: Text(info.serverName ?? ''),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    multiLang.imeiDevice,
                    SizedBox(
                      width: ConstSetting.contentSizeboxLength,
                      child: Text(info.indApp ?? ''),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    multiLang.ui,
                    SizedBox(
                      width: ConstSetting.labelSizeboxLength,
                      child: DropdownList(
                        onChanged: (newVal) {
                          typeController.text = newVal;
                        },
                        hintText: info.lstLayoutType.isEmpty
                            ? ''
                            : info.lstLayoutType.first.toString(),
                        textController: typeController,
                        items: info.lstLayoutType.isNotEmpty
                            ? info.lstLayoutType.map((item) {
                                return DropdownMenuItem<String>(
                                    value: item.toString(),
                                    child: DropdownMenuItemSeparator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        name: item.toString()));
                              }).toList()
                            : [],
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ContentTemplate(
                    multiLang.lang,
                    SizedBox(
                      width: ConstSetting.labelSizeboxLength,
                      child: DropdownList(
                        onChanged: (newVal) {
                          languageController.text = newVal;
                        },
                        hintText: MessageUtils.getMessage(
                                info.languageCodeCurrent ?? '') ??
                            '',
                        textController: typeController,
                        items: info.lstlanguage.isNotEmpty
                            ? info.lstlanguage.map((item) {
                                return DropdownMenuItem<String>(
                                    value: item.languageCode,
                                    child: DropdownMenuItemSeparator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        name: MessageUtils.getMessage(
                                                item.languageName) ??
                                            ''));
                              }).toList()
                            : [],
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                // ContentTemplate(
                //     '',
                //     SizedBox(
                //       width: ConstSetting.labelSizeboxLength,
                //       child: AppButton(
                //           backgroundColor: AppColor.mainAppColor,
                //           height: 40,
                //           title: ConstSetting.btnDelData),
                //     )),
                SizedBox(
                  width: ConstSetting.labelSizeboxLength,
                  height: 40,
                  child: AppButton(
                    backgroundColor: AppColor.mainAppColor,
                    height: Contants.heightButton,
                    title: multiLang.submit,
                    onPress: () {
                      context
                          .read<SettingCubit>()
                          .changeLanguage(languageController.text);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: ConstSetting.labelSizeboxLength,
                  height: 40,
                  child: AppButton(
                    backgroundColor: AppColor.mainAppColor,
                    height: Contants.heightButton,
                    title: multiLang.exportDatabase,
                    onPress: () {
                      context
                          .read<SettingCubit>()
                          .exportDatabaseAndUpload();
                    },
                  ),
                ),
              ]),
            ));
      },
    );
  }
}

class ContentTemplate extends StatelessWidget {
  final String label;
  final SizedBox sizeBoxContent;
  const ContentTemplate(this.label, this.sizeBoxContent, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: ConstSetting.totalSizeboxLength,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: ConstSetting.labelSizeboxLength,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              sizeBoxContent
            ],
          ),
        )
      ],
    );
  }
}

final _formKey = GlobalKey<FormState>();

class TestDropDownState extends StatefulWidget {
  final String typeDropdown;
  const TestDropDownState(this.typeDropdown, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TestDropDownState();
  }
}

class _TestDropDownState extends State<TestDropDownState> {
  late String _typeDropdown;
  late List<String> _lstDropdownValue;

  @override
  void initState() {
    super.initState();
    // _typeDropdown = widget.typeDropdown == 'TYPE_DISPLAY'
    //     ? ConstSetting.lstTypeDisplay.first
    //     : ConstSetting.lstTypeLanguage.first;
    // _lstDropdownValue = widget.typeDropdown == 'TYPE_DISPLAY'
    //     ? ConstSetting.lstTypeDisplay
    //     : ConstSetting.lstTypeLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        hint: Text(
          _lstDropdownValue.first,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: _lstDropdownValue
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
    );
  }
}

class ConstSetting {
  static const double labelSizeboxLength = 200;
  static const double contentSizeboxLength = 400;
  static const double totalSizeboxLength = 600;
}
