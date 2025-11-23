part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class LoadingInit extends HomeState {}

final class LoadingItem extends HomeState {}

final class CheckStartShiftState extends HomeState {
  bool isStartShift = false;
  CheckStartShiftState(this.isStartShift);
}

final class HomeInitialSuccessful extends HomeState {}

final class LogoutSuccessful extends HomeState {
  String msg;
  LogoutSuccessful(this.msg);
}
