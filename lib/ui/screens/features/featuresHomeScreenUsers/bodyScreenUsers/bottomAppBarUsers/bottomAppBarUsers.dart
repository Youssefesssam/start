import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';

class bottomAppBarUsers extends StatelessWidget {
  const bottomAppBarUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Opacity(
            opacity: .3,
            child: Card(
                color: Colors.grey,
                elevation: 30,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  height: 90,
              margin: const EdgeInsets.symmetric(horizontal: 70),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),))),
               Container(
                margin: const EdgeInsets.symmetric(horizontal: 85),
                padding: const EdgeInsets.all(5),
                child: const Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "1#",
                          style: TextStyle(fontSize: 45,color: Colors.orange),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Rank#"),
                      ],
                    ),
                  ],
                ),
              ),
         Positioned(
          right: 110,
          top: 20,
          child: Column(
            children: [
              SizedBox(
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Statistics.routeName);
                  },
                  child: const CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    value: 0.4,
                    color: Colors.orange,
                    backgroundColor: Colors.white54,
                    strokeWidth: 4,
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text( "Statistics",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
