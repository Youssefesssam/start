import 'package:flutter/material.dart';

class Achive extends StatelessWidget {
  const Achive({super.key});
  static const String routeName = "achive";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(color: Colors.cyan,height: 150,))
            ],
          )
        ],
      ),);
  }
}
