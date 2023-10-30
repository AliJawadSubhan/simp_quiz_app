import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simp_quiz_app/model/quiz_question.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_cubit.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen(
      {super.key, required this.thisRoom, required this.currentUser});
  final MultiplayerRoom thisRoom;
  final UserModel currentUser;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
// final QuizCubit quizCubit = QuizCubit();
  // final QuizCubit quizCubit = QuizCubit();
  // static List<QuizQuestionModel> questionModel = [];

  // Future<void> myQuizModel() async {
  //   FireStoreService service = FireStoreService();
  //   // setState(() {
  //   service.getQuizQuestions().listen((event) {
  //     setState(() {
  //       questionModel = event;
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   myQuizModel();
  //   // log(questionModel.first.correctAnswer);
  // }

  // Quizmraom quizBrain = Quizmraom();

  QuizCubit quizCubit = QuizCubit();

  @override
  Widget build(BuildContext context) {
    quizCubit.updateMultiplayerRoom(widget.thisRoom, widget.currentUser);
    return Scaffold(
      backgroundColor: Colors.blue.shade200, // Background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<QuizCubit, QuizState>(
                  listener: (context, state) {
                    if (state is QuizQuizCompletedState) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Scaffold(
                              body: Center(
                                child: Text("Hello World,"),
                              ),
                            ),
                          ));
                    }
                  },
                  buildWhen: (previous, current) => current is! QuizActionState,
                  listenWhen: (previous, current) => current is QuizActionState,
                  bloc: quizCubit,
                  builder: (context, state) {
                    if (state is QuizLoadingDemoState) {
                      return const CupertinoActivityIndicator(
                        animating: true,
                      );
                    }

                    if (state is QuizDataState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Your Opponent: ${quizCubit.yourOpponent?.username ?? 'Opponent'}",
                            style: const TextStyle(color: Colors.red),
                          ),
                          Text(
                            "You: ${quizCubit.you?.username ?? 'You'}",
                            style: const TextStyle(color: Colors.pink),
                          ),
                          Text(
                            state.quizBrain
                                .quizQuestion(state.quizQuestions)
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 24.0, // Text size
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            height: 120,
                            width: 241,
                            child: ListView.builder(
                              itemCount: state
                                  .quizQuestions[state.quizBrain.questionNumber]
                                  .options
                                  .length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // log(state.quizBrain
                                    //     .quizOptions(state.quizQuestions)[index]
                                    //     .toString());
                                    // setState(() {
                                    //   state.quizBrain.toNextQuestion();
                                    // });
                                    // log();
                                    // quizCubit.quizBrain.quizAnswer(state.quizQuestions);
                                    quizCubit.userTappedmE(
                                        index,
                                        state.quizBrain.quizOptions(
                                            state.quizQuestions)[index]);
                                    quizCubit.pickedOption(
                                        index,
                                        state.quizBrain.quizOptions(
                                            state.quizQuestions)[index]);
                                    //  quizCubit.userTappedmE(index, state.quizQuestions[index].options[index],);
                                  },
                                  child: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "${index + 1}: " +
                                        state.quizBrain.quizOptions(
                                            state.quizQuestions)[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),

                          Row(
                            children: [
                              // Your Score
                              StreamBuilder(
                                stream: quizCubit.showUserScoreStream(
                                    quizCubit.you!.userUID!),
                                builder: (context, snapshot) {
                                  final isLoading = snapshot.connectionState ==
                                      ConnectionState.waiting;
                                  final hasData = snapshot.hasData;

                                  return Column(
                                    children: [
                                      const Text("Your Score"),
                                      isLoading
                                          ? const CircularProgressIndicator() // Show a loading indicator
                                          : hasData
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          " Correct : ${snapshot.data!.correctAnswer}"),
                                                      Text(
                                                          " Wrong : ${snapshot.data!.wrong}"),
                                                    ],
                                                  ),
                                                )
                                              : const Text("No Data Available"),
                                    ],
                                  );
                                },
                              ),

                              // Opponent's Score
                              StreamBuilder(
                                stream: quizCubit.showUserScoreStream(
                                    quizCubit.yourOpponent!.userUID!),
                                builder: (context, snapshot) {
                                  final isLoading = snapshot.connectionState ==
                                      ConnectionState.waiting;
                                  final hasData = snapshot.hasData;

                                  return Column(
                                    children: [
                                      const Text("Opponent's Score"),
                                      isLoading
                                          ? const CircularProgressIndicator() // Show a loading indicator
                                          : hasData
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          " Correct : ${snapshot.data!.correctAnswer}"),
                                                      Text(
                                                          " Wrong : ${snapshot.data!.wrong}"),
                                                    ],
                                                  ),
                                                )
                                              : const Text("No Data Available"),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),

                          // Text(
                          //     "Your correct answers ${quizCubit.me?.correctAnswer ?? "sad"}"),
                          // Text(
                          //     "Your wrong answers ${quizCubit.me?.incorrectAnswer ?? "sad"}"),
                          // // Text(
                          //     "Your opponent correct answers ${quizCubit.participant?.correctAnswer ?? "sad"}"),
                          // Text(
                          // "Your opponent wrong answers ${quizCubit.participant?.correctAnswer ?? "sad"}"),
                          //  if (state is QuizScoreUpdateState)
                          // Text(quizCubit.you?.correctAnswer == null
                          //     ? "sad"
                          //     : "${quizCubit.you!.correctAnswer.toString()} Your Correct Answer"),
                          // Text(quizCubit.you?.wrong == null
                          //     ? "no sad"
                          //     : "${quizCubit.you!.wrong.toString()} Your Wrong answer"),
                          // // =---
                          // Text(quizCubit.yourOpponent?.correctAnswer == null
                          //     ? "sad"
                          //     : "${quizCubit.yourOpponent!.correctAnswer.toString()} Opponent corect answer"),
                          // Text(quizCubit.yourOpponent?.wrong == null
                          //     ? "no sad"
                          //     : "${quizCubit.yourOpponent!.wrong.toString()} Opponent Wrong answer "),
                        ],
                      );
                    }
                    return const Text("123333");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class Quizmraom {
  int questionNumber = 0;
  toNextQuestion() {
    questionNumber++;
    // return questionNumber;
  }

  bool isLastQuestion(List<QuizQuestionModel> q) {
    return questionNumber == (q.length + 1);
  }
  // final List<QuizQuestionModel> quizQuestions;
  // Quizmraom({
  //   required this.quizQuestions,
  // });
  // bool isLastQuestion() {
  //   // return questionNumber > this.questionNumber.length - 1;
  // }

  reset() {
    questionNumber = 0;
  }

  bool checkAnswer(List<QuizQuestionModel> quizQuestions, String pickedOption) {
    if (quizQuestions[questionNumber].correctAnswer == pickedOption) {
      return true;
    } else {
      return false;
    }
  }

  String quizQuestion(List<QuizQuestionModel> quizQuestions) {
    return quizQuestions[questionNumber].question;
  }

  List quizOptions(List<QuizQuestionModel> quizQuestions) {
    return quizQuestions[questionNumber].options;
  }

  String quizAnswer(List<QuizQuestionModel> quizQuestions) {
    return quizQuestions[questionNumber].correctAnswer;
  }
}
