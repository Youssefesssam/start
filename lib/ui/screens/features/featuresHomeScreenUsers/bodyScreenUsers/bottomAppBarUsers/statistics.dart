import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/appBarUser/appBarUsers/appBarUser.dart';

import 'cardStatistics.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});
static const String routeName ="statistics";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child:  Column(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 30,right: 30,top: 30),
                child: const AppBarUser()),
            const SizedBox(height: 10,),
            const cardStatistics(),
            const cardStatistics(),
            const cardStatistics(),
            const cardStatistics(),
          ],
        ),
      ) ,
    );
  }
}
