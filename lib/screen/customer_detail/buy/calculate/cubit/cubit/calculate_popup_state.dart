part of 'calculate_popup_cubit.dart';

@immutable
sealed class CalculatePopupState {}

final class CalculatePopupInitial extends CalculatePopupState {}

final class LoadingInit extends CalculatePopupState {}
