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
    super.didPush(route, previousRoute);
    // Schedule check after frame to avoid _debugLocked assertion
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDateLogin());
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Schedule check after frame to avoid _debugLocked assertion
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDateLogin());
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // Schedule check after frame to avoid _debugLocked assertion
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDateLogin());
  }

  void _checkDateLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateLogin = prefs.getString(Session.dateLogin.toString());
    BuildContext? context = appRoute.routerDelegate.navigatorKey.currentContext;

    var connect = await Connectivity().checkConnectivity();
    if (context != null && context.mounted) {
      if ((connect == ConnectivityResult.wifi ||
          connect == ConnectivityResult.mobile)) {
        if (dateLogin != null) {
          DateTime loginDate = DateTime.parse(dateLogin);
          DateTime currentDate = DateTime.now();

          if (loginDate.year != currentDate.year ||
              loginDate.month != currentDate.month ||
              loginDate.day != currentDate.day) {
            await CommonUtils.logout();
            if (context.mounted) {
              GoRouter.of(context).go('/');
            }
          }
        } else {
          await CommonUtils.logout();
          if (context.mounted) {
            GoRouter.of(context).go('/');
          }
        }
      }
    }
  }
}
