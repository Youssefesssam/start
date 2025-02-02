import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/compettion/natification/natification.dart';
import 'package:status_alert/status_alert.dart';
import '../../../../../../utilites/appColors.dart';
import '../../bodyScreenUsers/bottomAppBarUsers/statistcsViewModel.dart';


class Score extends StatefulWidget {
  final Color colorNatification;
  final bool appearNatification;
  final int numNatification;
  final String selectedMonth;

  Score({
    super.key,
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
    return FutureBuilder<int>(
      future: statisticsViewModel.getTotalScoreForYear("5u0qEXBm0eaW7J0n5Y8VhF5WdBD2", "1"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  InkWell(
            onTap: () async {
              int score = await statisticsViewModel.getTotalScoreForYear("5u0qEXBm0eaW7J0n5Y8VhF5WdBD2", "1");
              scoreState(score);
              StatusAlert.show(
                backgroundColor: Color(0xc70d5e54),
                borderRadius: BorderRadius.circular(40),
                context,
                duration: Duration(seconds: 30),
                configuration: WidgetConfiguration(
                  widget: Column(
                    children: [
                      Center(
                        child: Text(
                          "$score",
                          style:  TextStyle(
                            fontSize: 80,
                            color:Color(0xffffffff),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                       Text(
                        "Score",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style:  TextStyle(
                              fontSize: 20,
                              color:Color(0xffffffff),
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
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin:  const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.width * 0.32,
                  width: MediaQuery.of(context).size.width * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: AppColors.smoothColorTeal,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sports_score,
                        size: MediaQuery.of(context).size.width * 0.13,
                        color:AppColors.white,),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.005),
                      Text(
                        "Score",
                        style: GoogleFonts.aclonica(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Natification(color: Colors.red, num: 5, appear: true, appearIcon: true,)
              ],
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
                backgroundColor: Color(0x9101655A),
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
            child:Container(
              margin:  const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.width * 0.32,
              width: MediaQuery.of(context).size.width * 0.32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: AppColors.smoothColorTeal,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_score,
                    size: MediaQuery.of(context).size.width * 0.13,
                    color:AppColors.white,),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.005),
                  Text(
                    "Score",
                    style: GoogleFonts.aclonica(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // في حالة عدم وجود بيانات
        return Center(child: Text('No data available.'));
      },
    );
  }
  void scoreState(int score) {
    print("Score in scoreState: $score");
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