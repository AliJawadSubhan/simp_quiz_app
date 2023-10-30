import 'package:flutter/material.dart';
import 'package:simp_quiz_app/sccreen/login/login_cubit.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_cubit.dart';

class ResultsView extends StatelessWidget {
  // const ResultsView({super.key, required this.quiz});
  // final QuizCubit quiz;
  @override
  Widget build(BuildContext context) {
    // LoginCubit loginCubit = LoginCubit();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Current User
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Score",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                Icon(
                  Icons.person,
                  color: Colors.teal.shade900,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Correct : ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
                const Text(
                  "0", // Replace with the actual number of correct answers
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Wrong : ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
                const Text(
                  "0", // Replace with the actual number of wrong answers
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ],
            ),

            // Add some vertical space
            const SizedBox(height: 20),

            // Opponent
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Opponent's Score ",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                Icon(
                  Icons.person,
                  color: Colors.teal.shade900,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Correct : ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
                const Text(
                  "0", // Replace with the actual number of correct answers
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Wrong : ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
                const Text(
                  "0", // Replace with the actual number of wrong answers
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
              onPressed: () {
                // Add your Play Again logic here
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.teal.shade900),
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.teal.shade700),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Play Again",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
