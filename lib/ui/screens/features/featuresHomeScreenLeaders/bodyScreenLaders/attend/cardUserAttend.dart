import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/dataProvider.dart';
import '../../../../../../model/modelUserAttend.dart';
import '../../../../../../utilites/appAssets.dart';


class CardUserAttend extends StatefulWidget {
  final User users;
   int score;
   int rank ;
   String image ;

  CardUserAttend({super.key, required this.users,required this.score,required this.rank,required this.image});

  @override
  _CardUserAttend createState() => _CardUserAttend();
}

class _CardUserAttend extends State<CardUserAttend> {


  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of<AuthProviders>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);

        return Container(
          margin: const EdgeInsets.only(left: 5,right: 5),
          padding: const EdgeInsets.only(left: 30, right: 25, top: 0, bottom: 0),
          height: MediaQuery.of(context).size.height * .1,
          width: MediaQuery.of(context).size.width * .9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors:[ Colors.deepPurple.shade800,
                Colors.blue,
                Colors.indigo.shade600,],
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
                    colors:[ Colors.deepPurple.shade800,
                      Colors.blue,
                      Colors.indigo.shade600,],
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
                child:CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.image != null && widget.image!.isNotEmpty
                      ? (widget.image!.startsWith('http') || widget.image!.startsWith('https')
                      ? NetworkImage(widget.image!) as ImageProvider
                      : AssetImage(widget.image!))
                      : const AssetImage(AppAssets.profile),
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
                      style: TextStyle(fontSize: 20, color: Colors.white)),
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
                  // عرض النقاط

                ],
              ),
              const Spacer(),
               Text(
                "${widget.rank}#",
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellow),
              ),
            ],
          ),
        );
  }
}


