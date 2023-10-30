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
  const QueueScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
<<<<<<< Updated upstream
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
    navigateToNextScreen(room);
=======
    try {
      // Log your Username and User ID if needed
      // log("Your Username: ${widget.userModel.username}");
      // log("Your User ID: ${widget.userModel.userUID}");

      // Fetch a list of available opponents without the current user
      await listofUsersWithoutID();

      // Pick a random opponent
      UserModel opponent = await pickRandomOpponent().catchError((onError) {
        log("This is your opponent error: $onError");
      });

      log("This is your opponent: ${opponent.username}");

      MultiplayerRoom room = await dbService.createARoom(
        userId1: widget.userModel.userUID.toString(),
        userId2: opponent.userUID.toString(),
        username1: widget.userModel.username.toString(),
        username2: opponent.username.toString(),
      );

      log("This is your room: ${room.id}");

      final user = UserModel(
        username: widget.userModel.username,
        userUID: widget.userModel.userUID,
        correctAnswer: widget.userModel.correctAnswer,
        wrong: widget.userModel.wrong,
        isInGame: true,
      );

      await dbService.updateUser(user);

      navigateToNextScreen(room);
    } catch (error) {
      log("An error occurred during initialization: $error");
      initialize();
    }
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
  // UserModel opponent;
  Future<UserModel> pickRandomOpponent() async {
    if (listOfUsersWithoutThecurrentOne.isEmpty) {
      await Future.delayed(
          const Duration(
            seconds: 3,
          ), () {
        return pickRandomOpponent();
      });
    } else if (listOfUsersWithoutThecurrentOne.length == 1) {
      return listOfUsersWithoutThecurrentOne[0];
=======
    if (availableOpponents.isEmpty) {
      await Future.delayed(const Duration(seconds: 3));
      return pickRandomOpponent();
    } else {
      var random = math.Random();
      int randomIndex = random.nextInt(availableOpponents.length);
      log("This is your opponent: ${availableOpponents[randomIndex].username}");
      return availableOpponents[randomIndex];
>>>>>>> Stashed changes
    }
    var random = math.Random();
    int randomIndex = random.nextInt(listOfUsersWithoutThecurrentOne.length);
    return listOfUsersWithoutThecurrentOne[randomIndex];
  }

  FireStoreService dbService = FireStoreService();

  List<UserModel> listOfUsersWithoutThecurrentOne = [];
  logValues() async {}

  @override
  Widget build(BuildContext context) {
    log("length ${listOfUsersWithoutThecurrentOne.length}");

    log("message ${getIt<InternetCubit>().username}");
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            bool failORsucess = await authServices.userSignOUT();
            if (failORsucess) {
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
