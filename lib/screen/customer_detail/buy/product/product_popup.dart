import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/customer_detail/buy/calculate/calculate_popup.dart';
import 'package:horeca/screen/customer_detail/buy/product/cubit/cubit/product_popup_cubit.dart';
import 'package:horeca/screen/customer_detail/buy/productInfoPopup/product_info_popup.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/model/m_brand.dart';
import 'package:intl/intl.dart';

class ProductPopup extends StatelessWidget {
  final double width;
  final double height;
  final int customerId;
  final bool isCheckStock;
  final List<ProductDto> availableProduct;
  final void Function(List<ProductDto>) onResultProduct;

  const ProductPopup(
      {Key? key,
      required this.width,
      required this.height,
      required this.customerId,
      required this.isCheckStock,
      required this.availableProduct,
      required this.onResultProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductPopupCubit()..init(customerId, availableProduct),
      child: ProductPopupBody(
        width: width,
        height: height,
        isCheckStock: isCheckStock,
        onResultProduct: onResultProduct,
      ),
    );
  }
}

class ProductPopupBody extends StatefulWidget {
  final double width;
  final double height;
  final bool isCheckStock;
  final void Function(List<ProductDto>) onResultProduct;

  const ProductPopupBody(
      {super.key,
      required this.width,
      required this.height,
      required this.isCheckStock,
      required this.onResultProduct});

  @override
  State<StatefulWidget> createState() =>
      _ProductPopupBodyState(width: width, height: height);
}

class _ProductPopupBodyState extends State<ProductPopupBody> {
  final double width;
  final double height;

  _ProductPopupBodyState({required this.width, required this.height});

