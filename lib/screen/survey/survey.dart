import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horeca/screen/survey/cubit/survey_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class SurveyScreen extends StatelessWidget {
  int customerVisitId;
  int surveyId;

  SurveyScreen({
    Key? key,
    required this.customerVisitId,
    required this.surveyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyCubit(context)..init(surveyId),
      child: SurveyBody(
        customerVisitId: customerVisitId,
        surveyId: surveyId,
      ),
    );
  }
}

class SurveyBody extends StatefulWidget {
  int customerVisitId;
  int surveyId;

  SurveyBody({Key? key, required this.customerVisitId, required this.surveyId})
      : super(key: key);

  @override
  State<SurveyBody> createState() => _SurveyDetailBodyState();
}

class _SurveyDetailBodyState extends State<SurveyBody> {
  late final WebViewController _controller;
  String htmlPath = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView(htmlPath);
  }

  void _initializeWebView(String path) {
    // Initialize WebView
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    // final WebViewController controller =
    //     WebViewController.fromPlatformCreationParams(params);

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {},
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'handleObserver',
        onMessageReceived: (JavaScriptMessage message) {
          final resultDetail = message.message;
          print('surveyResult $resultDetail');
          context.read<SurveyCubit>().saveSurveyResult(
              widget.customerVisitId, widget.surveyId, resultDetail);
        },
      )
      ..loadFile(path);

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SurveyCubit, SurveyState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainAppColor,
          title: Center(
              child: Text(
            AppLocalizations.of(context)!.surveyContent,
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
              padding: const EdgeInsets.only(
                right: 16.0,
              ),
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
        body: WebViewWidget(controller: _controller),
      );
    }, listener: (context, state) {
      if (state is LoadingInitSuccess) {
        htmlPath = state.htmlPath;
        _controller.loadFile(htmlPath);
        print('htmlPathhh $htmlPath');
      }
      if (state is SaveSurveyResultFail) {
        Fluttertoast.showToast(
          msg: CommonUtils.firstLetterUpperCase(state.error.toString()),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
          backgroundColor: AppColor.errorColor,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
      if (state is SaveSurveyResultSuccess) {
        Fluttertoast.showToast(
          // msg: 'Thực hiện khảo xác thành công',
          msg: CommonUtils.firstLetterUpperCase(state.msg),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
          backgroundColor: AppColor.successColor,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    });
  }
}
