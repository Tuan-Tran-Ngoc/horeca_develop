import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/buy/order/cubit/promotion_popup_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_promotion_dto.dart';

class PromotionPopup extends StatelessWidget {
  final double width;
  final double height;
  final int customerId;
  final List<ProductDto> lstProduct;
  final List<SchemePromotionDto> lstSchemeAvailable;
  final void Function(List<SchemePromotionDto>) onResultScheme;

  const PromotionPopup(
      {Key? key,
      required this.width,
      required this.height,
      required this.customerId,
      required this.lstProduct,
      required this.lstSchemeAvailable,
      required this.onResultScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PromotionPopupCubit()
          ..init(customerId, lstProduct, lstSchemeAvailable),
        child: PromotionPopupBody(
          width: width,
          height: height,
          customerId: customerId,
          lstProduct: lstProduct,
          onResultScheme: onResultScheme,
        ));
  }
}

class PromotionPopupBody extends StatefulWidget {
  final double width;
  final double height;
  final int customerId;
  final List<ProductDto> lstProduct;
  final void Function(List<SchemePromotionDto>) onResultScheme;

  const PromotionPopupBody(
      {super.key,
      required this.width,
      required this.height,
      required this.customerId,
      required this.lstProduct,
      required this.onResultScheme});

  @override
  State<PromotionPopupBody> createState() => _PromotionPopupState();
}

class _PromotionPopupState extends State<PromotionPopupBody> {
  List<PromotionDto> lstPromotion = [];

  bool _selectAll = false;
  List<Map<String, dynamic>> columnDataPromotion = [];

  List<SchemePromotionDto> chooseSchemePromotion(
      List<PromotionDto> lstPromotion) {
    List<SchemePromotionDto> results = lstPromotion
        .map((promotion) =>
            promotion.lstSchemeOrder!.where((scheme) => scheme.isChoose!))
        .expand((schemes) => schemes)
        .toList();

    results.sort((a, b) => a.priority.compareTo(b.priority));

    return results;
  }

  header(List<Map<String, dynamic>> columnData) {
    return [
      ...columnData.map((column) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          width: widget.width * column['width'],
          child: Text(
            column['title'],
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
      Checkbox(
        value: _selectAll,
        activeColor: Colors.green,
        onChanged: (value) {
          _selectAll = value!;

          if (widget.lstProduct.isEmpty) {
            return;
          }
          if (value == true) {
            context.read<PromotionPopupCubit>().applyAllPromotion(
                widget.customerId, lstPromotion, widget.lstProduct);
          } else {
            setState(() {
              _selectAll = value!;
              lstPromotion.forEach((promotion) {
                promotion.lstSchemeOrder!.forEach((scheme) {
                  scheme.isChoose = false;
                  scheme.isAllowed = true;
                  scheme.priority = 0;
                });
              });
            });
          }
        },
      ),
    ];
  }

  Widget schemeContent(List<SchemePromotionDto> lstShcheme) {
    int getMaxPriority(List<PromotionDto> lstPromotion) {
      int maxPriority = 0;
      for (PromotionDto promotion in lstPromotion) {
        for (SchemePromotionDto scheme in promotion.lstSchemeOrder ?? []) {
          if (scheme.priority > maxPriority) {
            maxPriority = scheme.priority;
          }
        }
      }

      return maxPriority;
    }

    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
          children: lstShcheme.map((scheme) {
        final int index = lstShcheme.indexOf(scheme);
        return Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: widget.width * 0.91,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      scheme.schemeContent ?? '',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Checkbox(
                  value: scheme.isChoose, // Trạng thái của checkbox
                  onChanged: (scheme.isAllowed == false)
                      ? null
                      : (value) {
                          setState(() {
                            scheme.isChoose = value;
                            if (value == true) {
                              scheme.priority =
                                  getMaxPriority(lstPromotion) + 1;
                            }
                          });
                          context
                              .read<PromotionPopupCubit>()
                              .eventChoosePromotion(widget.customerId,
                                  lstPromotion, widget.lstProduct);
                        },

                  activeColor: Colors.green,
                )
              ],
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
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    //STT
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: widget.width * columnDataPromotion[0]['width'],
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
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: widget.width * columnDataPromotion[1]['width'],
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
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: widget.width * columnDataPromotion[2]['width'],
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
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: widget.width * columnDataPromotion[3]['width'],
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
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: widget.width * columnDataPromotion[4]['width'],
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
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: widget.width * columnDataPromotion[5]['width'],
                      child: Checkbox(
                        value: promotion.promotionType == '00' ? true : false,
                        onChanged: (bool? value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            schemeContent(promotion.lstSchemeOrder!)
          ],
        );
      }).toList(),
    );
  }

  Widget dialogContent(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    columnDataPromotion = [
      {'title': multiLang.no, 'width': .08},
      {'title': multiLang.promotionCode, 'width': .20},
      {'title': multiLang.promotionName, 'width': .26},
      {'title': multiLang.fromDate, 'width': .12},
      {'title': multiLang.toDate, 'width': .12},
      {'title': multiLang.accumulated, 'width': .13}
    ];
    return Container(
      color: Colors.white,
      width: widget.width,
      height: widget.height,
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            // margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                color: AppColor.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: const Color.fromRGBO(232, 40, 37, 1),
                  height: Contants.heightHeader,
                  child: Center(
                      child: Text(
                    multiLang.listOf(multiLang.promotion).toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Container(
                            color: AppColor.disableBackgroundColor,
                            height: Contants.heightTab,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Row(
                                children: header(columnDataPromotion),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          promotionContent(lstPromotion)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 60,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: AppButton(
                      backgroundColor: AppColor.mainAppColor,
                      height: 55,
                      width: widget.width / 3,
                      title: multiLang.select,
                      onPress: () {
                        context
                            .read<PromotionPopupCubit>()
                            .warningProductAvailable(
                                widget.customerId,
                                chooseSchemePromotion(lstPromotion),
                                widget.lstProduct);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            top: 10,
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PromotionPopupCubit, PromotionPopupState>(
      listener: (context, state) {
        if (state is StartEventChoosePromotion) {}

        if (state is ClickBtnSelectStart) {}

        if (state is ClickBtnSelectSuccess) {
          if (state.notify.isEmpty) {
            Navigator.of(context).pop();
            widget.onResultScheme(chooseSchemePromotion(lstPromotion));
          } else {
            AppLocalizations multiLang = AppLocalizations.of(context)!;
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                final ButtonStyle flatButtonStyle = TextButton.styleFrom(
                  minimumSize: const Size(20, 20),
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.all(0),
                );
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.notification.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.notify,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              widget.onResultScheme(
                                  chooseSchemePromotion(lstPromotion));
                            },
                            child: Text(multiLang.ok),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
      builder: (context, state) {
        print('state: $state');

        if (state is LoadingInitialPromotion) {
          lstPromotion = state.lstPromotion;
        }

        if (state is EventChoosePromotionSucessful) {
          lstPromotion = state.lstPromotion;
        }

        if (state is EventApplyAllPromotionSuccess) {
          lstPromotion = state.lstPromotion;
        }

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
        );
      },
    );
  }
}
