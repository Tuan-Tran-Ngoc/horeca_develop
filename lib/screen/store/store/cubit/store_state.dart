import 'package:equatable/equatable.dart';
import 'package:horeca_service/model/product_stock.dart';
// part of 'store_cubit.dart';

sealed class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

final class LoadingInit extends StoreState {}

final class LoadingItem extends StoreState {}

final class ProductInitial extends StoreState {}

final class ProductInitialSuccess extends StoreState {
  List<ProductStock> lstProductStock;
  ProductInitialSuccess(this.lstProductStock);
}

final class ClickTabSuccess extends StoreState {
  bool isDTC;
  ClickTabSuccess(this.isDTC);
}
