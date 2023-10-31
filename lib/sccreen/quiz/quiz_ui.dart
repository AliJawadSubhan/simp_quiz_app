// import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simp_quiz_app/model/room_model.dart';
import 'package:simp_quiz_app/model/user_model.dart';
import 'package:simp_quiz_app/sccreen/quiz/quiz_cubit.dart';

class QuizUI extends StatelessWidget {
  QuizUI({super.key, required this.thisRoom, required this.currentUser});
  final listofOptions = [
    'a',
    'b',
    'c',
    'd',
  ];
  final MultiplayerRoom thisRoom;
  final UserModel currentUser;
  QuizCubit quizCubit = QuizCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              left: 0,
              right: 0,
              child: SvgPicture.asset("images/bg.svg", fit: BoxFit.fill)),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question 1/4",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Which planet is known as the Red Planet?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listofOptions.length,
                        itemBuilder: (context, index) {
                          // item
                          return InkWell(
                            onTap: () {
                              log("button tapped ${listofOptions[index]}");
                            },
                            child: Material(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 21),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      onTap: () {
                                        log("button tapped ${listofOptions[index]}");
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(listofOptions[index]
                                                  .toUpperCase()),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                "Options",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
