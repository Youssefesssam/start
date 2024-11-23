import 'package:flutter/material.dart';

class cardStatistics extends StatelessWidget {
  const cardStatistics({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [ Colors.deepOrangeAccent,Colors.blueAccent,],
                  begin: Alignment.bottomCenter),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              const Column(
                children: [
                  Text(
                    "Move",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "1/80",
                    style: TextStyle(
                      fontSize: 30,
                      color:Colors.white, //Color(0xfffbb800),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "steps",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "125",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xffe5d9d9),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(40),
                child: const CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  value: 0.4,
                  color: Color(0xfff9b700),
                  backgroundColor: Color(0xff868181),
                  strokeWidth: 18,
                  strokeAlign: 3,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
