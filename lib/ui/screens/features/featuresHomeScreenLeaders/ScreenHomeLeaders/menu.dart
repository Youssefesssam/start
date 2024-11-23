import 'package:flutter/material.dart';
import 'package:star_t/firebase/ModelInfoUser.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/score.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});


  @override
  Widget build(BuildContext context) {
    int mass;
    int communion;
    int meeting;
    int confession;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xe42f2e2e),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  "القداس",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              const Spacer(),
              InkWell(
                  onTap: (){
                    mass=20;
                  },
                  child: const Icon(
                Icons.check_box_outline_blank_outlined,
                color: Colors.white,
                size: 35,
              )),
            ],
          ),
          const Divider(thickness: 1, color: Colors.white),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: const Text("التناول",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ),
              const Spacer(),
              Text("+25",style: TextStyle(color: Colors.green,fontSize: 20),),
              SizedBox(width: 10,),
              InkWell(
                  onTap: (){
                    communion=25;
                  },
                  child: const Icon(Icons.check_box_outline_blank_outlined,
                      color: Colors.white, size: 35)),
            ],
          ),
          const Divider(thickness: 1, color: Colors.white),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text("الاعتراف",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ),
              const Spacer(),
              InkWell(
                  onTap: (){
                    confession=25;
                  },
                  child: const Icon(Icons.check_box_outline_blank_outlined,
                      color: Colors.white, size: 35)),
            ],
          ),
          const Divider(thickness: 1, color: Colors.white),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text("الاجتماع",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ),
              const Spacer(),
              InkWell(
                onTap: (){
                  meeting=25;
                },
                  child: const Icon(Icons.check_box_outline_blank_outlined,
                      color: Colors.white, size: 35)),
            ],
          ),
          const Divider(thickness: 1, color: Colors.white),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text("حذف",
                    style: TextStyle(fontSize: 25, color: Colors.red)),
              ),
              const Spacer(),
              InkWell(
                  onTap: (){},
                  child: const Icon(Icons.delete, color: Colors.red, size: 35)),
            ],
          ),
        ],
      ),
    );
  }
  void addAtrbuteForScore( int ma,int me,int com,int con){
ModelInfoUser(count:  8);
  }
}
