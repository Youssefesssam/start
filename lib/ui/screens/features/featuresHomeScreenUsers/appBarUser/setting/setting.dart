import 'package:flutter/material.dart';

import '../../../../../../firebase/ModelInfoUser.dart';
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
                counter(count);
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


  void counter(int count) {
    print("start add data");
    ModelInfoUser modelInfoUser = ModelInfoUser(count: count);
    print("data is send ${modelInfoUser.toJson()}");

    FirebaseUtils.addData(modelInfoUser);
  }


