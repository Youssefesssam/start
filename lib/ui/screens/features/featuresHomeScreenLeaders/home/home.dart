import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  static const String routeName ="home";
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff2d2d44),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff2d2d44),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff2d2d44),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff2d2d44),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff2d2d44),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff2d2d44),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  color: const Color(0xff1a1a26),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  color: const Color(0xff1a1a26),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  color: const Color(0xff1a1a26),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff13131c),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff13131c),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff13131c),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff13131c),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff13131c),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: const Color(0xff13131c),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
