// import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/login/login_cubit.dart';
import 'package:simp_quiz_app/sccreen/login/login_state.dart';
import 'package:simp_quiz_app/sccreen/qeue/qeue.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_ui.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit();
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
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
                  backgroundColor: Colors.red.shade400,
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
            return Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset("images/bg.svg", fit: BoxFit.fill)),
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(flex: 2), //2/6
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 120,
                              width: 120,
                              child: Image.asset("images/game_logo.png")),
                        ),
                        const SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "QuizBattles: Multiplayer Mayhem",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontSize: 21,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),

                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Enter your informations below",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const Spacer(), // 1/6
                        TextField(
                          controller: nameController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF1C2341),
                            hintText: "Full Name",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                        const Spacer(), // 1/6
                        InkWell(
                          // onTap: () => Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>  QueueScreen(userModel: null,),
                          //     )),
                          onTap: () {
                            log(nameController.text.trim());
                            loginCubit.userUILogic(nameController.text.trim());
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(
                                kDefaultPadding * 0.75), // 15
                            decoration: const BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: state is LoginLoadingSTATE
                                ? const SizedBox(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Let's start the quiz",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      // fontSize: 16.0,
                                    ),
                                  ),
                          ),
                        ),
                        const Spacer(flex: 2), // it will take 2/6 spaces
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

// import 'package:flutter/material.dart';

const kSecondaryColor = Color(0xFF8B94BC);
const kGreenColor = Color(0xFF6AC259);
const kRedColor = Color(0xFFE92E30);
const kGrayColor = Color(0xFFC1C1C1);
const kBlackColor = Color(0xFF101010);
const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double kDefaultPadding = 20.0;
