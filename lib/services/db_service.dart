import 'dart:developer';
// import 'dart:io';

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
        'inGame': false,
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
    final existingRoomQuery = await roomMultiplayerCollection
        .where('user1.user_uid', isEqualTo: userId1)
        .where('user2.user_uid', isEqualTo: userId2)
        .get();
    final secondExistingRoomQuery = await roomMultiplayerCollection
        .where('user1.user_uid', isEqualTo: userId2)
        .where('user2.user_uid', isEqualTo: userId1)
        .get();
    if (existingRoomQuery.docs.isNotEmpty) {
      // // MultiplayerRoom room;
      // log("Don't do this");
      // final snapshot = await roomMultiplayerCollection
      //     .where('user1.user_uid', isEqualTo: userId1)
      //     .where('user2.user_uid', isEqualTo: userId2)
      //     .get();
      return MultiplayerRoom.fromFirebase(existingRoomQuery.docs.first);
      // return
    } else if (secondExistingRoomQuery.docs.isNotEmpty) {
      // final snapshot = await roomMultiplayerCollection
      //     .where('user1.user_uid', isEqualTo: userId2)
      //     .where('user2.user_uid', isEqualTo: userId1)
      //     .get();
      return MultiplayerRoom.fromFirebase(secondExistingRoomQuery.docs.first);
    } else {
      final roomID = roomMultiplayerCollection.doc().id;

      MultiplayerUser user1 =
          MultiplayerUser(user_uid: userId1, username: username1);
      MultiplayerUser user2 =
          MultiplayerUser(user_uid: userId2, username: username2);

      MultiplayerRoom multiplayerRoom =
          MultiplayerRoom(id: roomID, user1: user1, user2: user2);
      final resultsSubcollection =
          roomMultiplayerCollection.doc(roomID).collection("results");

      try {
        // Set the room document
        await roomMultiplayerCollection
            .doc(roomID)
            .set(multiplayerRoom.toFirebase());

        // Create user documents within the "results" subcollection
        await resultsSubcollection.doc(userId1).set(user1.toFirebase());
        await resultsSubcollection.doc(userId2).set(user2.toFirebase());

        return multiplayerRoom;
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
  }

  Future<void> updateUser(UserModel user) async {
    final userDocRef = db.collection("users").doc(user.userUID);

    try {
      // Create a new UserModel with the updated data
      final updatedUser = UserModel(
        userUID: user.userUID,
        username: user.username,
        correctAnswer: user.correctAnswer,
        wrong: user.wrong,
        isInGame: user.isInGame,
      );

      // Update the document with the new data
      await userDocRef.update(updatedUser.toFirebase());

      // You can also use .set() to completely replace the document with the new data
      // await userDocRef.set(updatedUser.toFirebase());

      // Handle success
    } catch (e) {
      // Handle any errors
      log("Error updating user document: $e");
    }
  }

  Future<void> updateUserResults(MultiplayerUser user1, String roomID) async {
    final roomCollectionID = db.collection("multiplayerRoom").doc(roomID);

    final resultCollecForUser1 =
        roomCollectionID.collection("results").doc(user1.user_uid);
    // final resultCollecForUser2 =
    //     roomCollectionID.collection("results").doc(user2.user_uid);

    final userone = MultiplayerUser(
      username: user1.username,
      user_uid: user1.user_uid,
      incorrectAnswer: user1.incorrectAnswer,
      correctAnswer: user1.correctAnswer,
    );

    // final userTwo = MultiplayerUser(
    //   username: user2.username,
    //   user_uid: user2.user_uid,
    //   incorrectAnswer: user2.incorrectAnswer,
    //   correctAnswer: user2.correctAnswer,
    // );
    await resultCollecForUser1.update(userone.toFirebase());

    // await resultCollecForUser2.update(userTwo.toFirebase());
  }

  bool updatesUser(UserModel user) {
    final userDOCRED = db.collection("users").doc(user.userUID);
    try {
      final userModel = UserModel(
        username: user.username,
        userUID: user.userUID,
        correctAnswer: user.correctAnswer,
        wrong: user.wrong,
        isInGame: user.isInGame,
      );
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
        // .where('inGame', ixsEqualTo: false)
        .snapshots();

    return userCollection.map((querySnapshots) {
      final userList = <UserModel>[];
      log('querysnapshot.length: ${querySnapshots.docs.length}');
      for (var data in querySnapshots.docs) {
        UserModel userModel = UserModel.fromSnapshot(data);
        userList.add(userModel);
        log('User Model without the current: ${userModel.username}');
        log('Data without the current one: ${data.get('user_id')}');
      }
      return userList;
    });
  }

  Stream<UserModel> getUserByIDSTREAM({required String userid}) {
    final userDocRef = db.collection("users").doc(userid);
    return userDocRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromSnapshot(snapshot);
      } else {
        // Handle the case where the document doesn't exist
        throw Exception("Error Fetching user");
      }
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
