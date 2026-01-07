import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductInfoPopup extends StatefulWidget {
  ProductDto product;
  final void Function(int) onResultChanged;

  ProductInfoPopup(
      {Key? key, required this.product, required this.onResultChanged})
      : super(key: key);

  @override
  _ProductPopupState createState() => _ProductPopupState();
}

class _ProductPopupState extends State<ProductInfoPopup> {
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantityController.text = (widget.product.quantity ?? 0).toInt().toString();
    quantityController.addListener(() {
      if (quantityController.text == '0') {
        quantityController.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(multiLang.productInformation),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${multiLang.productCode}:'),
                  Text(widget.product.productCd ?? ''),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${multiLang.stock}:'),
                  Text(NumberFormat.decimalPattern()
                      .format(widget.product.stockBalance ?? 0)),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${multiLang.price}:'),
                  Text(CommonUtils.displayCurrency(widget.product.salesPrice))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${multiLang.quantity}:'),
                  SizedBox(
                    width: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(multiLang.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            int quantity = int.tryParse(quantityController.text) ?? 0;
            widget.onResultChanged(quantity);
            Navigator.pop(context);
          },
          child: Text(multiLang.confirm),
        ),
      ],
    );
  }
}
