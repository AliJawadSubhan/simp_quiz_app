import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/services/db_service.dart';

class AuthServices {
  // final userData = getIt<UserData>();
  Future<String> getCurrentUserUID() async {
    final User? user = authInstance.currentUser;
    final uid = user?.uid;
    if (uid == null) {
      return "null user_ID";
    } else {
      return uid;
    }
  }

  Future<bool> userSignOUT() async {
    try {
      authInstance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  final FireStoreService _db = FireStoreService();
  FirebaseAuth authInstance = FirebaseAuth.instance;
  Future<bool> loginService(String username) async {
// trry

    try {
      await createGuestUser(username);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<UserModel> createGuestUser(String username) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    String userUid = userCredential.user!.uid;
    await _db.sendUsertoDatabase(username, userUid);

    // userData.updateUserModel(UserModel(username: username, userUID: userUid));

    return UserModel(username: username, userUID: userUid);
  }
}
