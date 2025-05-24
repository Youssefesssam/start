import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utilites/appColors.dart';

class CardAbsent extends StatelessWidget {
  int validAbsentWeeks;
  CardAbsent({required this.validAbsentWeeks});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 30, right: 25, top: 0, bottom: 0),
        height: MediaQuery.of(context).size.height * .075,
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: AppColors.smoothColorTeal,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width:2 ,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,

            ),
          ),
          const SizedBox(width: 10),
          Text("Absent in  Week $validAbsentWeeks ",style: GoogleFonts.abhayaLibre(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
        ]));
  }
}