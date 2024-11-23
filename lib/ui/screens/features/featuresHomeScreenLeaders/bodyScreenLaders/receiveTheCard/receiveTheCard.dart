import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../utilites/appAssets.dart';

class ReceiveTheCard extends StatefulWidget {
    ReceiveTheCard({super.key});

  @override
  State<ReceiveTheCard> createState() => _ReceiveTheCardState();
}

class _ReceiveTheCardState extends State<ReceiveTheCard> {


  @override
  Widget build(BuildContext context) {
    return buildContainer(context);
  }

  Container buildContainer(BuildContext context) {

    return Container(

      padding: const EdgeInsets.only(left: 30, right: 25, top: 0,bottom: 0),
      height: MediaQuery.of(context).size.height * .11,
      width: MediaQuery.of(context).size.width * .8,
      decoration:
          BoxDecoration(
            borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                  colors: [Colors.deepOrangeAccent,Colors.purple],end:Alignment(1, 2)  ),
          ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration:
            BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                  colors: [Colors.deepOrangeAccent,Colors.purple],end:Alignment(1, 2)  ),
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration:
              BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(
                      colors: [Colors.purple,Colors.deepOrangeAccent])
              ),

              child: const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(AppAssets.profile),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Youssef",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white
                  )),

              Row(
                children: [
                  Text("Score",style: TextStyle(color: Colors.white),),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.sports_score_sharp,
                    size: 16,color: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Rank",style: TextStyle(
                    fontSize: 14,color: Colors.white
                  )),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.leaderboard_outlined,
                    size: 16,color: Colors.white,
                  ),
                ],
              ),


            ],
          ),
          const Spacer(),
          const Text(
            "Done",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
