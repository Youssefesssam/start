import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/dataProvider.dart';
import '../../../../../model/modelUser.dart';
import '../../../../../utilites/appAssets.dart';

class CardUser extends StatefulWidget {
  final MyUser users;
   int score;
   int rank ;
  final String userId; // إضافة الـ userId هنا

  CardUser({super.key, required this.users, required this.userId,required this.score,required this.rank});

  @override
  _CardUserState createState() => _CardUserState();
}

class _CardUserState extends State<CardUser> {
  @override
  void initState() {
    super.initState();
    // استدعاء دالة جلب البيانات عند بداية التحميل
    if (widget.userId.isNotEmpty) {
      Provider.of<DataProvider>(context, listen: false).getDataFromFirebase(widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of<AuthProviders>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);

        return Container(
          padding: const EdgeInsets.only(left: 30, right: 25, top: 0, bottom: 0),
          height: MediaQuery.of(context).size.height * .11,
          width: MediaQuery.of(context).size.width * .9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [Colors.deepOrange,Colors.pink,Colors.purple,Colors.indigo,Colors.blue],
              end: Alignment(1, 2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // عرض صورة البروفايل
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                      colors: [Colors.deepOrange,Colors.pink,Colors.pinkAccent,Colors.purple],
                      end: Alignment(1, 2)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                        colors: [Colors.deepOrange,Colors.pink,Colors.pinkAccent,Colors.purple]),
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(AppAssets.profile),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${widget.users.name}",
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                  Row(
                    children: [
                      Text("${widget.score}", style: TextStyle(color: Colors.white)),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.sports_score_sharp,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("${widget.users.gender}",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.transgender,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  // عرض النقاط

                ],
              ),
              const Spacer(),
               Text(
                "Rank ${widget.rank}#",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow),
              ),
            ],
          ),
        );
  }
}


