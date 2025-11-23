import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/shift_report.dart';
import 'package:horeca_service/sqflite_database/dto/survey_dto.dart';

part 'buy_state.dart';

class BuyCubit extends Cubit<BuyState> {
  BuyCubit() : super(BuyInitial());
  //List<MSurvey?> lstInitialSurvey = [];
  SurveyProvider surveryProvider = SurveyProvider();
  OrderProvider orderProvider = OrderProvider();

  Future<void> init(int customerId, int customerVisitId) async {
    emit(StartInitialData());
    List<ListOrderInShift> lstOrder =
        await orderProvider.selectOrderByCustomerId(customerId);
    List<SurveyDto> lstSurvey = await surveryProvider.selectSurveyByCustomer(
        customerId, customerVisitId, null);

    emit(BuyInitialSuccess(lstOrder, lstSurvey));
  }

  void changeTab(index) {
    emit(LoadingItem());
    emit(ChangeTabSuccess(index));
  }

  void selectCustomer(value) {
    emit(LoadingItem());
    emit(SelectCustomerSuccess(value));
  }

  Future<void> searchOrderCondition(int customerId, String productCd) async {
    emit(OnClickSearch());
    List<ListOrderInShift> lstOrder =
        await orderProvider.selectOrderCondition(customerId, productCd);
    emit(SearchCondtionSuccess(lstOrder));
  }
}
