import 'package:flutter/material.dart';

class cardStatistics extends StatelessWidget {
  final String title; // العنوان الرئيسي
  final int score; // النقاط
  final String subtitle; // العنوان الفرعي

  const cardStatistics({
    super.key,
    required this.title,
    required this.score,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.blueAccent],
              begin: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "$score", // عرض النقاط
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white, //Color(0xfffbb800),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle, // العنوان الفرعي
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(40),
                child: CircularProgressIndicator(
                  strokeAlign: 7,
                  strokeCap: StrokeCap.round,
                  value: score / 100, // قيمة النسبة (افتراضًا أن 100 هي الحد الأقصى)
                  color: const Color(0xfff9b700),
                  backgroundColor: const Color(0xff868181),
                  strokeWidth: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
