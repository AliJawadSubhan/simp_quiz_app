// import 'dart:async';

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/model/quiz_question.dart';
// import 'package:simp_quiz_app/sccreen/login/login_state.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_screen.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_state.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';
import 'package:simp_quiz_app/services/db_service.dart';

List<QuizQuestionModel> questionsModel = [];

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitialState()) {
    drawQuizData();
     getcurrentID();
    log(id.toString());
    
  }
  AuthServices authServices = getIt<AuthServices>();

  FireStoreService fireStoreService = FireStoreService();
String? id;
 getcurrentID () async {
 id = await authServices.getCurrentUserUID();
}
  Quizmraom quizBrain = Quizmraom();
  // late QuizResult result;

  // AuthServices authServices = AuthServices();

  findUser() async {
    emit(QuizLoadingDemoState());

  }
  drawQuizData() async {
    getQuizList();

    emit(QuizLoadingDemoState());
    await Future.delayed(
      const Duration(seconds: 1),
    );
    emit(QuizDataState(
      quizQuestions: questionsModel,
      quizBrain: quizBrain,
    ));
  }

  getQuizList() {
    // Future<void> myQuizModel() async {
    FireStoreService service = FireStoreService();
    // setState(() {
    service.getQuizQuestions().listen((event) {
      questionsModel = event;
    });
    // }
  }

  void pickedOption() {
    quizBrain.toNextQuestion();
    if (quizBrain.isLastQuestion(questionsModel)) {
      // quizBrain.reset();
      emit(QuizQuizCompletedState());
    } else {
      emit(QuizDataState(quizBrain: quizBrain, quizQuestions: questionsModel));
    }
  }
}
