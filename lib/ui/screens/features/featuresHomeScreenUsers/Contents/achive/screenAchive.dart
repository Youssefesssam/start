import 'package:flutter/material.dart';

class ScreenAchive extends StatelessWidget {
  static const String routeName ="screenAchive";
  const ScreenAchive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.red,
          width: 70,
          height: 70,
          ),
          Container(
            color: Colors.red,
            width: 70,
            height: 70,
          ),
          Container(
            color: Colors.red,
            width: 70,
            height: 70,
          ),
          Container(
            color: Colors.red,
            width: 70,
            height: 70,
          ),
        ],
      ),
    );
  }
}
