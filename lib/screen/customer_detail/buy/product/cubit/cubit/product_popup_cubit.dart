import 'package:bloc/bloc.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/product_stock.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'product_popup_state.dart';

class ProductPopupCubit extends Cubit<ProductPopupState> {
  ProductPopupCubit() : super(ProductPopupInitial());
  BrandProvider brandProvider = BrandProvider();
  ProductProvider productProvider = ProductProvider();
  StockBalanceProvider stockBalanceProvider = StockBalanceProvider();
  late SharedPreferences prefs;

  Future<void> init(int customerId, List<ProductDto> availableProduct) async {
    await loadingInitialData(customerId, availableProduct);
  }

  Future<void> loadingInitialData(
      int customerId, List<ProductDto> availableProduct) async {
    prefs = await SharedPreferences.getInstance();
    var baPositionId = prefs.getInt('baPositionId');
    String username = prefs.getString('username') ?? '';
    List<Brand> lstBrand =
        await brandProvider.getBrandByStatus(Constant.stsBrdAct);
    List<ProductDto> lstProductDto =
        await productProvider.getAllInfoProduct(customerId);

    List<ProductStock> lstProductStock =
        await stockBalanceProvider.getListStockBalance(
            baPositionId ?? 0,
            DateFormat(Constant.dateFormatterYYYYMMDD).format(DateTime.now()),
            null);

    lstProductDto = assignStock(lstProductDto, lstProductStock);
    lstProductDto.map((product) => {});

    if (availableProduct.isNotEmpty) {
      replaceElements(lstProductDto, availableProduct);
    }

    // image path
    //Directory tempDir = await getTemporaryDirectory();/
    //String imagePath = '${tempDir.path}/masterdata/masterPhoto/';
    var databasesPath = await getDatabasesPath();
    String imagePath = '$databasesPath/$username/masterPhoto/';
    emit(LoadingInit(lstBrand, lstProductDto, imagePath));
  }

  Future<void> getProductByBrandId(
      List<ProductDto> lstProductDto, int brandId) async {
    // List<Product> lstProduct = await productProvider.getProductByBrand(brandId);
    // List<ProductDto> lstProductDto = [];
    // for (final record in lstProduct) {
    //   lstProductDto.add(ProductDto.convertDto(record));
    // }
    emit(ClickBrandItem());
    emit(LoadingProduct(
        lstProductDto.where((product) => product.brandId == brandId).toList()));
  }

  void replaceElements(
      List<ProductDto> lstAllProduct, List<ProductDto> availableProduct) {
    // Create a map for faster lookup and to track already processed products
    Map<int, ProductDto> availableMap = {
      for (var product in availableProduct) 
        if (product.productId != null) product.productId!: product
    };

    lstAllProduct.asMap().forEach((index, elementA) {
      if (elementA.productId != null && availableMap.containsKey(elementA.productId)) {
        ProductDto matchingElement = availableMap[elementA.productId]!;
        
        lstAllProduct[index].customerPriceId = matchingElement.customerPriceId;
        lstAllProduct[index].customerStockId = matchingElement.customerStockId;
        lstAllProduct[index].priceCustomer = matchingElement.priceCustomer;
        lstAllProduct[index].quantity = matchingElement.quantity;
      }
    });
  }

  List<ProductDto> assignStock(
      List<ProductDto> lstProductDto, List<ProductStock> lstProductStock) {
    List<ProductDto> filteredProducts = [];
    
    for (var productDto in lstProductDto) {
      var productStock = lstProductStock.firstWhere(
          (stock) => stock.productId == productDto.productId,
          orElse: () => ProductStock());
      if (productStock.productId != null) {
        productDto.stockBalance = (productStock.availableStock ?? 0) -
            ((productStock.orderUsedStock ?? 0) +
                (productStock.promotionUsedStock ?? 0));
        filteredProducts.add(productDto);
      }
      // If no matching product stock is found, the product is not added to filteredProducts
      // This removes products that don't exist in w_stock_balance
    }
    return filteredProducts;
  }
}
