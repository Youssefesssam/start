import 'package:flutter/material.dart';
import 'package:star_t/utilites/appColors.dart';

class cardStatistics extends StatelessWidget {
  final String title;
  final int score;
  final String subtitle;
  final int mod;

  const cardStatistics({
    super.key,
    required this.title,
    required this.score,
    required this.subtitle,
    required this.mod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(

          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 10, left: 15, right: 20,top: 10),
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.appBarColor,
                end: Alignment(1, 2),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${title}: ",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "$score", // عرض النقاط
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white, //Color(0xfffbb800),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  strokeAlign: 3,
                  strokeCap: StrokeCap.round,
                  value: score / mod,
                  color: const Color(0xfff9b700),
                  backgroundColor: const Color(0xff868181),
                  strokeWidth: 7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
