import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_t/model/modelUser.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';

class Menu extends StatefulWidget {
  final String userId;
  final MyUser user;
  final VoidCallback onCloseMenu;

  const Menu({
    super.key,
    required this.onCloseMenu,
    required this.userId,
    required this.user,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int totalScore = 0;
  bool isMassActive = false;
  int massScore = 0;
  bool isCommunionActive = false;
  int communionScore = 0;
  bool isConfessionActive = false;
  int confessionScore = 0;
  bool isMeetingActive = false;
  int meetingScore = 0;
  bool isWaiting = false;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);
    FireBaseGetDataForLeader fireBaseGetDataForLeader =
    FireBaseGetDataForLeader();
    FireBaseGetDataForLeader.getCurrentWeek();

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xd0777676),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[800]!.withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow("القداس", isMassActive, massScore,
                  () => toggleState("mass")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("التناول", isCommunionActive, communionScore,
                  () => toggleState("communion")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاعتراف", isConfessionActive, confessionScore,
                  () => toggleState("confession")),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاجتماع", isMeetingActive, meetingScore,
                  () => toggleState("meeting")),
          const Divider(thickness: 1, color: Colors.white),
          Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isWaiting)
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                            color: Colors.white),
                      )
                    else if (isDone)
                      const Icon(Icons.done,
                          color: Colors.green, size: 30)
                    else
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: resetScores,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border:
                                Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Text("RESET",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              print('++++++++++++++${authProviders.week!}++++++++');
                              print('++++++++++++++${authProviders.weekUse!}++++++++');
                              FireBaseGetDataForLeader.saveDateInProvider(context);
                              addScoreUser(
                                score: totalScore,
                                meetingScoreDB: meetingScore,
                                communionScoreDB: communionScore,
                                confessionScoreDB: confessionScore,
                                massScoreDB: massScore,
                                weekNumber: authProviders.week!,
                              );
                              if (isMeetingActive) {
                                FireBaseSetDataForLeader.UsersAreadyAttend(
                                  authProviders.weekUse!,
                                  widget.user,
                                  totalScore,
                                  massScore,
                                  communionScore,
                                  confessionScore,
                                  meetingScore,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text("CONFIRM",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                          ),
                        ],
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(label,
              style: const TextStyle(fontSize: 25, color: Colors.white)),
        ),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isActive
              ? Text("+$score",
              key: ValueKey(label),
              style:  TextStyle(color: Colors.blue, fontSize: 20))
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

  void toggleState(String key) {
    setState(() {
      switch (key) {
        case "mass":
          isMassActive = !isMassActive;
          massScore = isMassActive ? 25 : 0;
          break;
        case "communion":
          isCommunionActive = !isCommunionActive;
          communionScore = isCommunionActive ? 25 : 0;
          break;
        case "confession":
          isConfessionActive = !isConfessionActive;
          confessionScore = isConfessionActive ? 25 : 0;
          break;
        case "meeting":
          isMeetingActive = !isMeetingActive;
          meetingScore = isMeetingActive ? 25 : 0;
          break;
      }
      totalScore =
          massScore + communionScore + confessionScore + meetingScore;
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

  void addScoreUser({
    required int score,
    required int meetingScoreDB,
    required int communionScoreDB,
    required int confessionScoreDB,
    required int massScoreDB,
    required int weekNumber,
  }) async {
    setState(() {
      isWaiting = true;
      isDone = false;
    });
    final prefs = await SharedPreferences.getInstance();


    AuthProviders authProviders = Provider.of(context, listen: false);
    String userId = widget.userId;

    if (userId.isEmpty) {
      setState(() => isWaiting = false);
      return;
    }

    final WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      // طباعة القيم قبل إرسالها لـ Firebase لأغراض التصحيح
      print("=== DEBUG: Sending to Firebase ===");
      print("Mass: $massScoreDB");
      print("Communion: $communionScoreDB");
      print("Confession: $confessionScoreDB");
      print("Meeting: $meetingScoreDB");
      print("Total: $score");
      print('month number: ${authProviders.currentMonth!}');
      print('week number: ${authProviders.week}');

      await FireBaseSetDataForLeader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: score,
        scoreType: 'leaderScore',
        userId: userId,
      );

      await FireBaseSetDataForLeader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: massScoreDB,
        scoreType: 'massScoreDB',
        userId: userId,
      );

      await FireBaseSetDataForLeader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: communionScoreDB,
        scoreType: 'communionScoreDB',
        userId: userId,
      );

      await FireBaseSetDataForLeader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: confessionScoreDB,
        scoreType: 'confessionScoreDB',
        userId: userId,
      );

      await FireBaseSetDataForLeader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: meetingScoreDB,
        scoreType: 'meetingScoreDB',
        userId: userId,
      );

      FireBaseSetDataForLeader.getThisDetalsWeek(
        userId: userId,
        numWeek: authProviders.week!,
        monthId: authProviders.currentMonth!,
        numWeekUse: authProviders.weekUse!,
      );

      DocumentReference massRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('scores')
          .doc('massScoreDB');

      DocumentReference communionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('scores')
          .doc('communionScoreDB');

      DocumentReference confessionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('scores')
          .doc('confessionScoreDB');

      DocumentReference meetingRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('scores')
          .doc('meetingScoreDB');

      DocumentReference leaderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);

      batch.set(massRef, {'value': massScoreDB});
      batch.set(communionRef, {'value': communionScoreDB});
      batch.set(confessionRef, {'value': confessionScoreDB});
      batch.set(meetingRef, {'value': meetingScoreDB});
      batch.set(leaderRef, {'leaderScore': score}, SetOptions(merge: true));

      await batch.commit();

      setState(() {
        isWaiting = false;
        isDone = true;
      });

      Future.delayed(const Duration(milliseconds: 650), () {
        widget.onCloseMenu();
      });
    } catch (error) {
      print("Error adding data: $error");
      setState(() {
        isWaiting = false;
        isDone = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding data: $error")),
      );
    }
  }
}