import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simp_quiz_app/sccreen/login/login_cubit.dart';
import 'package:simp_quiz_app/sccreen/login/login_state.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_screen.dart';

class LoginUI extends StatelessWidget {
  LoginUI({super.key});
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit();
    return Scaffold(
      backgroundColor: Colors.teal.shade400, // Exotic background color
      body: Center(
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
                                fontWeight: FontWeight.bold),
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
                        // Add any action you want here
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              }
              if (state is LoginAccceptedState) {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) {
                    return BlocProvider.value(
                      value: loginCubit,
                      child: const QuizScreen(),
                    );
                  },
                ));
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Quiz Multiplayer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                            0.8), // Semi-transparent white background
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Exotic Login",
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.teal.shade900, // Exotic text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Your Name",
                              labelText: "Name",
                              labelStyle: TextStyle(
                                color: Colors
                                    .teal.shade900, // Exotic label text color
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color:
                                    Colors.teal.shade900, // Exotic icon color
                              ),
                              fillColor:
                                  Colors.white, // Input field background color
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.teal.shade900), // Border color
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.teal
                                  .shade900, // Exotic text color in input field
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              // Add your login logic here
                              // myQuizModel();
                              log(nameController.text.trim());
                              loginCubit.userUILogic(nameController.text.trim());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal
                                  .shade900, // Exotic button background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: state is LoginLoadingSTATE
                                ? const CircularProgressIndicator(
                                    color: Colors.teal,
                                  )
                                : const Text(
                                    "Let's play (:",
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Text color on the button
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
