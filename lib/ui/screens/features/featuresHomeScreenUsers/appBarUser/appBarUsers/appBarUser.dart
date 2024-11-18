import 'package:flutter/material.dart';
import '../../../../../../utilites/appAssets.dart';
import '../setting/setting.dart';
class AppBarUser extends StatelessWidget {
  const AppBarUser({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(AppAssets.profile),
              ),
              const SizedBox(
                width: 15,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "youssef essam",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.orange),
                  ),
                  SizedBox(
                      height: 5,),
                  Text(
                    "@youssef",
                    style: TextStyle(fontSize: 10,color: Color(0xc0fa9506)),
                  ),
                  Text(
                    "suze.EG",
                    style: TextStyle(fontSize: 10,color: Color(0xc0fa9506)),
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
      ),
    );
  }
}
