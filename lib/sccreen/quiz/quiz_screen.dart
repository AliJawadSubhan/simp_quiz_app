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
  QuizCubit quizCubit = QuizCubit();

  @override
  Widget build(BuildContext context) {
    quizCubit.updateMultiplayerRoom(widget.thisRoom, widget.currentUser);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Background color
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Quiz game",
          style: TextStyle(
            fontSize: 21,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      backgroundColor: Colors.white, // Background color
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
                          body: const Center(
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
                          style: const TextStyle(
                              color: Colors.red, fontSize: 18.0),
                        ),
                        Text(
                          "You: ${quizCubit.you?.username ?? 'You'}",
                          style: const TextStyle(
                              color: Colors.pink, fontSize: 18.0),
                        ),
                        Text(
                          state.quizBrain
                              .quizQuestion(state.quizQuestions)
                              .toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.34,
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
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12.0),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color:
                                            Colors.black), // Add a black border
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.grey
                                      ], // Gradient from white to grey
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                  child: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "${index + 1}: " +
                                        state.quizBrain.quizOptions(
                                            state.quizQuestions)[index],
                                    style: const TextStyle(
                                      color: Colors.black, // Text color
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
                              stream: quizCubit.showUserScoreStream(
                                  quizCubit.you?.userUID ?? ""),
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
                                                      " Correct : ${snapshot.data?.correctAnswer ?? 0}",
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Wrong : ${snapshot.data?.wrong ?? 0}",
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
                            StreamBuilder<UserModel?>(
                              stream: quizCubit.showUserScoreStream(
                                  quizCubit.yourOpponent?.userUID ?? ""),
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
                                                      " Correct : ${snapshot.data?.correctAnswer ?? 0}",
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Wrong : ${snapshot.data?.wrong ?? 0}",
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
