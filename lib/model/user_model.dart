import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? username;
  final String? userUID;
  UserModel({required this.username, required this.userUID});
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      username: data['username'],
      userUID: data["user_id"],
    );
  }
}
