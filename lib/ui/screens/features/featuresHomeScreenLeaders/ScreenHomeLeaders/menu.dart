import 'package:flutter/material.dart';

import '../../../../../firebase/ModelInfoUser.dart';
import '../../../../../firebase/firebase.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int totalScore = 0; // إجمالي النقاط

  // حالات العناصر ونقاطها
  bool isMassActive = false;
  int massScore = 0;

  bool isCommunionActive = false;
  int communionScore = 0;

  bool isConfessionActive = false;
  int confessionScore = 0;

  bool isMeetingActive = false;
  int meetingScore = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xe42f2e2e),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow("القداس", isMassActive, massScore, () => toggleState("mass")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("التناول", isCommunionActive, communionScore, () => toggleState("communion")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاعتراف", isConfessionActive, confessionScore, () => toggleState("confession")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاجتماع", isMeetingActive, meetingScore, () => toggleState("meeting")),
          const Divider(thickness: 1, color: Colors.white),
          Row(
            children: [
              InkWell(
                onTap: (){
                  addScoreUser(
                    totalScore,
                    massScore,
                    communionScore,
                    confessionScore,
                    meetingScore,
                  );
                },
                child: const Icon(Icons.add, color: Colors.blueAccent, size: 30),
              ),
              InkWell(
                onTap: (){
                  addScoreUser(
                    totalScore,
                    massScore,
                    communionScore,
                    confessionScore,
                    meetingScore,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    "Add Score",
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                ),
              ),

              Spacer(),
              InkWell(
                onTap: resetScores,
                child: const Icon(Icons.delete, color: Colors.red, size: 30),
              ),
              InkWell(
                onTap: resetScores,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    "Delete Score ",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }

  // Create row for each item
  Widget buildRow(String label, bool isActive, int score, VoidCallback toggle) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            label,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isActive
              ? Text(
            "+$score",
            key: ValueKey(label),
            style: const TextStyle(color: Colors.green, fontSize: 20),
          )
              : const SizedBox(key: ValueKey("hidden")),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: toggle,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isActive
                  ? Icons.check_box
                  : Icons.check_box_outline_blank_outlined,
              key: ValueKey(isActive),
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  // Update the state for each item
  void toggleState(String key) {
    setState(() {
      if (key == "mass") {
        if (isMassActive) {
          isMassActive = false;
          massScore = 0;
          totalScore -= 25;
        } else {
          isMassActive = true;
          massScore = 25;
          totalScore += 25;
        }
      } else if (key == "communion") {
        if (isCommunionActive) {
          isCommunionActive = false;
          communionScore = 0;
          totalScore -= 25;
        } else {
          isCommunionActive = true;
          communionScore = 25;
          totalScore += 25;
        }
      } else if (key == "confession") {
        if (isConfessionActive) {
          isConfessionActive = false;
          confessionScore = 0;
          totalScore -= 25;
        } else {
          isConfessionActive = true;
          confessionScore = 25;
          totalScore += 25;
        }
      } else if (key == "meeting") {
        if (isMeetingActive) {
          isMeetingActive = false;
          meetingScore = 0;
          totalScore -= 25;
        } else {
          isMeetingActive = true;
          meetingScore = 25;
          totalScore += 25;
        }
      }
    });
    print("Total Score: $totalScore");
  }

  // Reset all scores and states
  void resetScores() {
    setState(() {
      totalScore = 0;
      isMassActive = false;
      massScore = 0;
      isCommunionActive = false;
      communionScore = 0;
      isConfessionActive = false;
      confessionScore = 0;
      isMeetingActive = false;
      meetingScore = 0;
    });
    print("Scores reset. Total Score: $totalScore");
  }
  void addScoreUser(int score, int massScoreDB, int communionScoreDB, int confessionScoreDB, int meetingScoreDB) {
    print("Start adding data");

    // Create a model instance with the required data
    ModelInfoUser modelInfoUser = ModelInfoUser(
      score: score,
      massScore: massScoreDB,
      communionScore: communionScoreDB,
      confessionScore: confessionScoreDB,
      meetingScore: meetingScoreDB,
    );

    FirebaseUtils.addData(modelInfoUser).then((value) {
          print("Data added successfully!");
    }).catchError((error) {
      print(error);

    });
  }

}
