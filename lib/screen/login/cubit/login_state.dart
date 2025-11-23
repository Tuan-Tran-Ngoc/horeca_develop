part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInitialSucess extends LoginState {
  String deviceId;
  String version;
  String username;
  String password;
  LoginInitialSucess(this.deviceId, this.version, this.username, this.password);
}

class SaveInfoLoginSuccess extends LoginState {
  bool isSaveInfoLogin;
  SaveInfoLoginSuccess(this.isSaveInfoLogin);
}

class TapObscureSuccess extends LoginState {
  bool isTapObscure;
  TapObscureSuccess(this.isTapObscure);
}

class LoginSuccess extends LoginState {
  String msg;
  LoginSuccess(this.msg);
}

class FirstInitDataSuccess extends LoginState {
  String? msg;
  FirstInitDataSuccess(this.msg);
}

class UpdateDataSuccess extends LoginState {
  String? msg;
  UpdateDataSuccess(this.msg);
}

class CheckInitialDataSuccess extends LoginState {}

class LoginFailed extends LoginState {
  final String? error;

  const LoginFailed({this.error});
}

class ReloadControl extends LoginState {
  String msg;
  ReloadControl(this.msg);
}

class ReloadForm extends LoginState {}

class StartSubmitEvent extends LoginState {}
