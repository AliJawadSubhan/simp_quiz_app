import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    // await pickRandomOpponent();
    UserModel opponent = await pickRandomOpponent().catchError((onError) {
      log("this is your opponent error: $onError");
    });
    log("this is your opponent: ${opponent.username}");
    MultiplayerRoom room = await dbService.createARoom(
      userId1: widget.userModel.userUID.toString(),
      userId2: opponent.userUID.toString(),
      username1: widget.userModel.username.toString(),
      username2: opponent.username.toString(),
    );

    log("this is your room: ${room.id}");

    final user = UserModel(
      username: widget.userModel.username,
      userUID: widget.userModel.userUID,
      correctAnswer: widget.userModel.correctAnswer,
      wrong: widget.userModel.wrong,
      isInGame: true,
    );
    final opponents = UserModel(
      username: opponent.username,
      userUID: opponent.userUID,
      correctAnswer: opponent.correctAnswer,
      wrong: opponent.wrong,
      isInGame: true,
    );
    dbService.updateUser(user).catchError(
        // test: .
        (err) {
      log(err.toString());
    });
    dbService.updateUser(opponents).catchError(
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
      await Future.delayed(const Duration(seconds: 3));
      return pickRandomOpponent();
    } else {
      var random = math.Random();
      int randomIndex = random.nextInt(availableOpponents.length);
      log("This is your opponent: ${availableOpponents[randomIndex].username}");
      return availableOpponents[randomIndex];
    }
  }

  FireStoreService dbService = FireStoreService();

  List<UserModel> listOfUsersWithoutThecurrentOne = [];

  @override
  Widget build(BuildContext context) {
    // initialize();
    log("length ${listOfUsersWithoutThecurrentOne.length}");
    // log(message)
    // pickRandomOpponent();
    // oppone
    log("message ${getIt<InternetCubit>().username}");

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            left: 0,
            right: 0,
            child: SvgPicture.asset("images/bg.svg", fit: BoxFit.fill),
          ),
          // Stylish Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game Name
                const Text(
                  "Crazy Quiz Masters",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Message
                const Text(
                  "Looking for your Opponent...",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // About Us
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "About Us:\nWe are the Crazy Quiz Masters, dedicated to bringing you the most challenging and fun quiz experience. Get ready to test your knowledge and have a blast!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
