// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/promotion/cubit/promotion_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca_service/sqflite_database/dto/discount_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromotionScreen extends StatelessWidget {
  int customerId;
  PromotionScreen({
    Key? key,
    required this.customerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromotionCubit()..init(customerId),
      child: const PromotionBody(),
    );
  }
}

class PromotionBody extends StatefulWidget {
  const PromotionBody({super.key});

  @override
  State<PromotionBody> createState() => _PromotionBodyState();
}

class _PromotionBodyState extends State<PromotionBody> {
  bool isLoadingScreen = false;
  bool isLoadingItems = false;

  int currentIndex = 0;
  List<PromotionDto> lstPromotion = [];
  List<DiscountDto> lstDiscount = [];
  @override
  Widget build(BuildContext context) {
    final double width =
        MediaQuery.of(context).size.width - Contants.widthLeftMenu;
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    List<Map<String, dynamic>> columnDataPromotion = [
      {'title': multiLang.no, 'width': .08},
      {'title': multiLang.promotionCode, 'width': .22},
      {'title': multiLang.promotionName, 'width': .32},
      {'title': multiLang.fromDate, 'width': .14},
      {'title': multiLang.toDate, 'width': .14},
      {'title': multiLang.accumulated, 'width': .1}
    ];

    List<Map<String, dynamic>> columnDataDiscount = [
      {'title': multiLang.no, 'width': .08},
      {'title': multiLang.discountCode, 'width': .22},
      {'title': multiLang.discountName, 'width': .32},
      {'title': multiLang.fromDate, 'width': .19},
      {'title': multiLang.toDate, 'width': .19},
    ];

    List<String> listTab = [
      multiLang.promotionProgram,
      multiLang.discountProgram
    ];

    return BlocConsumer<PromotionCubit, PromotionState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LoadingInit) {
          isLoadingScreen = true;
          lstPromotion = state.lstPromotion;
          lstDiscount = state.lstDiscount;
        }
        if (state is LoadingItem) {
          isLoadingItems = true;
        }
        if (state is ChangeTabSuccess) {
          isLoadingItems = false;
          currentIndex = state.index;
        }

        header(List<Map<String, dynamic>> columnData) {
          return columnData.map((column) {
            return SizedBox(
              width: width * column['width'],
              child: Text(
                column['title'],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }).toList();
        }

        Widget schemeContent(List<SchemeDto> lstShcheme) {
          return Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
                children: lstShcheme.map((scheme) {
              final int index = lstShcheme.indexOf(scheme);
              return Column(
                children: [
                  SizedBox(
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        scheme.schemeContent ?? '',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  index != (lstShcheme.length - 1)
                      ? const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColor.disableBackgroundColor,
                        )
                      : const SizedBox(),
                ],
              );
            }).toList()),
          );
        }

        Widget schemePromotionContent(List<SchemePromotionDto> lstShcheme) {
          return Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
                children: lstShcheme.map((scheme) {
              final int index = lstShcheme.indexOf(scheme);
              return Column(
                children: [
                  SizedBox(
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        scheme.schemeContent ?? '',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  index != (lstShcheme.length - 1)
                      ? const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColor.disableBackgroundColor,
                        )
                      : const SizedBox(),
                ],
              );
            }).toList()),
          );
        }

        Widget promotionContent(List<PromotionDto> lstPromotion) {
          return Column(
            children: lstPromotion.map((promotion) {
              final int index = lstPromotion.indexOf(promotion);
              return Column(
                children: [
                  Container(
                    color: AppColor.disableBackgroundColor.withOpacity(.4),
                    height: Contants.heightTab,
                    child: Row(
                      children: [
                        //STT
                        SizedBox(
                          width: width * columnDataPromotion[0]['width'],
                          child: Text(
                            (index + 1).toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //PromotionCode
                        SizedBox(
                          width: width * columnDataPromotion[1]['width'],
                          child: Text(
                            promotion.promotionCode ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //PromotionName
                        SizedBox(
                          width: width * columnDataPromotion[2]['width'],
                          child: Text(
                            promotion.promotionName ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //StartDate
                        SizedBox(
                          width: width * columnDataPromotion[3]['width'],
                          child: Text(
                            promotion.startDate ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //EndDate
                        SizedBox(
                          width: width * columnDataPromotion[4]['width'],
                          child: Text(
                            promotion.endDate ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //CheckBox
                        SizedBox(
                          width: width * columnDataPromotion[5]['width'],
                          child: Checkbox(
                            value:
                                promotion.promotionType == '00' ? true : false,
                            onChanged: (bool? value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  schemePromotionContent(promotion.lstSchemeOrder!)
                ],
              );
            }).toList(),
          );
        }

        Widget discountContent(List<DiscountDto> lstDiscount) {
          return Column(
            children: lstDiscount.map((discount) {
              final int index = lstDiscount.indexOf(discount);
              return Column(
                children: [
                  Container(
                    color: AppColor.disableBackgroundColor.withOpacity(.4),
                    height: Contants.heightTab,
                    child: Row(
                      children: [
                        //STT
                        SizedBox(
                          width: width * columnDataDiscount[0]['width'],
                          child: Text(
                            (index + 1).toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //DiscountCode
                        SizedBox(
                          width: width * columnDataDiscount[1]['width'],
                          child: Text(
                            discount.discountCode ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //PromotionName
                        Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          width: width * columnDataDiscount[2]['width'],
                          child: Text(
                            discount.discountName ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //StartDate
                        SizedBox(
                          width: width * columnDataDiscount[3]['width'],
                          child: Text(
                            discount.startDate ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //EndDate
                        SizedBox(
                          width: width * columnDataDiscount[4]['width'],
                          child: Text(
                            discount.endDate ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  schemeContent(discount.lstShemeOrder!)
                ],
              );
            }).toList(),
          );
        }

        return Column(
          children: [
            SizedBox(
              height: Contants.heightTab,
              child: Row(
                  children: listTab
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            context
                                .read<PromotionCubit>()
                                .changeTab(listTab.indexOf(e));
                          },
                          child: SizedBox(
                            width: width / listTab.length,
                            height: Contants.heightTab,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 10),
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(
                                  thickness: 5,
                                  color: currentIndex == listTab.indexOf(e)
                                      ? AppColor.mainAppColor
                                      : AppColor.transparent,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
            currentIndex == 0
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: AppColor.disableBackgroundColor,
                            height: Contants.heightTab,
                            child: Row(
                              children: header(columnDataPromotion),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          promotionContent(lstPromotion)
                        ],
                      ),
                    ),
                  )
                : currentIndex == 1
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              color: AppColor.disableBackgroundColor,
                              height: Contants.heightTab,
                              child: Row(
                                children: header(columnDataDiscount),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            discountContent(lstDiscount)
                          ]),
                        ),
                      )
                    : const SizedBox()
          ],
        );
      },
    );
  }
}
