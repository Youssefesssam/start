import 'package:flutter/material.dart';
import '../../../../../../utilites/appAssets.dart';
import '../setting/setting.dart';
class AppBarUser extends StatelessWidget {
  const AppBarUser({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(AppAssets.profile),
            ),
            const SizedBox(
              width: 7,
            ),
            const Column(
              children: [
                Text(
                  "Name",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                InkWell(onTap: (){},child: const Icon(Icons.qr_code_2_sharp,size: 35,)),
                const SizedBox(width: 5,),
                 InkWell(onTap:(){
                   Navigator.pushNamed(context, Setting.routeName);
                   },
                     child: Icon(Icons.settings,size: 35,)),
              ],
            )
          ],
        ),
      ],
    );
  }
}
