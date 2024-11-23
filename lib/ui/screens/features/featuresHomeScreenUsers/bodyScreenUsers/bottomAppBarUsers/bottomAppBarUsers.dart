import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';

class bottomAppBarUsers extends StatelessWidget {
  const bottomAppBarUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

margin: EdgeInsets.only(left:40 ,right: 40),
      child: Card(
        color: Color(0x84dedede),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "1#",
                        style: TextStyle(fontSize: 50, color: Colors.orange),
                      ),

                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 40, // Adjust the width as needed
                        height: 40, // Adjust the height as needed
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Statistics.routeName);
                          },
                          child: const CircularProgressIndicator(
                            strokeCap: StrokeCap.round,
                            value: 0.6,
                            color: Colors.orange,
                            backgroundColor: Colors.white54,
                            strokeWidth: 6,
                          ),
                        ),
                      ),

                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 20,bottom: 10,),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Rank#"),

                    Text(
                      "Statistics",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
