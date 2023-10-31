import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        builder: (context) => Scaffold(
                          backgroundColor: Colors.blue.shade200,
                          body: Center(
                            child: Text(
                              "Hello World",
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) => current is! QuizActionState,
                listenWhen: (previous, current) => current is QuizActionState,
                bloc: quizCubit,
                builder: (context, state) {
                  if (state is QuizLoadingDemoState) {
                    return const CupertinoActivityIndicator(animating: true);
                  }

                  if (state is QuizDataState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Your Opponent: ${quizCubit.yourOpponent?.username ?? 'Opponent'}",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        Text(
                          "You: ${quizCubit.you?.username ?? 'You'}",
                          style: TextStyle(color: Colors.pink, fontSize: 18.0),
                        ),
                        Text(
                          state.quizBrain
                              .quizQuestion(state.quizQuestions)
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          width: 241,
                          child: ListView.builder(
                            itemCount: state
                                .quizQuestions[state.quizBrain.questionNumber]
                                .options
                                .length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  quizCubit.pickedOption(
                                    index,
                                    state.quizBrain.quizOptions(
                                        state.quizQuestions)[index],
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${index + 1}: " +
                                        state.quizBrain.quizOptions(
                                            state.quizQuestions)[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Your Score
                            StreamBuilder<UserModel?>(
                              stream: quizCubit
                                  .showUserScoreStream(quizCubit.you!.userUID!),
                              builder: (context, snapshot) {
                                final isLoading = snapshot.connectionState ==
                                    ConnectionState.waiting;
                                final hasData = snapshot.hasData;

                                return Column(
                                  children: [
                                    const Text(
                                      "Your Score",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isLoading
                                        ? const CircularProgressIndicator()
                                        : hasData
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      " Correct : ${snapshot.data!.correctAnswer ?? 0}",
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Wrong : ${snapshot.data!.wrong ?? 0}",
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const Text("No Data Available"),
                                  ],
                                );
                              },
                            ),

                            // Opponent's Score
                            StreamBuilder<UserModel?>(
                              stream: quizCubit.showUserScoreStream(
                                  quizCubit.yourOpponent!.userUID!),
                              builder: (context, snapshot) {
                                final isLoading = snapshot.connectionState ==
                                    ConnectionState.waiting;
                                final hasData = snapshot.hasData;

                                return Column(
                                  children: [
                                   const Text(
                                      "Opponent's Score",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isLoading
                                        ? const CircularProgressIndicator()
                                        : hasData
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      " Correct : ${snapshot.data!.correctAnswer ?? 0}",
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Wrong : ${snapshot.data!.wrong ?? 0}",
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
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
                      ],
                    );
                  }
                  return const Text("123333");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
