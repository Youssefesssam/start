import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/ScreenHomeLeaders/screenHomeLeaders.dart';

class AppBarLaeders extends StatelessWidget {
  const AppBarLaeders({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
        children:[
          Container(
            margin: const EdgeInsets.only(top: 10, left: 0, bottom: 10),
            width: MediaQuery.of(context).size.width * .75,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border:
              Border.all(width: 3, color: const Color(0xFFD91B69)),
            ),
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, ScreenHomeLeaders.routeName);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(left: 30, top: 4, bottom: 4,right: 10),
                      child:const Icon(Icons.search,color: Color(0xfff86a45),size: 40,)),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: const Text(
                        "What do you search for...?",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 20,top: 10,bottom: 5),
            child: const Column(
              children: [
                Icon(Icons.qr_code_scanner_outlined,size: 30,color:Color(0xfff86a45)),
                SizedBox(width:10,),
                Text("Qr code",style: TextStyle(fontSize: 12),),
              ],
            ),
          ),]
    );
  }
}
