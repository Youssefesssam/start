import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_t/firebase/firebase.dart';

import '../../../../../../model/modelData.dart';
import '../../../../../../model/modelMonth.dart';
import '../../../../../../model/modelUser.dart';
import '../../../../../../model/modelYear.dart';
import '../../../../../../model/modelweek.dart';

class StatisticsViewModel extends ChangeNotifier {
  int selectedMonthIndex = 0;
  int selectedWeekIndex = 0;

  final List<String> months = [
    'month 1',
    'month 2',
    'month 3',
    'month 4',
    'month 5',
    'month 6',
    'month 7',
    'month 8',
    'month 9',
    'month 10',
    'month 11',
    'month 12',
  ];

  final List<String> weeks = ['week 1', 'week 2', 'week 3', 'week 4'];

  Stream<QuerySnapshot<Map<String, dynamic>>> getStatisticsStream() {
    return FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc('KNaVj643zsMbYiFiW47Rqu7WNBX2')
        .collection(ModelYear.collection)
        .doc('1') // تأكد أن هذه الـ ID صحيحة
        .collection(ModelMonth.collection)
        .doc((1).toString().padLeft(2, '0')) // month dynamic
        .collection(ModelWeek.collection)
        .doc('week_1') // week dynamic
        .collection(ModelData.collection)
        .snapshots();
  }

  void updateMonthIndex(int index) {
    selectedMonthIndex = index;
    notifyListeners();
  }

  void updateWeekIndex(int index) {
    selectedWeekIndex = index;
    notifyListeners();
  }
  Stream<int> getStatisticsCircle(String select,) {
    return FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc('5u0qEXBm0eaW7J0n5Y8VhF5WdBD2')
        .collection(ModelYear.collection)
        .doc('1') // تأكد أن هذه الـ ID صحيحة
        .collection(ModelMonth.collection)
        .doc((1).toString().padLeft(2, '0')) // month dynamic
        .collection(ModelWeek.collection)
        .doc('week_1') // week dynamic
        .collection(ModelData.collection)
        .doc()
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return data != null && data.containsKey(select)
          ? data[select] as int
          : 4; // Default to 0 if 'score' is not available
    });
  }
  Stream<int> getStatisticsCircle2(
      String select,
      String weekId,
      String monthId,
      ) {
    return FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc('5u0qEXBm0eaW7J0n5Y8VhF5WdBD2')
        .collection(ModelYear.collection)
        .doc('1') // تأكد أن هذه الـ ID صحيحة
        .collection(ModelMonth.collection)
        .doc(monthId) // month dynamic
        .collection(ModelWeek.collection)
        .doc(weekId) // week dynamic
        .collection(ModelData.collection)
        .limit(1) // الحصول على أول مستند فقط
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        print("#############$data");
        return data != null && data.containsKey(select)
            ? data[select] as int
            : 0; // Default to 0 if 'select' is not found
      } else {
        return 0; // Default to 0 if no document exists
      }
    });
  }

  Future<int> getTotalScoreForYear(String userId, String year) async {
    int totalScore = 0;
    // حلقة عبر الأسابيع
    for(int j=1;j<=12;j++){
      String monthId="0$j";
      for (int i = 0; i < 4; i++) {
        String weekId = "week_${i + 1}";

        // جلب السكور لكل أسبوع
        final snapshot = await FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(userId)
            .collection(ModelYear.collection)
            .doc(year)
            .collection(ModelMonth.collection)
            .doc(monthId) // الشهر هنا هو العام لأنك لم تحدد الشهر بشكل منفصل
            .collection(ModelWeek.collection)
            .doc(weekId)
            .collection(ModelData.collection)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          final score = data != null && data.containsKey("score") ? data["score"] as int : 0;
          totalScore += score; // جمع السكور
        }}
    }
    FirebaseUtils.setTotalScore(userId: userId, yearId: year, totalScore: totalScore);
    // إرجاع السكور الإجمالي بعد جمعه
    return totalScore;
  }



}