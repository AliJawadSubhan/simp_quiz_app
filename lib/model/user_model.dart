import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? username;
  final String? userUID;
  int? correctAnswer;
  int? wrong;
  bool? isInGame;
  UserModel({
    required this.username,
    required this.userUID,
    required this.correctAnswer,
    required this.wrong,
    this.isInGame,
  });
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      username: data['username'],
      userUID: data["user_id"],
      correctAnswer: data['correct'],
      wrong: data['wrong'],
      isInGame: data['inGame'],
    );
  }
  Map<String, dynamic> toFirebase() {
    return {
      'username': username,
      'user_id': userUID,
      'correct': correctAnswer,
      'wrong': wrong,
      'inGame': isInGame,
    };
  }
}
