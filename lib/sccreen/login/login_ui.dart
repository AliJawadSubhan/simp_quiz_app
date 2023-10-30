import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/internet_cubit.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/login/login_cubit.dart';
import 'package:simp_quiz_app/sccreen/login/login_state.dart';
import 'package:simp_quiz_app/sccreen/qeue/qeue.dart';

class LoginUI extends StatelessWidget {
  LoginUI({super.key});
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit();
    return Scaffold(
      backgroundColor: Colors.teal.shade400,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: BlocConsumer<LoginCubit, LoginState>(
            bloc: loginCubit,
            buildWhen: (previous, current) => current is! LoginActionState,
            listenWhen: (previous, current) => current is LoginActionState,
            listener: (context, state) {
              if (state is LoginSOFTErroRsTATE) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12.0),
                        Flexible(
                          child: Text(
                            state.softError,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green.shade300,
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Close',
                      textColor: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              }
              if (state is LoginAccceptedState) {
                UserModel userModel = UserModel(
                  username: state.username,
                  userUID: state.userUid,
                  correctAnswer: 0,
                  wrong: 0,
                );
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) {
                    return BlocProvider.value(
                      value: loginCubit,
                      child: QueueScreen(
                        userModel: userModel,
                      ),
                    );
                  },
                ));
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Quiz Multiplayer",
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.9), // Slightly transparent white background
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 28.0,
                            color: Colors.teal.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Your Name",
                            labelText: "Name",
                            labelStyle: TextStyle(
                              color: Colors.teal.shade900,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.teal.shade900,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal.shade900),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.teal.shade900,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            log(nameController.text.trim());
                            loginCubit.userUILogic(nameController.text.trim());
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: state is LoginLoadingSTATE
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Let's Play",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
