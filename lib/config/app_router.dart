import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/date_login_observer.dart';
import 'package:horeca/screen/customer/customer.dart';
import 'package:horeca/screen/customer/customer_detail.dart';
import 'package:horeca/screen/customer_detail/buy/order/create_buy_order.dart';
import 'package:horeca/screen/customer_detail/buy/order_detail/order_detail.dart';
import 'package:horeca/screen/customer_detail/gallery/gallery.dart';
import 'package:horeca/screen/home/home.dart';
import 'package:horeca/screen/login/login.dart';
import 'package:horeca/screen/refund/refund.dart';
import 'package:horeca/screen/setting/setting.dart';
import 'package:horeca/screen/shift/shift.dart';
import 'package:horeca/screen/store/store/store.dart';
import 'package:horeca/screen/store/store_detail/store_detail.dart';
import 'package:horeca/screen/survey/survey.dart';
import 'package:horeca/screen/sync/sync.dart';

const String rLoginScreen = '/';
const String nLoginScreen = 'LoginScreen';
const String rHomeScreen = '/home';
const String nHomeScreen = 'HomeScreen';
const String rShiftScreen = '/shift';
const String nShiftScreen = 'ShiftScreen';
const String rCustomerScreen = '/customer';
const String nCustomerScreen = 'CustomerScreen';
const String rCustomerDetailScreen = '/customerdetail';
const String nCustomerDetailScreen = 'CustomerDetailScreen';
const String rStoreScreen = '/store';
const String nStoreScreen = 'StoreScreen';
const String rStoreDetailScreen = '/storedetail';
const String nStoreDetailScreen = 'StoreDetailScreen';
const String rRefundScreen = '/refund';
const String nRefundScreen = 'RefundScreen';
const String rSettingScreen = '/setting';
const String nSettingScreen = 'SettingScreen';
const String rSyncScreen = '/sync';
const String nSyncScreen = 'SyncScreen';
const String rCreateOrderScreen = '/createorder';
const String nCreateOrderScreen = 'CreateOrder';
const String rCreateBuyOrderScreen = '/createbuyorder';
const String nCreateBuyOrderScreen = 'CreateBuyOrder';
const String rSurveyScreen = '/survey';
const String nSurveyScreen = 'Survey';
const String rSurveyDetailScreen = '/surveydetail';
const String nSurveyDetailScreen = 'SurveyDetail';
const String rGallaryScreen = '/gallery';
const String nGallaryScreen = 'Gallery';
const String rOrderDetailScreen = '/orderdetail';
const String nOrderDetailScreen = 'OrderDetail';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRoute = GoRouter(
  // main routes that can be accessed directly at app launch
  navigatorKey: navigatorKey,
  observers: [DateLoginObserver()],
  routes: <GoRoute>[
    GoRoute(
      path: rLoginScreen,
      name: nLoginScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: rHomeScreen,
      name: nHomeScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: rShiftScreen,
      name: nShiftScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ShiftScreen();
      },
    ),
    GoRoute(
      path: rCustomerScreen,
      name: nCustomerScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const CustomerScreen();
      },
    ),
    GoRoute(
      path: rCustomerDetailScreen,
      name: nCustomerDetailScreen,
      builder: (BuildContext context, GoRouterState state) {
        Map<String, int> args = state.extra as Map<String, int>;
        return CustomerDetailScreen(
            routeId: args['routeId']!,
            customerId: args['customerId']!,
            customerVisitId: args['customerVisitId']!);
      },
    ),
    GoRoute(
      path: rStoreScreen,
      name: nStoreScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const StoreScreen();
      },
    ),
    GoRoute(
      path: rStoreDetailScreen,
      name: nStoreDetailScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const StoreDetailScreen();
      },
    ),
    GoRoute(
      path: rRefundScreen,
      name: nRefundScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const RefundScreen();
      },
    ),
    GoRoute(
      path: rSettingScreen,
      name: nSettingScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingScreen();
      },
    ),
    GoRoute(
      path: rSyncScreen,
      name: nSyncScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const SyncScreen();
      },
    ),
    GoRoute(
      path: rCreateBuyOrderScreen,
      name: nCreateBuyOrderScreen,
      builder: (BuildContext context, GoRouterState state) {
        Map<String, int> args = state.extra as Map<String, int>;
        return CreateBuyOrderScreen(
          customerId: args['customerId']!,
          customerVisitId: args['customerVisitId']!,
        );
      },
    ),
    GoRoute(
      path: rSurveyScreen,
      name: nSurveyScreen,
      builder: (BuildContext context, GoRouterState state) {
        Map<String, int?> args = state.extra as Map<String, int?>;
        return SurveyScreen(
          surveyId: args['surveyId'] ?? 0,
          customerVisitId: args['customerVisitId'] ?? 0,
        );
      },
    ),
    // GoRoute(
    //   path: rSurveyDetailScreen,
    //   name: nSurveyDetailScreen,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const SurveyDetailScreen();
    //   },
    // ),
    GoRoute(
      path: rGallaryScreen,
      name: nGallaryScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const GalleryScreen();
      },
    ),
    GoRoute(
      path: rOrderDetailScreen,
      name: nOrderDetailScreen,
      builder: (BuildContext context, GoRouterState state) {
        Map<String, int> args = state.extra as Map<String, int>;
        return OrderDetailScreen(
            customerId: args['customerId']!,
            customerVisitId: args['customerVisitId']!,
            orderId: args['id']!);
      },
    ),
  ],
);
