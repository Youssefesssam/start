import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/authProvider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import '../../../../../../model/modelData.dart';
import '../../../../../../model/modelMonth.dart';
import '../../../../../../model/modelUser.dart';
import '../../../../../../model/modelYear.dart';
import '../../../../../../model/modelweek.dart';
import '../../../../../../utilites/appColors.dart';
import 'cardStatistics.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  static const String routeName = "statistics";

  @override
  State<Statistics> createState() => _StatisticsState();
}


class _StatisticsState extends State<Statistics> {
  final List<String> month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> week = ['week 1', 'week 2', 'week 3', 'week 4'];
  int selectedMonthIndex = 0;
  int selectedWeekIndex = 0;
  List<String> score = [
    'score',
    'meetingScoreDB',
    'communionScoreDB',
    'confessionScoreDB',
    'massScoreDB',
  ];

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of(context);
    AuthProviders authProviders = Provider.of(context);
    var collectionReference = FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc(authProviders.userId)
        .collection(ModelYear.collection)
        .doc('1') // تأكد أن هذه الـ ID صحيحة
        .collection(ModelMonth.collection)
        .doc((selectedMonthIndex + 1).toString().padLeft(2, '0')) // month dynamic
        .collection(ModelWeek.collection)
        .doc(selectedWeekIndex.toString()) // week dynamic
        .collection(ModelData.dataCollection);

    return   Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.backGround,
          begin: Alignment.bottomCenter,
        ),
      ),
      child:  Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50,bottom: 20,right: 50,left: 50),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 120, // ارتفاع الـ Picker
                    child: CupertinoPicker(
                      itemExtent: 50, // ارتفاع كل عنصر
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedMonthIndex),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonthIndex = index;
                        });
                      },
                      children: month.map((letter) {
                        return Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 120, // ارتفاع الـ Picker
                    child: CupertinoPicker(
                      itemExtent: 50, // ارتفاع كل عنصر
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedWeekIndex),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedWeekIndex = index; // تحديث الأسبوع المختار
                        });
                      },
                      children: week.map((letter) {
                        return Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: collectionReference.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white,), // عرض اللودر
                  );
                }
                if (!streamSnapshot.hasData ||
                    streamSnapshot.data?.docs.isEmpty == true) {
                  return   const SingleChildScrollView(
                    child: Column(
                      children: [

                        cardStatistics(
                          mod: 100,
                          title: 'score', // Displaying field name dynamically
                          score: 0, // Safeguard missing values
                          subtitle: '', // Adjust subtitle as needed
                        ),
                        cardStatistics(
                          mod:100,
                          title: 'meetingScore', // Displaying field name dynamically
                          score: 0, // Safeguard missing values
                          subtitle: '', // Adjust subtitle as needed
                        ),
                        cardStatistics(
                          mod: 100,
                          title: 'communionScore', // Displaying field name dynamically
                          score: 0, // Safeguard missing values
                          subtitle: '', // Adjust subtitle as needed
                        ),
                        cardStatistics(
                          mod: 100,
                          title: 'confessionScore', // Displaying field name dynamically
                          score: 0, // Safeguard missing values
                          subtitle: '', // Adjust subtitle as needed
                        ),
                        cardStatistics(
                          mod: 100,
                          title: 'massScore', // Displaying field name dynamically
                          score: 0, // Safeguard missing values
                          subtitle: '', // Adjust subtitle as needed
                        ),

                      ],
                    ),
                  );
                }
                final docs = streamSnapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  // Dynamically adjust based on Firestore documents
                  itemBuilder: (BuildContext context, int index) {
                    final docSnapshot = docs[index];
                    return Column(
                      children: score.map((field) {
                        return cardStatistics(
                          mod: 100,
                          title: field.replaceAll('Score', ''),
                          // Displaying field name dynamically
                          score: docSnapshot[field] ?? 0,
                          // Safeguard missing values
                          subtitle: '', // Adjust subtitle as needed
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}