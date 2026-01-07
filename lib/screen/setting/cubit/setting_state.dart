part of 'setting_cubit.dart';

@immutable
sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {}

final class LoadingInitSuccess extends SettingState {
  SettingDto info;
  LoadingInitSuccess(this.info);
}

final class ChangePasswordFailed extends SettingState {
  dynamic error;
  ChangePasswordFailed(this.error);
}

final class ChangePasswordSuccessfully extends SettingState {
  String msg;
  ChangePasswordSuccessfully(this.msg);
}

final class OnClickChangePassword extends SettingState {}

final class ChangeLanguageSuccessful extends SettingState {
  Locale newLocale;
  String msg;
  ChangeLanguageSuccessful(this.newLocale, this.msg);
}

final class EventUpradeVersionApp extends SettingState {}

final class UpgradeVersionAppSuccess extends SettingState {
  String filePath;
  UpgradeVersionAppSuccess(this.filePath);
}

final class ExportDatabaseLoading extends SettingState {}

final class ExportDatabaseSuccess extends SettingState {
  final String msg;
  ExportDatabaseSuccess(this.msg);
}

final class ExportDatabaseFailed extends SettingState {
  final String error;
  ExportDatabaseFailed(this.error);
}
