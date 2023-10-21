import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simp_quiz_app/model/quiz_question.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';

class FireStoreService {
  var db = FirebaseFirestore.instance;

  Future sendUsertoDatabase(String username, String id) async {
    try {
      return await db.collection('users').doc(id).set({
        'username': username.trim(),
        "user_id": id,
      });
    } catch (e) {
      log('firestore: ${e.toString()}');
    }
  }

  MultiplayerRoom createARoom(String userId1, String userId2) {
    final roomMultiplayerCollection = db.collection("multiplayerRoom");
    final roomID = roomMultiplayerCollection.doc().id;

    MultiplayerUser user1 = MultiplayerUser(user_uid: userId1);

    MultiplayerUser user2 = MultiplayerUser(user_uid: userId2);
    MultiplayerRoom multiplayerRoom =
        MultiplayerRoom(id: roomID, user1: user1, user2: user2);
    try {
      roomMultiplayerCollection.doc(roomID).set(multiplayerRoom.toFirebase());
    } catch (e) {
      log(e.toString());
    }
    return multiplayerRoom;
  }

  Stream<List<QuizQuestionModel>> getQuizQuestions() {
    final productCollectoin = db.collection('quiz_questions').snapshots();
    log('Quiz Collection: ${productCollectoin.first.then((value) => value)}');

    return productCollectoin.map((querySnapshots) {
      final categoryList = <QuizQuestionModel>[];
      log('querysnapshot.length: ${querySnapshots.docs.length}');
      for (var data in querySnapshots.docs) {
        QuizQuestionModel categoryModel = QuizQuestionModel.fromSnapshot(data);
        categoryList.add(categoryModel);
        log('Category Model: ${categoryModel.options}');
        log('Data : ${data.get('options')}');
      }
      return categoryList;
    });
  }

  Stream<List<UserModel>> getUsersButWithoutTheCurrentOne(
      String currentUserID) {
    final userCollection = db
        .collection("users")
        .where("user_id", isNotEqualTo: currentUserID)
        .snapshots();

    return userCollection.map((querySnapshots) {
      final userList = <UserModel>[];
      log('querysnapshot.length: ${querySnapshots.docs.length}');
      for (var data in querySnapshots.docs) {
        UserModel userModel = UserModel.fromSnapshot(data);
        userList.add(userModel);
        log('Category Model: ${userModel.username}');
        log('Data : ${data.get('user_id')}');
      }
      return userList;
    });
  }

  UserModel getCurrentUser({required String user_id}) {
    UserModel? userModel;
    db
        .collection("users")
        .doc(user_id)
        .snapshots()
        .map((event) => userModel = UserModel.fromSnapshot(event));
    return userModel!;
  }
}
