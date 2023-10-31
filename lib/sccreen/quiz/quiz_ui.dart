// import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_cubit.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_state.dart';
import 'package:simp_quiz_app/sccreen/quiz/widgets/static.dart';
import 'package:simp_quiz_app/sccreen/results/results_screen.dart';

class QuizUI extends StatelessWidget {
  QuizUI({super.key, required this.thisRoom, required this.currentUser});
  final listofOptions = [
    'a',
    'b',
    'c',
    'd',
  ];
  final MultiplayerRoom thisRoom;
  final UserModel currentUser;
  QuizCubit quizCubit = QuizCubit();
  @override
  Widget build(BuildContext context) {
    quizCubit.updateMultiplayerRoom(thisRoom, currentUser);
    return Scaffold(
      // backgroundColor: ,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              left: 0,
              right: 0,
              child: SvgPicture.asset("images/bg.svg", fit: BoxFit.fill)),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.08,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<UserModel?>(
                    stream: quizCubit
                        .showUserScoreStream(quizCubit.you?.userUID ?? ""),
                    builder: (context, snapshot) {
                      final isLoading =
                          snapshot.connectionState == ConnectionState.waiting;
                      final hasData = snapshot.hasData;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Your Score: ",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          isLoading
                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.teal) // Show a loading indicator
                              : hasData
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            child: const Icon(
                                                Icons.check_circle,
                                                color: Colors.green),
                                          ),

                                          Text(
                                            " Correct : ${snapshot.data?.correctAnswer ?? 0}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          // Spacer(),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            child: const Icon(Icons.cancel,
                                                color:
                                                    // snapshot.data?.wrong? > 0
                                                    Colors.red
                                                // : Colors.transparent,
                                                ),
                                          ),
                                          Text(
                                            " Wrong : ${snapshot.data?.wrong ?? 0}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      "No Data Available",
                                      style: TextStyle(
                                        color: Colors.teal.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder<UserModel?>(
                    // stream: quizCubit
                    //     .showUserScoreStream(quizCubit.you?.userUID ?? ""),
                    stream: quizCubit.showUserScoreStream(
                      quizCubit.participant?.user_uid ?? '',
                    ),

                    builder: (context, snapshot) {
                      final isLoading =
                          snapshot.connectionState == ConnectionState.waiting;
                      final hasData = snapshot.hasData;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Opponent Score: ",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          isLoading
                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.teal) // Show a loading indicator
                              : hasData
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            child: const Icon(
                                                Icons.check_circle,
                                                color: Colors.green),
                                          ),

                                          Text(
                                            " Correct : ${snapshot.data?.correctAnswer ?? 0}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          // Spacer(),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            child: const Icon(Icons.cancel,
                                                color:
                                                    // snapshot.data?.wrong? > 0
                                                    Colors.red
                                                // : Colors.transparent,
                                                ),
                                          ),
                                          Text(
                                            " Wrong : ${snapshot.data?.wrong ?? 0}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      "No Data Available",
                                      style: TextStyle(
                                        color: Colors.teal.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                        ],
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<QuizCubit, QuizState>(
              listener: (context, state) {
                if (state is QuizQuizCompletedState) {
                  // Replace the following navigation code with your desired navigation logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsView(quizCubit: quizCubit),
                    ),
                  );
                }
              },
              buildWhen: (previous, current) => current is! QuizActionState,
              listenWhen: (previous, current) => current is QuizActionState,
              bloc: quizCubit,
              builder: (context, state) {
                if (state is QuizLoadingDemoState) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                        child: LinearProgressIndicator(
                      color: Color(0Xff242C4A),
                    )),
                  );
                }
                if (state is QuizDataState) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(21),
                          topRight: Radius.circular(21),
                        ),
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "${state.quizBrain.currentQuizQuestion() + 1} : ${state.quizBrain.quizQuestion(state.quizQuestions)}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: listofOptions.length,
                                itemBuilder: (context, index) {
                                  // item
                                  return InkWell(
                                    onTap: () {},
                                    child: Material(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 21),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: InkWell(
                                              onTap: () {
                                                log("button tapped ${state.quizBrain.quizOptions(state.quizQuestions)[index]}");
                                                quizCubit.pickedOption(
                                                    index,
                                                    state.quizBrain.quizOptions(
                                                            state
                                                                .quizQuestions)[
                                                        index]);
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          '${listofOptions[index].toUpperCase()}: '),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${state.quizBrain.quizOptions(state.quizQuestions)[index]}",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return StaticQuizPage(listofOptions: listofOptions);
              }),
        ],
      ),
    );
  }
}
