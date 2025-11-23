part of 'buy_cubit.dart';

sealed class BuyState extends Equatable {
  const BuyState();

  @override
  List<Object> get props => [];
}

final class BuyInitial extends BuyState {}

final class LoadingItem extends BuyState {}

//final class LoadingInit extends BuyState {}

final class ProductInitial extends BuyState {}

final class StartInitialData extends BuyState {}

final class BuyInitialSuccess extends BuyState {
  List<ListOrderInShift> lstOrder;
  List<SurveyDto> lstSurvey;
  BuyInitialSuccess(this.lstOrder, this.lstSurvey);
}

final class ChangeTabSuccess extends BuyState {
  int index;
  ChangeTabSuccess(this.index);
}

final class SelectCustomerSuccess extends BuyState {
  bool value;
  SelectCustomerSuccess(this.value);
}

final class OnClickSearch extends BuyState {}

final class SearchCondtionSuccess extends BuyState {
  List<ListOrderInShift> lstOrder;
  SearchCondtionSuccess(this.lstOrder);
}
