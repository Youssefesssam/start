import 'package:flutter/material.dart';
import '../../../utilites/appAssets.dart';
import '../features/featuresHomeScreenUsers/appBarUser/appBarUsers/appBarUser.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/bottomAppBarUsers.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/chartScatter/chartScatter.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/slider/designCard/designCard.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/slider/slide.dart';
class HomeScreenUsers extends StatelessWidget {
  const HomeScreenUsers({super.key});

  static const String routeName = "homeScreenUsers";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.backGround), fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 30, bottom: 10),
                child: const AppBarUser()),


            const bottomAppBarUsers(),


            Container(
              margin: const EdgeInsets.only(top: 10, left: 30),
              child: Row(
                children: [
                  const Text(
                    "Range attendas",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20),
                  ),
                  Image.asset(AppAssets.rank,height: 30,width: 40,)
                ],

              ),
            ),




            const SizedBox(
              height: 10,
            ),
             Expanded(flex: 5, child: ChartScatter()),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 20, bottom: 20),
                    child: const Text(
                      "Contents",
                      style: TextStyle(fontSize: 25),
                    )),
                Container(
                    margin: const EdgeInsets.only(left: 5, bottom: 20),
                    child: Image.asset(AppAssets.content,height: 30,width: 40,))
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: MediaQuery.of(context).size.height * .13,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: DesignCard(
                        titleCard: "Score",
                        path:AppAssets.bestScore,
                        color: Colors.black,
                      )),
                  Expanded(
                      flex: 1,
                      child: DesignCard(
                          titleCard: "A Word", color: Colors.black,path: AppAssets.days,)),
                  Expanded(
                      flex: 1,
                      child: DesignCard(
                          path:AppAssets.giveAway,
                          titleCard: "Gift", color: Colors.black)),
                ],
              ),
            ),
            SliderPic(),
          ],
        ),
      ),
    );
  }
}