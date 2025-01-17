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
          margin: const EdgeInsets.only(left: 5,right: 5),
          padding: const EdgeInsets.only(left: 30, right: 25, top: 0, bottom: 0),
          height: MediaQuery.of(context).size.height * .11,
          width: MediaQuery.of(context).size.width * .9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.teal[800]!,
                Colors.teal[600]!,
                Colors.cyan[700]!,
                Colors.cyan[500]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // عرض صورة البروفايل
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal[800]!,
                      Colors.teal[600]!,
                      Colors.cyan[700]!,
                      Colors.cyan[500]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(AppAssets.profile),
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


