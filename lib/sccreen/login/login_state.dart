class LoginState {}

class LoginActionState extends LoginState {}

class LoginInitialState extends LoginState {}
class LoginErrorState extends LoginState {
  final String ERRORSTATE;
  LoginErrorState({required this.ERRORSTATE});
}

class LoginAccceptedState extends LoginActionState {
  final String username, userUid;

  LoginAccceptedState({required this.username, required this.userUid});
}


class LoginDataRecivedState extends LoginState {
  final String username;

  LoginDataRecivedState({required this.username});
}
class LoginSOFTErroRsTATE extends LoginActionState {
  final String softError;

  LoginSOFTErroRsTATE({required this.softError});
}

class LoginLoadingSTATE extends LoginState {}