import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_t/firebase/firebase.dart';
import '../../../../../../firebase/ModelInfoUser.dart';
import '../../appBarUser/appBarUsers/appBarUser.dart';
import 'cardStatistics.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});
  static const String routeName = "statistics";

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Map<String, dynamic> scores = {}; // بيانات الإحصائيات

  @override
  void initState() {
    super.initState();
    loadStatistics(); // استدعاء تحميل البيانات
  }

  Future<void> loadStatistics() async {
    var data = await FirebaseUtils.getStatistics(); // استدعاء الدالة الجديدة
    setState(() {
      scores = data; // تحديث البيانات في المتغير
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child:  AppBarUser()),
            const SizedBox(height: 10),
            // تمرير البيانات لكل كارد بشكل ديناميكي
            cardStatistics(
              title: "Mass",
              score: scores['massScore'] ?? 0,
              subtitle: "القداس",
            ),
            cardStatistics(
              title: "Communion",
              score: scores['communionScore'] ?? 0,
              subtitle: "التناول",
            ),
            cardStatistics(
              title: "Confession",
              score: scores['confessionScore'] ?? 0,
              subtitle: "الاعتراف",
            ),
            cardStatistics(
              title: "Meeting",
              score: scores['meetingScore'] ?? 0,
              subtitle: "الاجتماع",
            ),
          ],
        ),
      ),
    );
  }

}
