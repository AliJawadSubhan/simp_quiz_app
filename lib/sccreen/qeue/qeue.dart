import 'package:flutter/material.dart';
import 'package:simp_quiz_app/injection.dart';
import 'package:simp_quiz_app/internet_cubit.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/login/login_ui.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_screen.dart';
import 'package:simp_quiz_app/services/auth_serivces.dart';
import 'dart:developer';
import 'dart:math' as math;
import 'package:simp_quiz_app/services/db_service.dart';

class QueueScreen extends StatefulWidget {
  QueueScreen({super.key, required this.userModel});
  UserModel userModel;

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

// changede
// didcha
  Future<void> initialize() async {
    // log("Your Username: ${widget.userModel.username}");
    // log(" Your User id: ${widget.userModel.userUID}");
    await listofUsersWithoutID();
    await pickRandomOpponent();
    UserModel opponent = await pickRandomOpponent();
    MultiplayerRoom room = await dbService.createARoom(
      userId1: widget.userModel.userUID.toString(),
      userId2: opponent.userUID.toString(),
      username1: widget.userModel.username.toString(),
      username2: opponent.username.toString(),
    );

    final user = UserModel(
      username: widget.userModel.username,
      userUID: widget.userModel.userUID,
      correctAnswer: widget.userModel.correctAnswer,
      wrong: widget.userModel.wrong,
      isInGame: true,
    );
    // final opponents = UserModel(
    //   username: opponent.username,
    //   userUID: opponent.userUID,
    //   correctAnswer: opponent.correctAnswer,
    //   wrong: opponent.wrong,
    //   isInGame: true,
    // );
    dbService.updateUser(user).catchError(
        // test: .
        (err) {
      log(err.toString());
    });
    navigateToNextScreen(room);
  }

  void navigateToNextScreen(room) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          thisRoom: room,
          currentUser: widget.userModel,
        ),
      ),
    );
  }

  final FireStoreService _fireStoreService = FireStoreService();

  listofUsersWithoutID() {
    _fireStoreService
        .getUsersButWithoutTheCurrentOne(widget.userModel.userUID.toString())
        .listen((event) {
      setState(() {
        listOfUsersWithoutThecurrentOne = event;
      });
    });
  }

  AuthServices authServices = AuthServices();
  Future<UserModel> pickRandomOpponent() async {
    final availableOpponents = listOfUsersWithoutThecurrentOne
        .where((user) => user.isInGame == false)
        .toList();

    if (availableOpponents.isEmpty) {
      await Future.delayed(
        const Duration(seconds: 3),
        () {
          return pickRandomOpponent();
        },
      );
    }
    // if (condition) {

    // }

    var random = math.Random();
    int randomIndex = random.nextInt(availableOpponents.length);
    log("I think this is your opponent: ${availableOpponents[randomIndex].username!}");
    return availableOpponents[randomIndex];
  }

  FireStoreService dbService = FireStoreService();

  List<UserModel> listOfUsersWithoutThecurrentOne = [];

  @override
  Widget build(BuildContext context) {
    // initialize();
    log("length ${listOfUsersWithoutThecurrentOne.length}");
    // oppone
    log("message ${getIt<InternetCubit>().username}");

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            final user = UserModel(
              username: widget.userModel.username,
              userUID: widget.userModel.userUID,
              correctAnswer: widget.userModel.correctAnswer,
              wrong: widget.userModel.wrong,
              isInGame: true,
            );
            final succesBool = dbService.updatesUser(user);
            bool failORsucess = await authServices.userSignOUT();
            if (failORsucess && succesBool) {
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return LoginUI();
                },
              ));
            }
          },
          child: const Text("Please hold. "),
        ),
      ),
    );
  }
}
