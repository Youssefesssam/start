import 'package:flutter/material.dart';

import '../../../../../../utilites/appAssets.dart';
class AttendManual extends StatelessWidget {
  const AttendManual({super.key});

  static const String routeName = "attendManul";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.all(20),
                child: Container(
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
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
                               Icon(Icons.check_box_outline_blank_outlined,size: 30,)
                              ],
                            ),
                          ),
                        ])
                )
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){

              },
              child: Container(
                color: Colors.red,
                height: 50,
                width: 50,
              ),
            )
          ],
        )
    );
  }
}
