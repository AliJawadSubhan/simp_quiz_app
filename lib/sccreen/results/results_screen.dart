import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_cubit.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key, required this.quizCubit});

  final QuizCubit quizCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            left: 0,
            right: 0,
            child: SvgPicture.asset("images/bg.svg", fit: BoxFit.fill),
          ),
          // Stylish Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset("images/game_logo.png")),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Game Name
                const Text(
                  "Crazy Quiz Masters",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Message
                // const Text(
                //   "Looking for your Opponent...",
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(
                  height: 12,
                ),
                // About Us
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
                                color: Colors.teal) // Show a loading indicator
                            : hasData
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          child: const Icon(Icons.check_circle,
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
                                          duration:
                                              const Duration(milliseconds: 500),
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
                                color: Colors.teal) // Show a loading indicator
                            : hasData
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          child: const Icon(Icons.check_circle,
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
                                          duration:
                                              const Duration(milliseconds: 500),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
