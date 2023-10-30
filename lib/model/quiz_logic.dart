import 'package:simp_quiz_app/model/quiz_question.dart';

class QuizBrainLogic {
  int questionNumber = 0;
  toNextQuestion() {
    questionNumber++;
  }

  bool isLastQuestion(List<QuizQuestionModel> q) {
    return questionNumber == q.length;
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
