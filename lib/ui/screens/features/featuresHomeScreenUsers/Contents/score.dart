import 'package:flutter/material.dart';
import 'package:star_t/firebase/ModelInfoUser.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:status_alert/status_alert.dart';
import '../bodyScreenUsers/designCard/designCard.dart';

class Score extends StatefulWidget {
  Color color;
  String path;
  String titleCard;
  Color colorNatification;
  bool appearNatification;
  int numNatification;

  Score({
    super.key,
    required this.titleCard,
    required this.color,
    required this.path,
    required this.numNatification,
    required this.colorNatification,
    required this.appearNatification,
  });

  @override
  State<Score> createState() => _ContentsState();
}

class _ContentsState extends State<Score> {
  String title = "";
  int month = 100;
  int score = 0;

  @override
  void initState() {
    super.initState();
    getScore();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        StatusAlert.show(
          backgroundColor: Color(0xBA565353),
          borderRadius: BorderRadius.circular(40),
          context,
          duration: Duration(seconds: 5),
          configuration: WidgetConfiguration(
            widget: Column(
              children: [
                Center(
                  child: Text(
                    "$score",
                    style: const TextStyle(
                        fontSize: 80,
                        color: Color(0xfffbb800),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Score",
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(0xfffbb800),
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xfffbb800),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          maxWidth: 260,
        );
      },
      child: DesignCard(
        path: widget.path,
        titleCard: widget.titleCard,
        appearNatification: widget.appearNatification,
        colorNatification: widget.colorNatification,
        numNatification: widget.numNatification,
      ),
    );
  }
  // دالة Score لتحديث النص بناءً على score
  void scoreState(int score, int month) {
    if (score <= 100 && score > 80) {
      title = "Excellent! Keep it up"; // For high scores
    } else if (score <= 80 && score > 60) {
      title = "Great job! Keep going"; // For good scores
    } else if (score <= 60 && score > 40) {
      title = "You can do better!"; // For average scores
    } else if (score <= 40 && score > 20) {
      title = "Try harder!"; // For low scores
    } else if (score <= 20 && score > 0) {
      title = "Don't give up!"; // For very low scores
    } else if (score == 0) {
      title = "You can do it!"; // For zero score
    } else {
      title = "You're the best!"; // For scores higher than 100
    }
    setState(() {});
  }
  Future<void> getScore() async {
    try {
      var documents = await FirebaseUtils.getAllDocuments(ModelInfoUser.collection);
      if (documents != null && documents.isNotEmpty) {
        setState(() {
          score = documents[0]['count'] ?? 0;
          scoreState(score, month);
        });
      } else {
        print("Empty");
      }
    } catch (e) {
      print('Error$e');
    }
  }
}



