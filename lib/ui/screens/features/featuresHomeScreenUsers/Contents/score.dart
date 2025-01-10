import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:status_alert/status_alert.dart';
import '../bodyScreenUsers/bottomAppBarUsers/statistcsViewModel.dart';
import '../bodyScreenUsers/designCard/designCard.dart';

class Score extends StatefulWidget {
  final Color color;
  final String path;
  final String titleCard;
  final Color colorNatification;
  final bool appearNatification;
  final int numNatification;
  final String selectedMonth;

  Score({
    super.key,
    required this.titleCard,
    required this.color,
    required this.path,
    required this.numNatification,
    required this.colorNatification,
    required this.appearNatification,
    required this.selectedMonth,
  });

  @override
  State<Score> createState() => _ContentsState();
}

class _ContentsState extends State<Score> {
  String title = "";
  @override
  Widget build(BuildContext context) {
    StatisticsViewModel statisticsViewModel = Provider.of<StatisticsViewModel>(context);
    bool isLoading = true;
    // استخدم FutureBuilder لانتظار قيمة السكور الكلي
    return FutureBuilder<int>(
      future: statisticsViewModel.getTotalScoreForYear("5u0qEXBm0eaW7J0n5Y8VhF5WdBD2", "1"),
      builder: (context, snapshot) {
        // عند التحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  InkWell(
            onTap: () async {
              // Fetch the total score for the user and year
              int score = await statisticsViewModel.getTotalScoreForYear("5u0qEXBm0eaW7J0n5Y8VhF5WdBD2", "1");

              // Update the score state and UI
              scoreState(score);

              // Show the StatusAlert with the score
              StatusAlert.show(
                backgroundColor: Color(0xBA565353),
                borderRadius: BorderRadius.circular(40),
                context,
                duration: Duration(seconds: 3),
                configuration: WidgetConfiguration(
                  widget: Column(
                    children: [
                      Center(
                        child: Text(
                          "$score",
                          style: const TextStyle(
                            fontSize: 80,
                            color: Color(0xfffbb800),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Score",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xfffbb800),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xfffbb800),
                              fontWeight: FontWeight.bold,
                            ),
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

        // إذا كانت البيانات موجودة
        if (snapshot.hasData) {
          return  InkWell(
            onTap: () {
              statisticsViewModel.getTotalScoreForYear("QL7vMrCkiAQJG994gIxlav8k8UO2", "1");
              int? score = snapshot.data;
              scoreState(score!);
              StatusAlert.show(
                backgroundColor: Color(0xBA565353),
                borderRadius: BorderRadius.circular(40),
                context,
                duration: Duration(seconds: 3),
                configuration: WidgetConfiguration(
                  widget: Column(
                    children: [
                      Center(
                        child:  Text(
                          "${score}",
                          style: const TextStyle(
                            fontSize: 80,
                            color: Color(0xfffbb800),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Score",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xfffbb800),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xfffbb800),
                              fontWeight: FontWeight.bold,
                            ),
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

        // دالة لتحديث العنوان بناءً على النقاط

        // في حالة حدوث خطأ
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // في حالة عدم وجود بيانات
        return Center(child: Text('No data available.'));
      },
    );
  }
  void scoreState(int score) {
    print("Score in scoreState: $score");  // طباعة النقاط للتأكد

    if (score <= 800 && score > 700) {
      title = "Excellent! Keep it up";
    } else if (score <= 700 && score > 600) {
      title = "Great job! Keep going";
    } else if (score <= 600 && score > 400) {
      title = "You can do better!";
    } else if (score <= 400 && score > 200) {
      title = "Try harder!";
    } else if (score <= 200 && score > 50) {
      title = "Don't give up!";
    } else if (score == 0) {
      title = "You can do it!";
    } else {
      title = "You're the best!";
    }

    print("Updated Title: $title");  // طباعة العنوان بعد التحديث

    // تأكد من تحديث واجهة المستخدم بعد تغيير العنوان
    setState(() {});
  }

}