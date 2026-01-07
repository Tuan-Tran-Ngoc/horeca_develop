// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/contants/contants.dart';

import 'package:horeca/screen/customer/cubit_customer_detail/customer_detail_cubit.dart';
import 'package:horeca/screen/customer_detail/buy/main/buy.dart';
import 'package:horeca/screen/customer_detail/gallery/gallery.dart';
import 'package:horeca/screen/customer_detail/product/product.dart';
import 'package:horeca/screen/customer_detail/promotion/promotion.dart';
import 'package:horeca/screen/customer_detail/summary/summary.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerDetailScreen extends StatelessWidget {
  final int routeId;
  final int customerId;
  int customerVisitId;
  int? indexScreen;
  CustomerDetailScreen(
      {super.key,
      required this.routeId,
      required this.customerId,
      required this.customerVisitId,
      this.indexScreen});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CustomerDetailCubit()..init(customerId, customerVisitId),
      child: CustomerDetailBody(
        routeId: routeId,
        customerId: customerId,
        customerVisitId: customerVisitId,
        indexScreen: indexScreen,
      ),
    );
  }
}

class CustomerDetailBody extends StatefulWidget {
  final int routeId;
  final int customerId;
  int customerVisitId;
  int? indexScreen;
  CustomerDetailBody(
      {super.key,
      required this.routeId,
      required this.customerId,
      required this.customerVisitId,
      this.indexScreen});

  @override
  State<CustomerDetailBody> createState() => _CustomerDetailBodyState();
}

class _CustomerDetailBodyState extends State<CustomerDetailBody> {
  int currentIndex = 0;
  bool isLoadingScreen = false;
  bool isLoadingItems = false;
  bool isStartVisit = false;
  // int? customerVisitId = 0;
  String? customerName = '';
  String statusVisit = '';
  int customerAddressId = 0;

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    currentIndex = ((widget.indexScreen == null) ? 0 : widget.indexScreen) ?? 0;
    print('customerId ${widget.customerId}');
    List<Map<String, dynamic>> leftMenu = [
      {
        'id': 0,
        'title': multiLang.merchandise,
        'icon': 'assets/icons_app/submenu_stock-allocation.png',
        'route': ProductScreen(
          key: ValueKey('product_${widget.customerId}_${widget.customerVisitId}'),
          routeId: widget.routeId,
          customerId: widget.customerId,
          customerVisitId: widget.customerVisitId,
          statusVisit: statusVisit,
          customerAddressId: customerAddressId,
          onResultCustomerVisitId:
              (customerVisitId, newStatusVisit, newcustomerAddressId) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                statusVisit = newStatusVisit;
                widget.customerVisitId = customerVisitId;
                customerAddressId = newcustomerAddressId;
              });
            });
            print(
                'customerVisitId001: ${widget.customerVisitId} - $statusVisit');
          },
        )
      },
      {
        'id': 1,
        'title': multiLang.program,
        'icon': 'assets/icons_app/submenu_redeem.png',
        'route': PromotionScreen(
          customerId: widget.customerId,
        )
      },
      {
        'id': 2,
        'title': multiLang.purchase,
        'icon': 'assets/icons_app/submenu_order.png',
        'route': BuyScreen(
          key: ValueKey('buy_${widget.customerId}_${widget.customerVisitId}'),
          customerId: widget.customerId,
          customerVisitId: widget.customerVisitId,
          statusVisit: statusVisit,
        )
      },
      {
        'id': 3,
        'title': multiLang.summary,
        'icon': 'assets/icons_app/submenu_summary.png',
        'route': SummaryScreen(
          key: ValueKey('summary_${widget.customerId}_${widget.customerVisitId}'),
          customerVisitId: widget.customerVisitId,
          customerId: widget.customerId,
          customerAddressId: customerAddressId,
          statusVisit: statusVisit,
        )
      },
      {
        'id': 4,
        'title': multiLang.gallery,
        'icon': 'assets/icons_app/photo-list-icon.png',
        'route': const GalleryScreen()
      },
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainAppColor,
        title: Center(
            child: Text(
          customerName ?? '',
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
                Navigator.of(context).pop(widget.customerVisitId);
              },
              child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset('assets/icons_app/back.png')),
            ),
          ),
        ],
      ),
      body: BlocConsumer<CustomerDetailCubit, CustomerDetailState>(
        listener: (context, state) {
          if (state is CustomerDetailInitSuccess) {
            setState(() {
              isLoadingScreen = false;
              customerName = state.customerName;
              widget.customerVisitId = state.customerVisitId;
              statusVisit = state.statusVisit;
              print('customerName $customerName');
            });
            print('customerName $customerName');
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is LoadingInit) {
            isLoadingScreen = true;
          }
          if (state is LoadingItem) {
            isLoadingItems = true;
          }
          if (state is CustomerDetailInitSuccess) {
            isLoadingScreen = false;
            widget.customerVisitId = state.customerVisitId;
          }
          if (state is ClickMenuSuccess) {
            isLoadingItems = false;
            currentIndex = state.index;
          }
          return Row(
            children: [
              LeftMenu(leftMenu: leftMenu, currentIndex: currentIndex),
              Expanded(child: leftMenu[currentIndex]['route'])
            ],
          );
        },
      ),
    );
  }
}

class LeftMenu extends StatelessWidget {
  List<Map<String, dynamic>> leftMenu;
  int currentIndex;
  LeftMenu({Key? key, required this.leftMenu, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / leftMenu.length;
    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(255, 209, 224, 255),
        width: Contants.widthLeftMenu,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: leftMenu.map((menu) {
            return InkWell(
                onTap: () {
                  context.read<CustomerDetailCubit>().clickMenu(menu['id']);
                },
                child: Container(
                  color: currentIndex == menu['id'] * 1
                      ? Colors.white
                      : Colors.transparent,
                  height: height,
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          height: height / 2,
                          width: height / 2,
                          child: Image.asset(
                            menu['icon'].toString(),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        // width: 100,
                        height: height / 2,

                        child: Center(
                          child: Text(
                            menu['title'].toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }).toList(),
        ),
      ),
    );
  }
}
