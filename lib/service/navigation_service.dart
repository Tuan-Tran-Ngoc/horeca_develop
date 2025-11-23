import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/config/app_router.dart';
import 'package:horeca/screen/login/login.dart';

extension NavigationExtensions on BuildContext {
  void pushNamed(String name, Object? params) =>
      NavigationService.pushNamed(this, name, params: params);
  void push(String name, Object? params) =>
      NavigationService.push(this, name, params: params);
}

class NavigationService {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static void pushNamed(BuildContext context, String name, {Object? params}) {
    // return GoRouter.of(context).pushNamed(name);
    Navigator.of(context).pushNamed(name);
  }

  static void push(BuildContext context, String name, {Object? params}) {
    return GoRouter.of(context).push(name, extra: params);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rLoginScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LoginScreen());
      // case rHomeScreen:
      //   return MaterialPageRoute(
      //       settings: settings, builder: (_) => TabsScreenView());

      default:
        return _errorRoute(settings: settings);
    }
  }

  static Route<dynamic> _errorRoute({RouteSettings? settings}) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: const Center(
                child: Text('Không tìm thấy route'),
              ));
        });
  }
}
