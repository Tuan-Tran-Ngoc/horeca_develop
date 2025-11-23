import 'package:flutter/material.dart';

extension InherititExtension on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;
}

extension CurrencyFormat on double {
  String asMoney() {
    if (this == 0.0) {
      return this.toInt().toString();
    }
    var price = this.toInt().toString();
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      return value;
    }
    return price;
  }

  String get _asVNCurrency => '${this.asMoney()}₫';


  String get asCurrency => _asVNCurrency;
  String get asDoubleFormatCurrency => this.asMoney();
}