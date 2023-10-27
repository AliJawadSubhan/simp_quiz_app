// import 'dart:async';

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/model/quiz_question.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_screen.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_state.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';
import 'package:simp_quiz_app/services/db_service.dart';

List<QuizQuestionModel> questionsModel = [];

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitialState()) {
    drawQuizData();
    // pleaseLog();
  }

  AuthServices authServices = getIt<AuthServices>();
  MultiplayerRoom? room;
  MultiplayerUser? me;
  MultiplayerUser? participant;
  pleaseLog() {
    log("me: ${me!.username}");

    log("participant: ${participant!.username}");
  }

  UserModel? you;
  UserModel? yourOpponent;
  Future<void> updateMultiplayerRoom(
      MultiplayerRoom newRoom, UserModel youu) async {
    room = newRoom;
    you = youu;
    if (you!.userUID == room?.user1.user_uid && you != null) {
      me = room?.user1;
      // participant = room?.user2;
    } else if (you!.userUID == room?.user2.user_uid && you != null) {
      // me = room?.user2;
      participant = room?.user1;
    }
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

    userTappedmE(int thisQuestionINdex, String tappedAnswer) {
      if (questionsModel[thisQuestionINdex].correctAnswer == tappedAnswer) {
        me?.correctAnswer += 1;
      } else {
        me?.incorrectAnswer += 1;
      }
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
    service.getQuizQuestions().listen((event) {
      questionsModel = event;
    });
    // }
  }

  void pickedOption(thisQuestionINdex, String tappedAnswer) {
    // serTappedmE(int thisQuestionINdex, String tappedAnswer) {
      if (questionsModel[thisQuestionINdex].correctAnswer == tappedAnswer) {
        me?.correctAnswer += 1;
      } else {
        me?.incorrectAnswer += 1;
      }
    // }
    quizBrain.toNextQuestion();
    if (quizBrain.isLastQuestion(questionsModel)) {
      // quizBrain.reset();
      emit(QuizQuizCompletedState());
    } else {
      emit(QuizDataState(quizBrain: quizBrain, quizQuestions: questionsModel));
    }
  }
}
