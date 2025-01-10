import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/authProvider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/appBarUser/appBarUsers/appBarUser.dart';
import '../../../../../../model/modelData.dart';
import '../../../../../../model/modelMonth.dart';
import '../../../../../../model/modelUser.dart';
import '../../../../../../model/modelYear.dart';
import '../../../../../../model/modelweek.dart';
import 'cardStatistics.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  static const String routeName = "statistics";

  @override
  State<Statistics> createState() => _StatisticsState();
}


class _StatisticsState extends State<Statistics> {
  final List<String> month = [
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
  final List<String> week = ['week 1', 'week 2', 'week 3', 'week 4'];
  int selectedMonthIndex = 0;
  int selectedWeekIndex = 0;
  List<String> score = [
    'score',
    'meetingScore',
    'communionScore',
    'confessionScore',
    'massScore',
  ];

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of(context);
    AuthProviders authProviders = Provider.of(context);
    var collectionReference = FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc('5u0qEXBm0eaW7J0n5Y8VhF5WdBD2')
        .collection(ModelYear.collection)
        .doc('1') // تأكد أن هذه الـ ID صحيحة
        .collection(ModelMonth.collection)
        .doc((selectedMonthIndex + 1).toString().padLeft(2, '0')) // month dynamic
        .collection(ModelWeek.collection)
        .doc('week_${selectedWeekIndex + 1}') // week dynamic
        .collection(ModelData.collection);

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50,bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150, // ارتفاع الـ Picker
                    child: CupertinoPicker(
                      itemExtent: 50, // ارتفاع كل عنصر
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedMonthIndex),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonthIndex = index; // تحديث الشهر المختار
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
                    height: 150, // ارتفاع الـ Picker
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
                    child: CircularProgressIndicator(), // عرض اللودر
                  );
                }
                if (!streamSnapshot.hasData ||
                    streamSnapshot.data?.docs.isEmpty == true) {
                  return  const SingleChildScrollView(
                    child: Column(
                      children: [
                        cardStatistics(
                          mod: 100,
                          title: 'score', // Displaying field name dynamically
                          score: 0, // Safeguard missing values
                          subtitle: '', // Adjust subtitle as needed
                        ),
                        cardStatistics(
                          mod: 100,
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
