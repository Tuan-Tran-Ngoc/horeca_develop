part of 'refund_cubit.dart';

sealed class RefundState extends Equatable {
  const RefundState();

  @override
  List<Object> get props => [];
}

final class LoadingInit extends RefundState {}

final class LoadingItem extends RefundState {}

final class RefundInitial extends RefundState {}

final class RefundInitialSuccess extends RefundState {}

final class ClickTabSuccess extends RefundState {
  bool isDTC;
  ClickTabSuccess(this.isDTC);
}
