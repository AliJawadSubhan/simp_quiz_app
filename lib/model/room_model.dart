import 'package:cloud_firestore/cloud_firestore.dart';

class MultiplayerRoom {
  final String id;
   MultiplayerUser user1;
   MultiplayerUser user2;

  MultiplayerRoom({
    required this.id,
    required this.user1,
    required this.user2,
  });

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'user1': user1.toFirebase(),
      'user2': user2.toFirebase(),
    };
  }

  factory MultiplayerRoom.fromFirebase(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    final user1Data = data['user1'] as Map<String, dynamic>;
    final user2Data = data['user2'] as Map<String, dynamic>;

    return MultiplayerRoom(
      id: data['id'],
      user1: MultiplayerUser.fromFirebase(user1Data),
      user2: MultiplayerUser.fromFirebase(user2Data),
    );
  }
}

class MultiplayerUser {
  final String user_uid;
  final String username;
  int correctAnswer;
  int incorrectAnswer;

  MultiplayerUser({
    required this.username,
    required this.user_uid,
    this.correctAnswer = 0,
    this.incorrectAnswer = 0,
  });

  Map<String, dynamic> toFirebase() {
    return {
      'user_uid': user_uid,
      'correctAnswer': correctAnswer,
      'incorrectAnswer': incorrectAnswer,
      "username": username,
    };
  }

  factory MultiplayerUser.fromFirebase(Map<String, dynamic> userData) {
    return MultiplayerUser(
      username: userData['username'],
      user_uid: userData['user_uid'],
      correctAnswer: userData['correctAnswer'] ?? 0,
      incorrectAnswer: userData['incorrectAnswer'] ?? 0,
    );
  }
}
