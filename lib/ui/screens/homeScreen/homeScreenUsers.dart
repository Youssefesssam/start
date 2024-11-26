import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/chartsDigram/charts.dart';
import '../../../utilites/appAssets.dart';
import '../features/featuresHomeScreenUsers/Contents/achive/achive.dart';
import '../features/featuresHomeScreenUsers/Contents/aword.dart';
import '../features/featuresHomeScreenUsers/Contents/gift.dart';
import '../features/featuresHomeScreenUsers/Contents/score.dart';
import '../features/featuresHomeScreenUsers/appBarUser/appBarUsers/appBarUser.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/bottomAppBarUsers.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/slider/slide.dart';

class HomeScreenUsers extends StatelessWidget {
  const HomeScreenUsers({super.key});

  static const String routeName = "homeScreenUsers";

  @override
  Widget build(BuildContext context) {
    final tab = MediaQuery.of(context).size.width >= 600;
    final phone = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(

          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white],
                      begin: Alignment.bottomCenter)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 30, top: 30, bottom: 10),
                      child: const AppBarUser()),
                  const bottomAppBarUsers(),
                  Container(

                    margin: const EdgeInsets.only(top: 10, left: 20),
                    child: Row(
                      children: [
                        const Text(
                          "General level",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          AppAssets.rank,
                          height: 30,
                          width: 40,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  phone ? Container(margin:EdgeInsets.only(left: 20,right: 20),height: 200, child: Charts()) : Charts(),
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 20),
                          child: const Text(
                            "Content",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 5, bottom: 20),
                          child: Image.asset(
                            AppAssets.content,
                            height: 30,
                            width: 40,
                            color: Colors.orange,
                          )),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: MediaQuery.of(context).size.height * .14,
                    child: Container(
                      margin: EdgeInsets.only(left: 30),
                      child:
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Achive(
                                  color: Colors.black,
                                  path: AppAssets.achivement,
                                  titleCard: "Achive",
                                  numNatification: 8,
                                  colorNatification: Colors.orange,
                                  appearNatification: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Aword(
                                  color: Colors.black,
                                  path: AppAssets.speech,
                                  titleCard: "Weekly word",
                                  numNatification: 8,
                                  colorNatification: Colors.orange,
                                  appearNatification: true,
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 17,right: 30,top: 15,bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Score(
                            color: Colors.black,
                            path: AppAssets.bestScore,
                            titleCard: "Score",
                            numNatification: 3,
                            colorNatification: Colors.orange,
                            appearNatification: false,
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Gift(
                            color: Colors.black,
                            path: AppAssets.giftCard,
                            titleCard: "Gift",
                            numNatification: 1,
                            colorNatification: Colors.orange,
                            appearNatification: true,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: const Text(
                            "General Content",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Image.asset(
                            AppAssets.content,
                            height: 30,
                            width: 40,
                            color: Colors.orange,
                          )),
                    ],
                  ),
                  SliderPic(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
