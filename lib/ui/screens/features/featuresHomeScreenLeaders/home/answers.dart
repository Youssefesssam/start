import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import 'package:star_t/utilites/appColors.dart';

class Answers extends StatefulWidget {
  static const String routeName = 'answers';

  const Answers({super.key});

  @override
  State<Answers> createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {
  Map<int, bool> expandedState = {};
  @override
  Widget build(BuildContext context) {
    int selectedMonth =0;
    List<String>month=['1','7','4','5','5'];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.backGround, begin: Alignment.bottomCenter,end: Alignment.topRight)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Answers",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
          elevation: 15,
        ),
        body: FutureBuilder<List<Map<String, String>>>(
          future: FireBaseGetDataForLeader.receiveAnswers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No answers yet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white),
                ),
              );
            }

            List<Map<String, String>> answers = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: answers.length,
              itemBuilder: (context, index) {
                expandedState.putIfAbsent(index, () => false);
                String answerText = answers[index]['answer'] ?? "No answer";
                bool isLong = answerText.length > 100;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  shadowColor: Colors.teal.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.teal.shade100,
                              child: Icon(Icons.person, color: Colors.teal.shade700, size: 30),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 6,
                              child: Text(
                                answers[index]['sender'] ?? "Unknown",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(right: 30),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 80,
                                      child: CupertinoPicker(
                                        itemExtent: 20,
                                        scrollController: FixedExtentScrollController(
                                            initialItem:
                                            ((5 - 1) ~/ 4)),
                                        onSelectedItemChanged: (index) {
                                          setState(() {
                                            selectedMonth =1;
                                          });
                                        },
                                        children: month.map((letter) {
                                          return Center(
                                            child: Text(
                                              letter,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.black,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 10),

                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: expandedState[index]!
                                      ? answerText
                                      : (isLong ? answerText.substring(0, 80) + "..." : answerText),
                                ),
                                if (isLong)
                                  TextSpan(
                                    text: expandedState[index]! ? " less" : "...more",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        setState(() {
                                          expandedState[index] = !expandedState[index]!;
                                        });
                                      },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
