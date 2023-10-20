// class LoginState

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/sccreen/login/login_state.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  // AuthServices authServices = Locators.locator<AuthServices>();

  AuthServices authServices = AuthServices();

  userUILogic(String input) {
    emit(LoginLoadingSTATE());
    if (input.isEmpty) {
      emit(
        LoginSOFTErroRsTATE(softError: "Please input a valid name."),
      );
    } else if (input.length < 4) {
      emit(
        LoginSOFTErroRsTATE(softError: "Name should be at least 4 characters."),
      );
    } else if (input.contains(RegExp(r'[!@#\$%&*()_+^%]'))) {
      emit(
        LoginSOFTErroRsTATE(softError: "Invalid characters in the name."),
      );
    } else {
      _userTapLogin(input);
    }
  }

  _userTapLogin(String username) async {
    await Future.delayed(const Duration(seconds: 2));
    emit(LoginLoadingSTATE());
    // please help me fix the logic
    try {
      authServices.loginService(username);
      emit(LoginAccceptedState());
    } catch (e) {
      emit(LoginErrorState(ERRORSTATE: e.toString()));
    }
  }
}
