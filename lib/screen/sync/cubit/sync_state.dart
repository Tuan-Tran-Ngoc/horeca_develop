import 'package:equatable/equatable.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:horeca_service/sqflite_database/model/w_transfer_update_log.dart';

sealed class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object> get props => [];
}

final class SyncOfflineInitial extends SyncState {}

final class LoadingInit extends SyncState {
  List<Map<String, dynamic>> lstDataSynchronize = [];
  String lastestUpdate;
  LoadingInit(this.lstDataSynchronize, this.lastestUpdate);
}

final class LoadingItem extends SyncState {}

final class UpdateDataSuccess extends SyncState {
  String msg;
  String lastestUpdate;
  UpdateDataSuccess(this.msg, this.lastestUpdate);
}

final class SynchronizeDataSuccess extends SyncState {
  String msg;
  SynchronizeDataSuccess(this.msg);
}

final class OnClickUpdateData extends SyncState {}

final class OnClickSynchronizeData extends SyncState {}

final class ReloadControl extends SyncState {
  String message;
  ReloadControl(this.message);
}

final class InitialDataSuccess extends SyncState {}

final class InitialDataFail extends SyncState {
  String error;
  InitialDataFail(this.error);
}

final class UpdateDataFail extends SyncState {
  String error;
  UpdateDataFail(this.error);
}

final class SynchronizeDataFail extends SyncState {
  String error;
  SynchronizeDataFail(this.error);
}
