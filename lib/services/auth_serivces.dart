import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:simp_quiz_app/services/db_service.dart';

class AuthServices {
  

    Future<String> getCurrentUserUID() async {
      final User? user = authInstance.currentUser;
      final uid = user?.uid;
      if (uid  == null) {
        return "null user_ID";
      } else {
      return uid;
    }
    }

  FireStoreService _db = FireStoreService();
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

  createGuestUser(String username) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    String userUid = userCredential.user!.uid;
    await _db.sendUsertoDatabase(username, userUid);
  }
}
