import 'package:flutter/material.dart';

import '../../../../../../utilites/appAssets.dart';
import '../chartScatter/chartScatter.dart';
import 'cardStatistics.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});
static const String routeName ="statistics";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: const BoxDecoration(
           gradient: LinearGradient(colors: [Colors.black,Colors.black],begin: Alignment.topLeft)
        ),
        child:Column(
          children: [
            SizedBox(height: 20,),
            Text("data",style: TextStyle(fontSize: 30,),),
            cardStatistics(),
            cardStatistics(),
            cardStatistics(),
            cardStatistics(),
          ],
        ),
      ) ,
    );
  }
}
