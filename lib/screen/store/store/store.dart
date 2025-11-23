import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/screen/store/store/cubit/store_cubit.dart';
import 'package:horeca/screen/store/store/cubit/store_state.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horeca_service/model/product_stock.dart';
import 'package:intl/intl.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreCubit()..init(),
      child: const StoreBody(),
    );
  }
}

class StoreBody extends StatefulWidget {
  const StoreBody({super.key});

  @override
  State<StoreBody> createState() => _StoreBodyState();
}

class _StoreBodyState extends State<StoreBody> {
  List<Map<String, dynamic>> columnDataProduct = [
    {'title': 'STT', 'width': .05},
    {'title': 'Mã phân bổ', 'width': .12},
    {'title': 'PB từ', 'width': .08},
    {'title': 'Nội dung', 'width': .15},
    {'title': 'Ngày tạo', 'width': .1},
    {'title': 'Ngày nhận hàng', 'width': .1},
    {'title': 'Tổng số lượng', 'width': .1},
    {'title': 'Trạng thái', 'width': .08},
    {'title': 'Ghi chú', 'width': .1}
  ];

  List<List<String>> rowDataProduct = [
    [
      '1',
      'ACHCM_BA11120231',
      'HCM_SUP07',
      'SUP phân bổ hàng cho BA',
      '05/12/2023',
      '05/12/2023',
      '100',
      'Đã xác nhận',
      ''
    ],
  ];
  // List<Map<String, dynamic>> columnDataDTC = [
  //   {'title': 'STT', 'width': .05},
  //   {'title': 'Sản phẩm', 'width': .2},
  //   {'title': 'Nhãn hiệu', 'width': .12},
  //   {'title': 'Công ty', 'width': .12},
  //   {'title': 'Đơn vị', 'width': .08},
  //   {'title': 'Lỗi', 'width': .08},
  //   {'title': 'Không lỗi', 'width': .08},
  //   {'title': 'Tồn kho', 'width': .08},
  // ];

  // List<List<String>> rowDataDTC = [
  //   ['1', 'Mì 3 miền chua cay', 'ACV', 'ACV', 'pack', '0', '97', '97'],
  // ];

  List<List<String>> rowDataDTC = [
    // ['1', 'Mì 3 miền chua cay', 'ACV', 'ACV', 'pack', '5000', '2000', '3000'],
  ];

  bool isDTC = false;
  bool isLoadingScreen = false;
  bool isLoadingItems = false;
  List<ProductStock> lstProductStock = [];

  final DatatableController _datatableController = DatatableController(-1);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> columnDataDTC = [
      {'title': multiLang.no, 'width': .05},
      {'title': multiLang.product, 'width': .2},
      {'title': multiLang.brand, 'width': .12},
      {'title': multiLang.company, 'width': .12},
      {'title': multiLang.unit, 'width': .08},
      {'title': multiLang.initAllocation, 'width': .08},
      {'title': multiLang.usedAllocation, 'width': .08},
      {'title': multiLang.availableAllocation, 'width': .08},
    ];

    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingInit) {
          isLoadingScreen = true;
        }
        if (state is LoadingItem) {
          isLoadingItems = true;
        }
        if (state is ClickTabSuccess) {
          isLoadingItems = false;
          isDTC = state.isDTC;
        }
        if (state is ProductInitialSuccess) {
          lstProductStock = state.lstProductStock;
          for (var i = 0; i < lstProductStock.length; i++) {
            ProductStock itemRow = lstProductStock[i];
            List<String> dataRow = [
              (i + 1).toString(),
              itemRow.productName ?? '',
              itemRow.type ?? '',
              'ACV',
              itemRow.uom ?? '',
              // itemRow.allocationStock!.toInt().toString() ?? '',
              NumberFormat.decimalPattern()
                  .format(itemRow.allocationStock ?? 0),
              NumberFormat.decimalPattern().format(
                  (itemRow.orderUsedStock ?? 0) +
                      (itemRow.promotionUsedStock ?? 0)),
              NumberFormat.decimalPattern().format(
                  (itemRow.allocationStock ?? 0) -
                      ((itemRow.orderUsedStock ?? 0) +
                          (itemRow.promotionUsedStock ?? 0)))
            ];
            rowDataDTC.add(dataRow);
          }
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.mainAppColor,
            title: Center(
                child: Text(
              AppLocalizations.of(context)!.allocation,
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
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              // SizedBox(
              //   height: Contants.heightTab,
              //   child: Row(children: [
              //     InkWell(
              //       onTap: () {
              //         isDTC = false;
              //         context.read<StoreCubit>().clickTab(isDTC);
              //       },
              //       child: SizedBox(
              //         width: MediaQuery.of(context).size.width / 2,
              //         height: Contants.heightTab,
              //         child: Column(
              //           children: [
              //             const Padding(
              //               padding: EdgeInsets.only(top: 15, bottom: 10),
              //               child: Text(
              //                 'PHÂN BỔ HÀNG',
              //                 style: TextStyle(
              //                     fontSize: 16, fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //             Divider(
              //               thickness: 5,
              //               color: isDTC
              //                   ? AppColor.transparent
              //                   : AppColor.mainAppColor,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //     // InkWell(
              //     //   onTap: () {
              //     //     isDTC = true;
              //     //     context.read<StoreCubit>().clickTab(isDTC);
              //     //   }
              //     //   ,
              //     //   child: SizedBox(
              //     //     width: MediaQuery.of(context).size.width / 2 - 50,
              //     //     child: Column(
              //     //       children: [
              //     //         const Padding(
              //     //           padding: EdgeInsets.only(top: 15, bottom: 10),
              //     //           child: Text(
              //     //             'TỒN KHO',
              //     //             style: TextStyle(
              //     //                 fontSize: 16, fontWeight: FontWeight.bold),
              //     //           ),
              //     //         ),
              //     //         Divider(
              //     //           thickness: 5,
              //     //           color: !isDTC
              //     //               ? AppColor.transparent
              //     //               : AppColor.mainAppColor,
              //     //         )
              //     //       ],
              //     //     ),
              //     //   )
              //     //   ,
              //     // )
              //   ]),
              // ),
              // Expanded(
              //   child: !isDTC
              //       ? DatatableWidget(
              //           datatableController: _datatableController,
              //           callback: (value) => context.push('/storedetail'),
              //           columnData: columnDataProduct,
              //           rowData: rowDataProduct,
              //           width: width)
              //       : DatatableWidget(
              //           datatableController: _datatableController,
              //           columnData: columnDataDTC,
              //           rowData: rowDataDTC,
              //           width: width),
              // ),
              Expanded(
                  child: DatatableWidget(
                      datatableController: _datatableController,
                      columnData: columnDataDTC,
                      rowData: rowDataDTC,
                      width: width)),
            ]),
          ),
        );
      },
    );
  }
}
