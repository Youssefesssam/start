import 'package:flutter/material.dart';

import '../../../../../../model/modelData.dart';
import '../../../../../../firebase/firebase.dart';

class Setting extends StatefulWidget {
  static const String routeName="setting";
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();

}

class _SettingState extends State<Setting> {
   int count=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 40)),
                fixedSize: MaterialStateProperty.all(Size(250, 250)),
                backgroundColor: MaterialStateColor.resolveWith((states) => Color(0xffefc900)),
              ),
              onPressed: () {
                setState(() {
                  count++;
                });
              },
              child: Text("count $count"),
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.orange)),
              onPressed: () {
                setState(() {
                  count = count+100;
                });
              },
              child: Text("100"),
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
              onPressed: () {
                setState(() {
                  count = 0;
                });
              },
              child: Text("Reset"),
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green)),
              onPressed: () {
               // counter(count);
                setState(() {});
              },
              child: Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}