  List<Brand> lstBrand = [];
  List<ProductDto> lstAllProduct = [];
  List<ProductDto> lstProduct = [];
  String imagePath = '';
  bool _isTextFieldVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      String searchText = _searchController.text.toUpperCase();
      lstProduct = searchProducts(lstAllProduct, searchText);
    });
  }

  List<ProductDto> searchProducts(
      List<ProductDto> lstAllProduct, String searchValue) {
    return lstAllProduct.where((product) {
      if (product.productName != null && product.productCd != null) {
        final productNameLower = product.productName?.toLowerCase();
        final productCdLower = product.productCd?.toLowerCase();
        final searchValueLower = searchValue.toLowerCase();

        return productNameLower!.contains(searchValueLower) ||
            productCdLower!.contains(searchValueLower);
      }

      return false;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.removeListener;
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    void updateProductQuantity(int index, int newQuantity) {
      setState(() {
        lstProduct[index].quantity = newQuantity.toDouble();
      });
    }

    Widget dialogContent(BuildContext context) {
      print('width $width height $height');
      return Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: AppColor.background,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.0,
                        offset: Offset(0.0, 0.0))
                  ]),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: const Color.fromRGBO(232, 40, 37, 1),
                        height: Contants.heightHeader,
                        child: Center(
                          child: Text(
                            multiLang.listOf(multiLang.product).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: height * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(children: <Widget>[
                            Container(
                              color: AppColor.disableBackgroundColor
                                  .withOpacity(0.2),
                              width: width * 0.3,
                              child: Column(
                                children: [
                                  Container(
                                    color: AppColor.disableBackgroundColor,
                                    height: Contants.heightHeader,
                                    child: Center(
                                      child: Text(
                                        multiLang.brand.toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 16, right: 16),
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 2,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 5,
                                      children: List.generate(
                                          lstBrand.length,
                                          (index) => Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    // Xử lý sự kiện nhấp chuột ở đây
                                                    print(
                                                        'Brand ${lstBrand[index].brandId}');
                                                    context
                                                        .read<
                                                            ProductPopupCubit>()
                                                        .getProductByBrandId(
                                                            lstAllProduct,
                                                            lstBrand[index]
                                                                    .brandId ??
                                                                0);
                                                  },
                                                  child: Column(children: [
                                                    SizedBox(
                                                      height: width * 0.07,
                                                      width: width * 0.07,
                                                      child: Image.file(
                                                          File(
                                                              '$imagePath${lstBrand[index].brandImg ?? ''}'),
                                                          fit: BoxFit.contain),
                                                    ),
                                                    Text(
                                                      lstBrand[index]
                                                              .brandName ??
                                                          '',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ]),
                                                ),
                                              )),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Container(
                                  color:
                                      const Color.fromARGB(255, 241, 140, 138),
                                  height: Contants.heightHeader,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            multiLang.product.toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.filter_alt_outlined,
                                          size: 30,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isTextFieldVisible =
                                                !_isTextFieldVisible; // Toggle the visibility of the TextField
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                if (_isTextFieldVisible)
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12),
                                            border: const OutlineInputBorder(),
                                            hintText: multiLang
                                                .enterKeyWordForSearching,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                Expanded(
                                    child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 16, right: 16),
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    childAspectRatio: 2 / 2,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2,
                                    children: List.generate(
                                        lstProduct.length,
                                        (index) => Center(
                                                child: InkWell(
                                              onTap: () {
                                                print('Product onClick $index');
                                                print(
                                                    'Product onClick ${lstProduct[index].productId}');
                                                if (!widget.isCheckStock &&
                                                    lstProduct[index]
                                                            .salesPrice ==
                                                        null) {
                                                  Fluttertoast.showToast(
                                                    msg: multiLang
                                                        .errMsgNotPriceProduct,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    timeInSecForIosWeb: Constant
                                                        .SHOW_TOAST_TIME,
                                                    backgroundColor:
                                                        AppColor.errorColor,
                                                    textColor: Colors.white,
                                                    fontSize: 14.0,
                                                  );
                                                  return;
                                                }
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      if (widget.isCheckStock) {
                                                        return CalculatePopup(
                                                          width: width,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                          number:
                                                              lstProduct[index]
                                                                  .quantity
                                                                  ?.toInt(),
                                                          onResultChanged:
                                                              (result) {
                                                            print(
                                                                'result Product popup $result');
                                                            lstProduct[index]
                                                                    .quantity =
                                                                result
                                                                    .toDouble();
                                                            updateProductQuantity(
                                                                index, result);
                                                          },
                                                        );
                                                      } else {
                                                        return ProductInfoPopup(
                                                          product:
                                                              lstProduct[index],
                                                          onResultChanged:
                                                              (result) {
                                                            print(
                                                                'result Product popup $result');
                                                            lstProduct[index]
                                                                    .quantity =
                                                                result
                                                                    .toDouble();
                                                            updateProductQuantity(
                                                                index, result);
                                                          },
                                                        );
                                                      }
                                                    });
                                              },
                                              child: Column(children: [
                                                Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: width * 0.1,
                                                      width: width * 0.1,
                                                      child: Image.file(
                                                        File(
                                                            '$imagePath${lstProduct[index].productImg ?? ''}'),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    lstProduct[index]
                                                                .quantity ==
                                                            0
                                                        ? const SizedBox()
                                                        : Positioned(
                                                            bottom: 0.0,
                                                            right: 0.0,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0)),
                                                              child: Text(
                                                                NumberFormat
                                                                        .decimalPattern()
                                                                    .format(
                                                                        lstProduct[index].quantity ??
                                                                            0),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                                Text(
                                                  lstProduct[index]
                                                          .productName ??
                                                      '',
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ]),
                                            ))),
                                  ),
                                ))
                              ],
                            ))
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: AppButton(
                            title: multiLang.add,
                            backgroundColor: AppColor.mainAppColor,
                            height: 55,
                            width: width / 3,
                            onPress: () {
                              Navigator.of(context).pop();
                              widget.onResultProduct(lstAllProduct);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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

    return BlocConsumer<ProductPopupCubit, ProductPopupState>(
        listener: (context, state) {
      if (state is LoadingInit) {
        lstBrand = state.lstBrand;
        lstAllProduct = state.lstProductDto;
        lstProduct = state.lstProductDto;
        imagePath = state.imagePath;
      }
      if (state is LoadingProduct) {
        lstProduct = state.lstProduct;
      }
      if (state is ClickBrandItem) {}
    }, builder: (context, state) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      );
    });
  }
}
