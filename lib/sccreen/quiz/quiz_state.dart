
// import 'package:simp_quiz_app/main.dart';
import 'package:simp_quiz_app/model/quiz_question.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_screen.dart';

class QuizState {}

class QuizInitialState extends QuizState {}
class QuizQuizCompletedState extends QuizActionState {}
class QuizActionState extends QuizState {}

class QuizDataState extends QuizState {
  final Quizmraom quizBrain;
  final List<QuizQuestionModel> quizQuestions;

  QuizDataState({required this.quizQuestions, required this.quizBrain});
}

class QuizLoadingDemoState extends QuizState {}

class QuizPickedOptionState extends QuizActionState {


  // QuizPickedOptionState();
  
    final Quizmraom  quizBrain;

  QuizPickedOptionState({required this.quizBrain});

  // // final String pickedOption;

  // QuizPickedOptionState({
  //   required this.pickedOption,
  // });
}

class QuizCheckAnswerState extends QuizState {}
