import 'package:flutter/material.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/login/login_ui.dart';
import 'package:simp_quiz_app/sccreen/qeue/qeue_logic.dart';
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
    log("Username: ${widget.userModel.username}");
    log("User id: ${widget.userModel.userUID}");
    listofUsersWithoutID();
    // pickRandomOpponent();
    // generateRoom();
    logValues();
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

  // UserModel opponent;
  Future<UserModel> pickRandomOpponent() async {
    if (listOfUsersWithoutThecurrentOne.isEmpty) {
      await Future.delayed(
          const Duration(
            seconds: 2,
          ), () {
        return pickRandomOpponent();
      });
    } else if (listOfUsersWithoutThecurrentOne.length == 1) {
      return listOfUsersWithoutThecurrentOne[0];
    }
    var random = math.Random();
    int randomIndex = random.nextInt(listOfUsersWithoutThecurrentOne.length);
    return listOfUsersWithoutThecurrentOne[randomIndex];
  }

  FireStoreService dbService = FireStoreService();

  List<UserModel> listOfUsersWithoutThecurrentOne = [];
  logValues() async {
    UserModel opponent = await pickRandomOpponent();
    MultiplayerRoom room = await dbService.createARoom(
        widget.userModel.userUID.toString(), opponent.userUID.toString());
    log("${room.id} Room ID");
    log("${room.user1.user_uid} my id");
    log("${room.user2.user_uid} opponent id");
    log("${opponent.username} Username");
  }

  @override
  Widget build(BuildContext context) {
    log("length ${listOfUsersWithoutThecurrentOne.length}");

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
