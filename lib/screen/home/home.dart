import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/home/cubit/home_cubit.dart';
import 'package:horeca/screen/home/widget/slider.dart';
import 'package:horeca/screen/shift/shift_popup.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(context)..initHomeScreen(),
      child: const HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingScreen = false;
  bool isLoadingItems = false;
  bool isStartShift = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> menuList = [
      {
        'title': AppLocalizations.of(context)!.shift.toUpperCase(),
        'icon': 'assets/icons_app/mainmenu_checkin-out.png',
        'route': '/shift'
      },
      {
        'title': AppLocalizations.of(context)!.visit.toUpperCase(),
        'icon': 'assets/icons_app/mainmenu_visit.png',
        'route': '/customer'
      },
      {
        'title': AppLocalizations.of(context)!.storage.toUpperCase(),
        'icon': 'assets/icons_app/mainmenu_stock.png',
        'route': '/store'
      },
      {
        'title': AppLocalizations.of(context)!.system.toUpperCase(),
        'icon': 'assets/icons_app/mainmenu_system.png',
        'route': '/setting'
      },
      {
        'title': AppLocalizations.of(context)!.sync.toUpperCase(),
        'icon': 'assets/icons_app/synchronization-arrows.png',
        'route': '/sync'
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: "Không thể quay lại màn hình đăng nhập",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // FlutterAppMinimizer.minimize();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,

        appBar: AppBar(
          backgroundColor: AppColor.mainAppColor,
          title: Text(
            AppLocalizations.of(context)!.homeScreen,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.background),
          ),
          leading: Center(
            child: InkWell(
              onTap: () {},
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
                  context.read<HomeCubit>().logout();
                },
                child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons_app/logout.png')),
              ),
            ),
          ],
        ),
        // drawer: SlideBarMenuView(),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is LogoutSuccessful) {
              GoRouter.of(context).go('/');
              Fluttertoast.showToast(
                msg: CommonUtils.firstLetterUpperCase(state.msg),
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: Constant.SHOW_TOAST_TIME,
                backgroundColor: AppColor.successColor,
                textColor: Colors.white,
                fontSize: 14.0,
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingInit) {
              isLoadingScreen = true;
            }
            if (state is LoadingItem) {
              isLoadingItems = true;
            }
            if (state is HomeInitialSuccessful) {
              isLoadingScreen = false;
            }
            if (state is CheckStartShiftState) {
              isStartShift = state.isStartShift;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                SliderView(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
                Expanded(child: verticalProduct(menuList, isStartShift))
              ],
            );
          },
        ),
      ),
    );
  }

  verticalProduct(List<Map<String, String>> menuList, bool isStartShift) {
    double widthItem = MediaQuery.of(context).size.width / menuList.length - 10;
    final double width =
        MediaQuery.of(context).size.width - Contants.widthLeftMenu;
    final double height =
        MediaQuery.of(context).size.height - Contants.heightHeader;

    print(
        'MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}');
    print(
        'MediaQuery.of(context).size.height11 ${MediaQuery.of(context).size.height}');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: menuList.map((menu) {
        return InkWell(
            onTap: () async {
              //context.push(menu['route'].toString());
              //print('onClick: ${menu['route'].toString()}');
              
              isStartShift = await context.read<HomeCubit>().checkStartShift();
              if ((menu['route'].toString() == '/shift' ||
                      menu['route'].toString() == '/customer') &&
                  !isStartShift) {
                // ignore: use_build_context_synchronously
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return ShiftPopup(
                      width: width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                    );
                  },
                );
              } else {
                // ignore: use_build_context_synchronously
                context.push(menu['route'].toString());
              }
            },
            child: SizedBox(
              height: height * 0.4,
              width: widthItem,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // margin:
                    //     const EdgeInsets.only(right: 10, left: 10, bottom: 20),
                    width: height * 0.12,
                    height: height * 0.12,
                    decoration: const BoxDecoration(
                      color: AppColor.mainAppColor,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: height * 0.1,
                        height: height * 0.1,
                        child: Image.asset(
                          menu['icon'].toString(),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    // width: 100,
                    height: height * 0.1,
                    // color: Colors.blue,
                    child: Center(
                      child: Text(
                        menu['title'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      }).toList(),
    );
  }
}
