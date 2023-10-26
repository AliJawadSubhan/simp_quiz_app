// import 'dart:async';

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/model/quiz_question.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';
// import 'package:simp_quiz_app/sccreen/login/login_state.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_screen.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_state.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';
import 'package:simp_quiz_app/services/db_service.dart';

List<QuizQuestionModel> questionsModel = [];

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitialState()) {
    drawQuizData();
    // getcurrentID();
    // log(id.toString());
  }
  AuthServices authServices = getIt<AuthServices>();
  MultiplayerRoom? room;
  //  UserModel? constructureUser;
  UserModel? you;
  UserModel? yourOpponent;
  Future<void> updateMultiplayerRoom(
      MultiplayerRoom newRoom, UserModel youu) async {
    room = newRoom;
    you = youu;

    var user1Function = await fireStoreService.getUserByID(
        userid: room!.user1.user_uid.toString());

    if (user1Function != null && user1Function.userUID != you!.userUID) {
      yourOpponent = user1Function;
    } else {
      user1Function = await fireStoreService.getUserByID(
          userid: room!.user2.user_uid.toString());
      yourOpponent = user1Function;
    }
  }

  FireStoreService fireStoreService = FireStoreService();
  String? id;
  // findWhichUserIsWhichUser() {}

  Quizmraom quizBrain = Quizmraom();

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
