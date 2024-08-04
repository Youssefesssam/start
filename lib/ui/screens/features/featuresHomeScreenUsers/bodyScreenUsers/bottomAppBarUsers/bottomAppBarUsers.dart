import 'package:flutter/material.dart';

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
              elevation: 20,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  height: 90,
              margin: const EdgeInsets.symmetric(horizontal: 70),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),))),
               Container(
                margin: const EdgeInsets.symmetric(horizontal: 85),
                padding: const EdgeInsets.all(5),
                child: const Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "1#",
                          style: TextStyle(fontSize: 45),
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
        const Positioned(
          right: 110,
          top: 20,
          child: Column(
            children: [
              SizedBox(
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  value: 0.4,
                  color: Color(0xfffbb800),
                  backgroundColor: Colors.white54,
                  strokeWidth: 5,
                ),
              ),
              SizedBox(height: 15,),
              Text( "Attend",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
