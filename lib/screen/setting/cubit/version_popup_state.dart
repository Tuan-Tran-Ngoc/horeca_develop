part of 'version_popup_cubit.dart';

@immutable
sealed class VersionPopupState {}

final class VersionPopupInitial extends VersionPopupState {}

final class LoadingInitVersionSuccess extends VersionPopupState {
  VersionDto versionInfo;
  LoadingInitVersionSuccess(this.versionInfo);
}

final class EventUpradeVersionApp extends VersionPopupState {}

final class UpgradeVersionAppSuccess extends VersionPopupState {
  String filePath;
  UpgradeVersionAppSuccess(this.filePath);
}
