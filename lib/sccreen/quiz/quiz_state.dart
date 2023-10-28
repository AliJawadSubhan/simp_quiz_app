
// import 'package:simp_quiz_app/main.dart';
import 'package:simp_quiz_app/model/quiz_question.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_screen.dart';

class QuizState {}

class QuizInitialState extends QuizState {}
class QuizQuizCompletedState extends QuizActionState {}
class QuizActionState extends QuizState {}

class QuizDataState extends QuizState {
  final Quizmraom quizBrain;
  final List<QuizQuestionModel> quizQuestions;
  // final UserModel you;
  // final UserModel opponent;


  QuizDataState( {required this.quizQuestions, required this.quizBrain, });
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

class QuizScoreUpdateState extends QuizState{
  final UserModel user1;
   final UserModel user2;

  QuizScoreUpdateState({required this.user1, required this.user2});
  
}

class QuizCheckAnswerState extends QuizState {}
