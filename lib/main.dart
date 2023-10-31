import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:simp_quiz_app/firebase_options.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/internet_cubit.dart';
import 'package:simp_quiz_app/sccreen/login/login_cubit.dart';
import 'package:simp_quiz_app/sccreen/login/login_ui.dart';
import 'package:simp_quiz_app/sccreen/login_screen/login_screen.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocators();
  // runApp(widget(child: MyApp()));
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => QuizCubit(),
    ),
    BlocProvider(
      create: (context) => LoginCubit(),
    ),
    BlocProvider(
      create: (context) => InternetCubit(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // final appStaet = Appstate();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// // QuizBrain quizBrain = QuizBrain();
// // List<QuizResult> quizResults = [];
// // bool queryQuizPickedOption(String pickedOption) {
// //   return pickedOption == quizBrain.quizAnswer();
// // }

// // void logResults(String pickedOption) {
// //   bool isCorrect = queryQuizPickedOption(pickedOption);
// //   if (isCorrect) {
// //     quizResult.correct += 1;
// //   } else {
// //     quizResult.incorrect += 1;
// //   }
// //   quizBrain.toNextQuestion();

// //   // Log the current question result
// //   log("Question ${quizBrain.questionNumber}: $pickedOption is ${isCorrect ? 'correct' : 'incorrect'}");
// // }

// // QuizResult quizResult = QuizResult(correct: 0, incorrect: 0);

// class _MyHomePageState extends State<MyHomePage> {
//   final QuizCubit quizCubit = QuizCubit();
//   // quizCubi
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             BlocConsumer<QuizCubit, QuizState>(
//               listener: (context, state) {
//                 if (state is QuizQuizCompletedState) {
//                   // Handle quiz completion here.
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ResultPage(
//                           quizResult: QuizResult(correct: 2, incorrect: 1),
//                         ),
//                       ));
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Row(
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             color: Colors.white,
//                           ),
//                           SizedBox(width: 12.0),
//                           Text(
//                             "Success",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       backgroundColor: Colors.green.shade300,
//                       duration: const Duration(seconds: 3),
//                       action: SnackBarAction(
//                         label: 'Close',
//                         textColor: Colors.white,
//                         onPressed: () {
//                           // Add any action you want here
//                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                         },
//                       ),
//                     ),
//                   );
//                 }
//               },
//               listenWhen: (previous, current) => current is QuizActionState,
//               bloc: quizCubit,
//               buildWhen: (previous, current) => current is! QuizActionState,
//               builder: (context, state) {
//                 // IF
//                 if (state is QuizLoadingDemoState) {
//                   return const CupertinoActivityIndicator();
//                 }
//                 if (state is QuizPickedOptionState ||
//                     state is QuizDataState ||
//                     state is QuizQuizCompletedState) {
//                   var quizBrainToUse = state is QuizDataState
//                       ? state.quizBrain
//                       : (state is QuizPickedOptionState
//                           ? state.quizBrain
//                           : null);

//                   return Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "${quizBrainToUse!.questionNumber + 1}: ",
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             quizBrainToUse.quizQuestion(),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 120,
//                         width: 210,
//                         child: ListView.builder(
//                           itemCount:
//                               quizBrainToUse.quizOptions().length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 //   quizCubit.pickedOption(
//                                 //   state.quizBrain.quizOptions()[index],
//                                 // );
//                                 quizCubit.pickedOption();
//                               },
//                               child: Text(
//                                 quizBrainToUse.quizOptions()[index],
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//                 return const Text("123");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';

// class ResultPage extends StatelessWidget {
//   final QuizResult? quizResult;

//   const ResultPage({super.key, required this.quizResult});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check,
//               color: quizResult!.correct > 0 ? Colors.green : Colors.red,
//               size: 48.0,
//             ),
//             Text(
//               quizResult?.correct == 1
//                   ? "${quizResult?.correct} Correct Answer"
//                   : "${quizResult?.correct} Correct Answers",
//             ),
//             Icon(
//               Icons.close,
//               color: quizResult!.incorrect > 0 ? Colors.red : Colors.green,
//               size: 48.0,
//             ),
//             Text(
//               quizResult?.incorrect == 1
//                   ? "${quizResult?.incorrect} Incorrect Answer"
//                   : "${quizResult?.incorrect} Incorrect Answers",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class QuizBrain {
//   int questionNumber = 0;
//   toNextQuestion() {
//     questionNumber++;
//     // return questionNumber;
//   }

//   bool isLastQuestion() {
//     return questionNumber > quizQuestions.length - 1;
//   }

//   reset() {
//     questionNumber = 0;
//   }

//   String quizQuestion() {
//     return quizQuestions[questionNumber].question;
//   }

//   List<String> quizOptions() {
//     return quizQuestions[questionNumber].options;
//   }

//   String quizAnswer() {
//     return quizQuestions[questionNumber].correctAnswer;
//   }

//   List<QuizQuestion> quizQuestions = [
//     QuizQuestion(
//       // questionNumberr: 1,
//       question: "What is the capital of France?",
//       options: ["Berlin", "London", "Madrid", "Paris"],
//       correctAnswer: "Paris",
//     ),
//     QuizQuestion(
//       // questionNumberr: 2,
//       question: "Which planet is known as the Red Planet?",
//       options: ["Earth", "Mars", "Venus", "Jupiter"],
//       correctAnswer: "Mars",
//     ),
//     QuizQuestion(
//       // questionNumberr: 3,
//       question: "What is the largest mammal in the world?",
//       options: ["Elephant", "Giraffe", "Blue Whale", "Hippopotamus"],
//       correctAnswer: "Blue Whale",
//     ),
//     QuizQuestion(
//       // questionNumberr: 4,
//       question: "How many continents are there on Earth?",
//       options: ["5", "6", "7", "8"],
//       correctAnswer: "7",
//     ),
//     QuizQuestion(
//       // questionNumberr: 5,
//       question: "Who wrote the play 'Romeo and Juliet'?",
//       options: [
//         "William Shakespeare",
//         "Charles Dickens",
//         "Jane Austen",
//         "George Orwell"
//       ],
//       correctAnswer: "William Shakespeare",
//     ),
//   ];
// }

// class QuizQuestion {
//   // final int questionNumberr;
//   final String question;
//   final List<String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     // required this.questionNumberr,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });
// }

// class QuizResult {
//   int correct;
//   int incorrect;

//   QuizResult({required this.correct, required this.incorrect});
// }

// // setState(() {
// //   logResults(quizBrain.quizOptions()[index]);
// // });
// // for (QuizResult result in quizResults) {
// //   print(
// //       "Correct: ${result.correct}, Incorrect: ${result.incorrect}");
// // }
// // quizCubit.pickedOption();

// // if (quizBrain.questionNumber ==
// //     quizBrain.quizQuestions.length) {
// //   quizBrain.reset();
// //   Navigator.push(context, MaterialPageRoute(
// //     builder: (context) {
// //       return ResultPage(
// //         // result: quizResults,
// //         quizResult: quizResult,
// //       );
// //     },
// //   ));
// // }
