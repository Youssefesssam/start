import 'package:flutter/material.dart';

import '../../../../../../utilites/appAssets.dart';
class ReceiveTheCard extends StatelessWidget {
  const ReceiveTheCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  buildContainer(context);
  }

  Container buildContainer(BuildContext context) {
    return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Stack(
      alignment: Alignment.topLeft,
      children: [
        Opacity(
          opacity: .4,
          child: Card(
            color: Colors.transparent,
            elevation: 20,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .1,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          height: MediaQuery
              .of(context)
              .size
              .height * .1,
          width: MediaQuery
              .of(context)
              .size
              .width * .8,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(AppAssets.profile),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Text("Youssef",
                      style: TextStyle(
                        fontSize: 25,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Time"),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.access_time_sharp,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Text(
                "Done",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }
}
