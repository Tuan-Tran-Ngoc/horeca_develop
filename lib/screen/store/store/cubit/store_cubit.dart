import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca/screen/store/store/cubit/store_state.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/model/product_stock.dart';
import 'package:horeca_service/sqflite_database/provider/w_stock_balance_provider.dart';
import 'package:horeca_service/sqflite_database/provider/provider_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreCubit extends Cubit<StoreState> {
  StockBalanceProvider stockBalanceProvider = StockBalanceProvider();
  ProviderUtils providerUtils = ProviderUtils();
  late SharedPreferences prefs;

  StoreCubit() : super(ProductInitial());
  Future<void> init() async {
    // await providerUtils.updatePosition();
    // await providerUtils.clearDataForShiftModule();
    // await providerUtils.deleteStockBalanceData();
    // await providerUtils.updateStockBalanceData();
    // await providerUtils.clearDataRevisit(2);
    prefs = await SharedPreferences.getInstance();
    int? positionId = prefs.getInt('baPositionId');
    String now =
        DateFormat(Constant.dateFormatterYYYYMMDD).format(DateTime.now());
    List<ProductStock> lstProductStock =
        await stockBalanceProvider.getListStockBalance(positionId!, now, null);

    emit(ProductInitialSuccess(lstProductStock));
  }

  void clickTab(isDTC) {
    emit(LoadingItem());
    emit(ClickTabSuccess(isDTC));
  }
}
