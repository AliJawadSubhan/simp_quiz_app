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
  drawQuizData() async {
    getQuizList();

    emit(QuizLoadingDemoState());
    await Future.delayed(
      const Duration(seconds: 1),
    );
    emit(QuizDataState(
      quizQuestions: questionsModel,
      quizBrain: quizBrain,
      // you: you!,
      // opponent: yourOpponent!,
    ));
  }

  AuthServices authServices = getIt<AuthServices>();
  MultiplayerRoom? room;
  MultiplayerUser? me;
  MultiplayerUser? participant;
  // pleaseLog() {
  //   log("me: ${me!.username}");

  //   log("participant: ${participant!.username}");
  // }

  UserModel? you;
  UserModel? yourOpponent;
  Future<void> updateMultiplayerRoom(
      MultiplayerRoom newRoom, UserModel youu) async {
    room = newRoom;
    you = youu;
    if (you!.userUID == room?.user1.user_uid && you != null) {
      me = room?.user1;
      participant = room?.user2;
    } else if (you!.userUID == room?.user2.user_uid && you != null) {
      me = room?.user2;
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
<<<<<<< Updated upstream
  Quizmraom quizBrain = Quizmraom();
  // userTappedmE(int thisQuestionINdex, String tappedAnswer) {
  //   final answer = quizBrain.checkAnswer(questionsModel, tappedAnswer);

  //   if (me != null && room != null) {
  //     MultiplayerUser? tempUser1;
  //     MultiplayerUser? tempUser2;
  //     if (me?.user_uid == room?.user1.user_uid) {
  //       tempUser1 = me;
  //       tempUser2 = room?.user2;
  //     } else {
  //       tempUser1 = me;
  //       tempUser2 = room?.user1;
  //     }
  //     if (tempUser1 != null && tempUser2 != null) {
  //       if (answer) {
  //         tempUser1.correctAnswer = (tempUser1.correctAnswer ?? 0) + 1;
  //       } else {
  //         tempUser1.incorrectAnswer = (tempUser1.incorrectAnswer ?? 0) + 1;
  //       }
  //       log("my Score: Correct ${tempUser1.correctAnswer}, Wrong ${tempUser1.incorrectAnswer}");
  //       log("${tempUser1.username} temp1Username, ${tempUser2.username} temp2Username");
  //       fireStoreService.updateUserResults(tempUser1, tempUser2, room!.id);
  //     } else {
  //       log("tempUser1 or tempUser2 is null. Unable to update results.");
  //     }
  //   } else {
  //     log("me or room is null. Unable to update results.");
  //   }
  // }
  userTappedmE(int thisQuestionINdex, String tappedAnswer) {
    final answer = quizBrain.checkAnswer(questionsModel, tappedAnswer);

    if (me != null && room != null) {
      MultiplayerUser? tempUser1;
      MultiplayerUser? tempUser2;
      if (me?.user_uid == room?.user1.user_uid) {
        tempUser1 = me;
        tempUser2 = room?.user2;
      } else {
        tempUser1 = me;
        tempUser2 = room?.user1;
      }
      if (tempUser1 != null && tempUser2 != null) {
        if (answer) {
          tempUser1.correctAnswer = (tempUser1.correctAnswer ?? 0) + 1;
        } else {
          tempUser1.incorrectAnswer = (tempUser1.incorrectAnswer ?? 0) + 1;
        }
        log("my Score: Correct ${tempUser1.correctAnswer}, Wrong ${tempUser1.incorrectAnswer}");

        // Update scores for tempUser2
        if (answer) {
          tempUser2.correctAnswer = (tempUser2.correctAnswer ?? 0) + 1;
        } else {
          tempUser2.incorrectAnswer = (tempUser2.incorrectAnswer ?? 0) + 1;
        }
        log("${tempUser1.username} temp1Username, ${tempUser2.username} temp2Username");

        fireStoreService.updateUserResults(tempUser1, tempUser2, room!.id);
      } else {
        log("tempUser1 or tempUser2 is null. Unable to update results.");
      }
    } else {
      log("me or room is null. Unable to update results.");
    }
  }

=======
  QuizBrainLogic quizBrain = QuizBrainLogic();
  
>>>>>>> Stashed changes
  getQuizList() {
    // Future<void> myQuizModel() async {
    FireStoreService service = FireStoreService();
    service.getQuizQuestions().listen((event) {
      questionsModel = event;
    });
    // }
  }

  Stream<UserModel> showUserScoreStream(String userID) {
    return fireStoreService.getUserByIDSTREAM(userid: userID);
  }

  void pickedOption(thisQuestionINdex, String tappedAnswer) async {
    final answer = quizBrain.checkAnswer(questionsModel, tappedAnswer);
    if (you != null) {
      if (answer == false) {
        you!.wrong = (you!.wrong ?? 0) + 1;
<<<<<<< Updated upstream
=======
        me!.incorrectAnswer = (me!.incorrectAnswer ?? 0) + 1;
>>>>>>> Stashed changes
        log("false");
      } else if (answer == true) {
        you!.correctAnswer = (you!.correctAnswer ?? 0) + 1;
        log("true");
      } else {
        log("don't know");
      }
    }
    fireStoreService.updateUser(you!);
    // UserModel? user1func;

    // UserModel? user2func;
    // if (you?.userUID == room?.user1.user_uid) {
    //   fireStoreService
    //       .getUserByID(userid: room!.user1.user_uid)
    //       .then((value) => user1func = value!);
    // } else if (you?.userUID == room?.user2.user_uid) {
    //   fireStoreService
    //       .getUserByID(userid: room!.user2.user_uid)
    //       .then((value) => user2func = value!);
    // }
    emit(QuizScoreUpdateState(user1: you!, user2: yourOpponent!));
    // if (condition) {
    fireStoreService.updateUser(you!);
    quizBrain.toNextQuestion();
    if (quizBrain.isLastQuestion(questionsModel)) {
      // quizBrain.reset();
      emit(QuizQuizCompletedState());
    } else {
      emit(QuizDataState(
        quizBrain: quizBrain,
        quizQuestions: questionsModel,
      ));
    }
  }
}
