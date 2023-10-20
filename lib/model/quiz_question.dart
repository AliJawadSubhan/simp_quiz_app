// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestionModel {
  final String question;
  final List options;
  final String correctAnswer;

  QuizQuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestionModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    return QuizQuestionModel(
      question: data["question"],
      options: data["options"] ,
      correctAnswer: data["correctAnswer"],
    );
  }
}
