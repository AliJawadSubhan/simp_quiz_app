// class LoginState

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/login/login_state.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';
// import 'package:simp_quiz_app/user_provider.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

// final userData = getIt<UserData>();
  AuthServices authServices = getIt<AuthServices>();
  userUILogic(String input) {
    // emit(LoginLoadingSTATE());
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

  UserModel? userModel;
  _userTapLogin(String username) async {
    // await Future.delayed(const Duration(seconds: 2));
    emit(LoginLoadingSTATE());
    try {
      userModel = await authServices.createGuestUser(username);
      debugPrint("===> ${userModel!.userUID!} this is my ui");
      emit(LoginAccceptedState(
        userUid: userModel!.userUID!,
        username: userModel!.username!,
      ));
    } catch (e) {
      emit(LoginErrorState(ERRORSTATE: e.toString()));
    }
  }
}
