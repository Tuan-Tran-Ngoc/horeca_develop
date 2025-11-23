import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/refund/cubit/refund_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/datatable.dart';

class RefundScreen extends StatelessWidget {
  const RefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RefundCubit()..init(),
      child: const RefundBody(),
    );
  }
}

class RefundBody extends StatefulWidget {
  const RefundBody({super.key});

  @override
  State<RefundBody> createState() => _RefundBodyState();
}

class _RefundBodyState extends State<RefundBody> {
  List<Map<String, dynamic>> columnDataProduct = [
    {'title': 'STT', 'width': .05},
    {'title': 'Mã trả hàng', 'width': .3},
    {'title': 'Nội dung', 'width': .2},
    {'title': 'Gửi đến', 'width': .1},
    {'title': 'Ngày tạo', 'width': .1},
    {'title': 'Trạng thái', 'width': .1},
  ];

  List<List<String>> rowDataProduct = [
    [
      '1',
      'SRT23482348123787_Temp',
      'SUP trả hàng cho SM',
      'HCM_SUP07',
      '29/01/2024',
      'Mới'
    ]
  ];
  List<Map<String, dynamic>> columnDataDTC = [
    {'title': 'STT', 'width': .05},
    {'title': 'Mã trả tiền', 'width': .15},
    {'title': 'Gửi đến', 'width': .3},
    {'title': 'Tổng tiền trả', 'width': .12},
    {'title': 'Ngày tạo', 'width': .1},
    {'title': 'Trạng thái', 'width': .1},
  ];

  List<List<String>> rowDataDTC = [
    [
      '1',
      'MTT23482348123787_Temp',
      'SUP hoàn tiền cho SM',
      'HCM_SUP08',
      '29/01/2024',
      'Mới'
    ]
  ];

  bool isDTC = false;
  bool isLoadingScreen = false;
  bool isLoadingItems = false;
  final DatatableController _datatableController = DatatableController(-1);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<RefundCubit, RefundState>(
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.mainAppColor,
            title: const Center(
                child: Text(
              'QUẢN LÝ HOÀN TRẢ',
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
              SizedBox(
                height: Contants.heightTab,
                child: Row(children: [
                  InkWell(
                    onTap: () {
                      isDTC = false;
                      context.read<RefundCubit>().clickTab(isDTC);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      height: Contants.heightTab,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 10),
                            child: Text(
                              'TRẢ HÀNG',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(
                            thickness: 5,
                            color: isDTC
                                ? AppColor.transparent
                                : AppColor.mainAppColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      isDTC = true;
                      context.read<RefundCubit>().clickTab(isDTC);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 10),
                            child: Text(
                              'TRẢ TIỀN MẶT',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(
                            thickness: 5,
                            color: !isDTC
                                ? AppColor.transparent
                                : AppColor.mainAppColor,
                          )
                        ],
                      ),
                    ),
                  )
                ]),
              ),
              Expanded(
                child: !isDTC
                    ? DatatableWidget(
                        datatableController: _datatableController,
                        callback: (value) => context.push('/storedetail'),
                        columnData: columnDataProduct,
                        rowData: rowDataProduct,
                        width: width)
                    : DatatableWidget(
                        datatableController: _datatableController,
                        columnData: columnDataDTC,
                        rowData: rowDataDTC,
                        width: width),
              ),
              SizedBox(
                height: 100,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 50,
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: AppButton(
                        backgroundColor: AppColor.mainAppColor,
                        height: 55,
                        title: 'Thêm mới',
                        onPress: () {},
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
