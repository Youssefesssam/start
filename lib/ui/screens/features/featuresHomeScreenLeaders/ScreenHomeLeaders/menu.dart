import 'package:flutter/material.dart';

import '../../../../../firebase/ModelInfoUser.dart';
import '../../../../../firebase/firebase.dart';

class Menu extends StatefulWidget {
  final VoidCallback onCloseMenu; // Callback لإغلاق المنيو

  const Menu({super.key, required this.onCloseMenu});

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

  // حالة العملية (في انتظار أو مكتملة)
  bool isWaiting = false;
  bool isDone = false;

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
          buildRow(
              "القداس", isMassActive, massScore, () => toggleState("mass")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("التناول", isCommunionActive, communionScore, () =>
              toggleState("communion")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاعتراف", isConfessionActive, confessionScore, () =>
              toggleState("confession")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاجتماع", isMeetingActive, meetingScore, () =>
              toggleState("meeting")),
          const Divider(thickness: 1, color: Colors.white),
          Row(
            children: [
              // عرض زر الانتظار أو الإضافة بناءً على الحالة
              if (isWaiting)
                Container(
                    margin: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator(
                        color: Colors.blueAccent))
              else
                if (isDone)
                  const Icon(Icons.done, color: Colors.green, size: 30)
                else
                  InkWell(
                    onTap:()=> addScoreUser(score: totalScore,meetingScoreDB: meetingScore,communionScoreDB: communionScore,confessionScoreDB: confessionScore,massScoreDB: massScore),
                    child: Row(
                      children: const [
                        Icon(Icons.add, color: Colors.blueAccent, size: 30),
                        SizedBox(width: 10),
                        Text(
                          "Add Score",
                          style: TextStyle(
                              fontSize: 20, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
              const Spacer(),
              InkWell(
                onTap: resetScores,
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red, size: 30),
                    SizedBox(width: 10),
                    Text(
                      "Delete Score",
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
              isActive ? Icons.check_box : Icons
                  .check_box_outline_blank_outlined,
              key: ValueKey(isActive),
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void toggleState(String key) {
    setState(() {
      if (key == "mass") {
        isMassActive = !isMassActive;
        massScore = isMassActive ? 25 : 0;
      } else if (key == "communion") {
        isCommunionActive = !isCommunionActive;
        communionScore = isCommunionActive ? 25 : 0;
      } else if (key == "confession") {
        isConfessionActive = !isConfessionActive;
        confessionScore = isConfessionActive ? 25 : 0;
      } else if (key == "meeting") {
        isMeetingActive = !isMeetingActive;
        meetingScore = isMeetingActive ? 25 : 0;
      }

      totalScore = massScore + communionScore + confessionScore + meetingScore;
    });
  }

  void resetScores() {
    setState(() {
      totalScore = 0;
      isMassActive = isCommunionActive = isConfessionActive = isMeetingActive =
      false;
      massScore = communionScore = confessionScore = meetingScore = 0;
      isWaiting = false;
      isDone = false;
    });
  }


  void addScoreUser( {required int score, required int meetingScoreDB, required int communionScoreDB, required int confessionScoreDB, required int massScoreDB}) {
    print("Start adding data");

    // تحديث الحالة إلى انتظار
    setState(() {
      isWaiting = true;
      isDone = false;
    });

    // إنشاء الكائن ModelInfoUser
    ModelInfoUser modelInfoUser = ModelInfoUser(
      score: score,
      massScore: massScore,
      communionScore: communionScore,
      confessionScore: confessionScore,
      meetingScore: meetingScoreDB,
    );

    // إضافة البيانات إلى Firebase
    FirebaseUtils.addData(modelInfoUser).then((value) {
      print("Data added successfully!");

      // تحديث الحالة إلى مكتمل
      setState(() {
        isWaiting = false;
        isDone = true;
      });

      // إغلاق المنيو بعد تأخير قصير
      Future.delayed(const Duration(milliseconds: 650), () {
        widget.onCloseMenu();
      });
    }).catchError((error) {
      print("Error adding data: $error");

      // إعادة الحالة إلى الوضع الافتراضي عند حدوث خطأ
      setState(() {
        isWaiting = false;
        isDone = false;
      });
    });
  }
}





