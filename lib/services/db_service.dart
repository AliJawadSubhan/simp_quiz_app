import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        "correct": 0,
        "wrong": 0,
      });
    } catch (e) {
      log('firestore: ${e.toString()}');
    }
  }

  Future<MultiplayerRoom> createARoom(
      {required String userId1,
      required String userId2,
      required String username1,
      required String username2}) async {
    final roomMultiplayerCollection = db.collection("multiplayerRoom");

    // Sort the user IDs to maintain consistent ordering
    List<String> sortedUserIds = [userId1, userId2]..sort();

    final existingRoomQuery = await roomMultiplayerCollection
        .where('user1.user_uid', isEqualTo: sortedUserIds[0])
        .where('user2.user_uid', isEqualTo: sortedUserIds[1])
        .get();

    if (existingRoomQuery.docs.isNotEmpty) {
      final snapshot = await roomMultiplayerCollection
          .where('user1.user_uid', isEqualTo: sortedUserIds[0])
          .where('user2.user_uid', isEqualTo: sortedUserIds[1])
          .get();
      return MultiplayerRoom.fromFirebase(snapshot.docs.first);
    } else {
      final roomID = roomMultiplayerCollection.doc().id;

      MultiplayerUser user1 =
          MultiplayerUser(user_uid: sortedUserIds[0], username: username1);
      MultiplayerUser user2 =
          MultiplayerUser(user_uid: sortedUserIds[1], username: username2);

      MultiplayerRoom multiplayerRoom =
          MultiplayerRoom(id: roomID, user1: user1, user2: user2);

      try {
        await roomMultiplayerCollection
            .doc(roomID)
            .set(multiplayerRoom.toFirebase());
        return multiplayerRoom;
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
  }

  // Future<Us

  Future<MultiplayerRoom> updateUserResults(
      MultiplayerUser user1, MultiplayerUser user2, String roomID) async {
    final roomCollectionID = db.collection("multiplayerRoom").doc(roomID);

    final room = MultiplayerRoom(id: roomID, user1: user1, user2: user2);

    await roomCollectionID.update(room.toFirebase());

    return room;

    // roomCollection.doc(roomID).update(room.toFirebase());
  }

  bool updateUser(UserModel user) {
    final userDOCRED = db.collection("users").doc(user.userUID);
    try {
      final userModel = UserModel(
          username: user.username,
          userUID: user.userUID,
          correctAnswer: user.correctAnswer,
          wrong: user.wrong);
      userDOCRED.update(
        userModel.toFirebase(),
      );
      return true;
    } catch (e) {
      return false;
    }
    // return false;
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

  Future<UserModel?> getUserByID({required String userid}) async {
    debugPrint("===> MyUserId $userid");
    UserModel? userModel;

    try {
      final snapshot = await db.collection("users").doc(userid).get();

      if (snapshot.exists) {
        userModel = UserModel.fromSnapshot(snapshot);
        debugPrint("${userModel.username!} username");
        return userModel;
      } else {
        debugPrint("User not found");
        return null;
      }
    } catch (error) {
      debugPrint("Error retrieving user: $error");
      return null;
    }
  }
}
