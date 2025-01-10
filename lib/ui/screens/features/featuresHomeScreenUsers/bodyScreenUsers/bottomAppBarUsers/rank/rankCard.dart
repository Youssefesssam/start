import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/utilites/appAssets.dart';

class RankCard extends StatelessWidget {
  final String name;
  final int rank;
  final String profileImage;
  final int score;

  const RankCard({
    Key? key,
    required this.name,
    required this.rank,
    required this.profileImage,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على DataProvider باستخدام Provider
    DataProvider dataProvider = Provider.of<DataProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4), // الظل
          ),
        ],
      ),
      child: Row(
        children: [
          // عرض الترتيب
          Text(
            "$rank",
            style: const TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
          // عرض صورة الملف الشخصي
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(profileImage), // الصورة الشخصية
          ),
          const SizedBox(width: 20),
          // عرض الاسم والنقاط
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.adamina(
                    fontSize: 18, color: Colors.black),
              ),

              const SizedBox(height: 5),
              Text(
                "$score points",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          // عرض التاج بناءً على المركز
          Image.asset(
            AppAssets.crown,
            height: 50,
            width: 50,
            color: rank == 1
                ? null // لون ذهبي للمركز الأول
                : rank == 2
                ? Colors.grey // لون فضي للمركز الثاني
                : rank == 3
                ? Colors.brown // لون برونزي للمركز الثالث
                : Colors.transparent, // شفاف لبقية المراكز
          ),
        ],
      ),
    );
  }
}
