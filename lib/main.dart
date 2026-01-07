import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/config/app_router.dart';
import 'package:horeca/date_login_observer.dart';
import 'package:horeca/language_setting.dart';
import 'package:horeca/themes/theme.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/network/network_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DeviceType { Phone, Tablet }

DeviceType getDeviceType() {
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? DeviceType.Phone : DeviceType.Tablet;
}

void main() async {
  NetworkService.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString(Session.languageCode.toString()) != null) {
    String languageCode =
        prefs.getString(Session.languageCode.toString()).toString();
    if (languageCode == 'vi') {
      LanguageSetting().setLocale(const Locale('vi', 'VN'));
    } else {
      LanguageSetting().setLocale(const Locale('en', 'US'));
    }
  }
  var device = getDeviceType();

  // await setUpLogs();
  final directory = await getApplicationDocumentsDirectory();
  final logsDirectoryPath = '${directory.path}/FlutterLogs';
  print('Logs directory path: $logsDirectoryPath');

  //download font
  await PdfGoogleFonts.robotoRegular();
  await PdfGoogleFonts.robotoBold();

  if (device == DeviceType.Tablet) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).then((_) {
      print('landscapeLeft');
      runApp(
        ChangeNotifierProvider<LanguageSetting>(
          create: (_) => LanguageSetting(),
          child: Consumer<LanguageSetting>(
            builder: (context, languageSetting, _) {
              return MaterialApp.router(
                title: 'E-Horeca',
                theme: AppTheme.lightTheme.copyWith(),
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('vi'),
                ],
                locale: LanguageSetting.locale,
                routerConfig: appRoute,
              );
            },
          ),
        ),
      );
    });
  } else {
    print('only tablet or ipad');
    runApp(
      ChangeNotifierProvider<LanguageSetting>(
        create: (_) => LanguageSetting(),
        child: Consumer<LanguageSetting>(
          builder: (context, languageSetting, _) {
            return MaterialApp.router(
              title: 'E-Horeca',
              theme: AppTheme.lightTheme.copyWith(),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('vi'),
              ],
              locale: LanguageSetting.locale,
              routerConfig: appRoute,
            );
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
