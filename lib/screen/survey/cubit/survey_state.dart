part of 'survey_cubit.dart';

@immutable
sealed class SurveyState extends Equatable {
  const SurveyState();
  @override
  List<Object> get props => [];
}

final class SurveyInitial extends SurveyState {}

final class LoadingInitSuccess extends SurveyState {
  String htmlPath;
  LoadingInitSuccess(this.htmlPath);
}

final class LoadingInitFail extends SurveyState {}

final class SaveSurveyResultSuccess extends SurveyState {
  String msg;
  SaveSurveyResultSuccess(this.msg);
}

final class SaveSurveyResultFail extends SurveyState {
  dynamic error;
  SaveSurveyResultFail(this.error);
}
