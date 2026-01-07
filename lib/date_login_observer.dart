import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/config/app_router.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateLoginObserver extends NavigatorObserver {
  DateLoginObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _checkDateLogin();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _checkDateLogin();
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _checkDateLogin();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _checkDateLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateLogin = prefs.getString(Session.dateLogin.toString());
    BuildContext? context = appRoute.routerDelegate.navigatorKey.currentContext;

    var connect = await Connectivity().checkConnectivity();
    if (context != null) {
      if ((connect == ConnectivityResult.wifi ||
          connect == ConnectivityResult.mobile)) {
        if (dateLogin != null) {
          DateTime loginDate = DateTime.parse(dateLogin);
          DateTime currentDate = DateTime.now();

          if (loginDate.year != currentDate.year ||
              loginDate.month != currentDate.month ||
              loginDate.day != currentDate.day) {
            await CommonUtils.logout();
            GoRouter.of(context).go('/');
          }
        } else {
          await CommonUtils.logout();
          GoRouter.of(context).go('/');
        }
      }
    }
  }
}
