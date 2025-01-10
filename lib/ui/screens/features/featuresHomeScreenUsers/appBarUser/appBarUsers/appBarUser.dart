import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/homeScreen/settting.dart';
import '../../../../../../utilites/appAssets.dart';
import '../setting/setting.dart';
class AppBarUser extends StatelessWidget {
  const AppBarUser({super.key});

  @override
  Widget build(BuildContext context) {
    return   Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ Colors.brown,Colors.brown],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Row(
          children: [

            SizedBox(width: 120,height:120,),

            Spacer(),

          ],
        ),
      ),
    );

  }
}
