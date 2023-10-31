
import 'dart:developer';
// import 'dart:html';

import 'package:flutter/material.dart';

class StaticQuizPage extends StatelessWidget {
  const StaticQuizPage({
    super.key,
    required this.listofOptions,
  });

  final List<String> listofOptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.3),
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
                "Waiting for a question!",
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
                          padding:
                              const EdgeInsets.only(bottom: 21),
                          child: Container(
                            height:
                                MediaQuery.of(context).size.height *
                                    0.1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  log("button tapped ${listofOptions[index]}");
                                },
                                borderRadius:
                                    BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(listofOptions[index]
                                            .toUpperCase()),
                                         SizedBox(
                                          width: 5,
                                        ),
                                        Text(
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
    );
  }
}
