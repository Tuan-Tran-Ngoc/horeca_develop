part of 'product_popup_cubit.dart';

@immutable
sealed class ProductPopupState {}

final class ProductPopupInitial extends ProductPopupState {}

final class LoadingInit extends ProductPopupState {
  List<Brand> lstBrand;
  List<ProductDto> lstProductDto;
  String imagePath;
  LoadingInit(this.lstBrand, this.lstProductDto, this.imagePath);
}

final class ClickBrandItem extends ProductPopupState {}

final class LoadingProduct extends ProductPopupState {
  List<ProductDto> lstProduct;
  LoadingProduct(this.lstProduct);
}
