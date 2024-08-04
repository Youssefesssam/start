import 'package:flutter/material.dart';
import '../../../../../../../utilites/appAssets.dart';
import '../bodyScreenLaders/receiveTheCard/receiveTheCard.dart';
class ScreenHomeLeaders extends StatefulWidget {
  static const String routeName = "homeScreenLeaders";

  @override
  State<ScreenHomeLeaders> createState() => _HomeScreenLeaders();
}

class _HomeScreenLeaders extends State<ScreenHomeLeaders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backGround),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.all(15),
                          child: const ReceiveTheCard());
                    })),
          ],
        ),
      ),
    );
  }
}
