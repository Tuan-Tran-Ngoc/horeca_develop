import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/screen/login/cubit/login_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(context)..initLogin(),
      child: const LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController deivceController = TextEditingController();

  String? errorUsername;
  String? errorPassword;
  String? deviceid = '';
  String version = '';

  bool isVisiableIcon = true;
  bool isSaveInfoLogin = false;

  bool isReloadForm = false;
  bool isReloadControl = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    String message = "";
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    bool _validateLogin() {
      bool isPass = true;
      if (userNameController.text == "") {
        errorUsername = multiLang.enterAccount;
        isPass = false;
      }
      if (passwordController.text == "") {
        errorPassword = multiLang.enterPassword;
        isPass = false;
      }
      return isPass;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // message = [multiLang.login, multiLang.success].join(" ");
                  Fluttertoast.showToast(
                    // msg: "Đăng nhập thành công.",
                    msg: CommonUtils.firstLetterUpperCase(state.msg),
                    // msg: CommonUtils.firstLetterUpperCase(message),
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
                    backgroundColor: AppColor.successColor,
                    textColor: Colors.white,
                    fontSize: 14.0,
                  );

                  context.read<LoginCubit>().firstInitData();
                });
              }
              if (state is LoginFailed) {
                print('LoginFailed');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Fluttertoast.showToast(
                    // msg: (state).error ??
                    //     "Thông tin không đúng, vui lòng nhập lại.",
                    msg: CommonUtils.firstLetterUpperCase(state.error ?? ''),
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
                    backgroundColor: AppColor.errorColor,
                    textColor: Colors.white,
                    fontSize: 14.0,
                  );
                });
                //context.read<LoginCubit>().initLogin();
              }

              if (state is FirstInitDataSuccess) {
                if (state.msg == null || state.msg!.isEmpty) {
                  isReloadControl = false;
                  Navigator.pop(context);
                  //context.go('/home');
                } else {
                  message = [
                    [multiLang.sync, multiLang.data, multiLang.failed]
                        .join(" "),
                    multiLang.loginAgain
                  ].join(".\n");
                  isReloadControl = false;
                  Navigator.pop(context);

                  Fluttertoast.showToast(
                    // msg:
                    //     "Đồng bộ dữ liệu không thành công. Vui lòng đăng nhập lại",
                    msg: CommonUtils.firstLetterUpperCase(state.msg ?? message),
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
                    backgroundColor: AppColor.errorColor,
                    textColor: Colors.white,
                    fontSize: 14.0,
                  );
                }
              }

              if (state is UpdateDataSuccess) {
                if (state.msg == null || state.msg!.isEmpty) {
                  isReloadControl = false;
                  Navigator.pop(context);
                  context.go('/home');
                } else {
                  message = [
                    [multiLang.sync, multiLang.data, multiLang.failed]
                        .join(" "),
                    multiLang.loginAgain
                  ].join(".\n");
                  isReloadControl = false;
                  Navigator.pop(context);

                  Fluttertoast.showToast(
                    // msg:
                    //     "Đồng bộ dữ liệu không thành công. Vui lòng đăng nhập lại",
                    msg: CommonUtils.firstLetterUpperCase(state.msg ?? message),
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
                    backgroundColor: AppColor.errorColor,
                    textColor: Colors.white,
                    fontSize: 14.0,
                  );
                }
              }

              if (state is CheckInitialDataSuccess) {
                isReloadControl = false;
                context.go('/home');
              }
            },
            builder: (context, state) {
              if (state is LoginInitialSucess) {
                isReloadForm = false;
                deivceController.text = state.deviceId;
                version = state.version;
                const storage = FlutterSecureStorage();
                // userNameController.text = 'SUPDN001';
                // passwordController.text = 'SUPDN001';
                print('userNameController.text ${userNameController.text}');
                if (userNameController.text == '' &&
                    passwordController.text == '') {
                  userNameController.text = state.username;
                  passwordController.text = state.password;
                }
              }

              if (state is ReloadControl) {
                isReloadControl = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // prevent user from dismissing the dialog
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(state.msg),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 8),
                            Text(multiLang.waiting),
                          ],
                        ),
                      );
                    },
                  );
                });
              }

              if (state is ReloadForm) {
                isReloadForm = true;
              }

              if (state is TapObscureSuccess) {
                isVisiableIcon = state.isTapObscure;
                print(isVisiableIcon);
                context.read<LoginCubit>().initLogin();
              }

              return isReloadForm
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background.jpg'),
                                  fit: BoxFit.cover)),
                        ),
                        Stack(
                          children: [
                            Center(
                              child: PhysicalModel(
                                // borderRadius: BorderRadius.circular(radius),
                                color: const Color.fromARGB(255, 255, 255, 255),
                                elevation: 10.0,
                                shadowColor:
                                    const Color.fromARGB(255, 189, 189, 189),
                                child: Container(
                                  color: Colors.white,
                                  width: 400,
                                  height: 450,
                                  child: ListView(
                                    physics: const ClampingScrollPhysics(),
                                    children: <Widget>[
                                      // Header(),
                                      const SizedBox(
                                        height: 100,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 32.0, right: 32.0),
                                        child: AppTextField(
                                          prefixIcon: const Icon(
                                            Icons.phone,
                                            color: AppColor.mainAppColor,
                                          ),
                                          controller: userNameController,
                                          errorText: errorUsername,
                                          // placeHolder: 'Vui lòng nhập số điện thoại...',
                                          placeHolder:
                                              multiLang.enterAccount.toString(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      //password
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 32.0, right: 32.0),
                                        child: AppTextField(
                                            prefixIcon: const Icon(
                                              Icons.key,
                                              color: AppColor.mainAppColor,
                                            ),
                                            controller: passwordController,
                                            placeHolder: multiLang.enterPassword
                                                .toString(),
                                            errorText: errorPassword,
                                            isPassword: true,
                                            obscureText: isVisiableIcon,
                                            onTapObscureIcon: () {
                                              context
                                                  .read<LoginCubit>()
                                                  .tapObscure(!isVisiableIcon);
                                            }),
                                      ),

                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 32.0, right: 32.0),
                                        child: AppButton(
                                          backgroundColor:
                                              AppColor.mainAppColor,
                                          height: 55,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          title:
                                              multiLang.login.toString() ?? '',
                                          onPress: () {
                                            if (_validateLogin()) {
                                              errorUsername = null;
                                              errorPassword = null;

                                              context
                                                  .read<LoginCubit>()
                                                  .submitEvent(
                                                      userNameController.text,
                                                      passwordController.text);
                                            } else {
                                              setState(() {});
                                            }

                                            // context.go('/home');
                                          },
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              '${AppLocalizations.of(context)!.version}: ',
                                              style: const TextStyle(
                                                // color: RoyalHealthcareColors.primaryText,
                                                fontSize: 14,
                                                fontWeight: FontWeight
                                                    .w300, // FontWeight mỏng
                                                fontStyle: FontStyle.italic,
                                              ) // ),
                                              ),
                                          Text(
                                            version,
                                            style: const TextStyle(
                                              // color: RoyalHealthcareColors.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight
                                                  .w300, // FontWeight mỏng
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 450),
                                height: 140,
                                child: Image.asset(
                                  'assets/images/acecook.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget Header() {
    double height = 320.0;
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColor.mainAppColor, AppColor.mainAppColor])),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: height / 3 - 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 80, right: 80),
            child: Image.asset(
              'assets/images/acecook.png',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
