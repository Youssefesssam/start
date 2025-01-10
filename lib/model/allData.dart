import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistcsViewModel.dart';

class AllData {
  late StatisticsViewModel statisticsViewModel; // ربط بالبروفايدر
  static int score = 0; // متغير لتخزين النتيجة
  static int massScore = 0; // متغير لتخزين النتيجة

  AllData(BuildContext context) {
    // الحصول على البيانات من البروفايدر
    statisticsViewModel = Provider.of<StatisticsViewModel>(context, listen: false);

    // الاستماع للتغيرات في البيانات
    statisticsViewModel.getStatisticsCircle2("score", "week_2", "01", ).listen((newScore) {
      score = newScore;
      print("Score updated: $score");
    });

    statisticsViewModel.getStatisticsCircle2("massScore", "week_2", "01", ).listen((newMassScore) {
      massScore = newMassScore;
      print("Mass Score updated: $massScore");
    });
  }
}