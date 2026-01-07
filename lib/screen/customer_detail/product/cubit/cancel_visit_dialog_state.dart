import 'package:equatable/equatable.dart';
import 'package:horeca_service/horeca_service.dart';

sealed class CancelVisitDialogState extends Equatable {
  const CancelVisitDialogState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class CancelVisitDialogInitial extends CancelVisitDialogState {}

final class LoadingInit extends CancelVisitDialogState {
  List<Reason> lstReason;
  LoadingInit(this.lstReason);
}

final class ChangeReasonCancel extends CancelVisitDialogState {}

final class CancelVisitSuccessfully extends CancelVisitDialogState {
  String msg;
  CancelVisitSuccessfully(this.msg);
}

final class ReloadControl extends CancelVisitDialogState {}

final class CancelVisitFailed extends CancelVisitDialogState {
  dynamic error;
  CancelVisitFailed(this.error);
}
