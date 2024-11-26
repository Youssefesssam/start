import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/ScreenHomeLeaders/menu.dart';
import 'cardUser.dart';

class ScreenHomeLeaders extends StatefulWidget {
  static const String routeName = "homeScreenLeaders";

  const ScreenHomeLeaders({super.key});

  @override
  State<ScreenHomeLeaders> createState() => _HomeScreenLeaders();
}

class _HomeScreenLeaders extends State<ScreenHomeLeaders> {
  int? selectedCardIndex; // لتحديد الكارد الذي تم النقر عليه
  List<int> cards = List.generate(5, (index) => index); // قائمة الكروت

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // الخلفية مع المحتوى الأساسي
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(cards[index].toString()), // مفتاح فريد لكل عنصر
                      direction: DismissDirection.endToStart, // اتجاه السحب
                      onDismissed: (direction) {
                        setState(() {
                          cards.removeAt(index); // حذف العنصر من القائمة
                          if (selectedCardIndex == index) {
                            selectedCardIndex = null;
                          }
                        });
                      },
                      background: Container(
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.black,Colors.black],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.delete, color: Colors.white, size: 30),
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedCardIndex == index) {
                              selectedCardIndex = null; // إغلاق القائمة إذا تم النقر على نفس الكارد
                            } else {
                              selectedCardIndex = index;
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          child: _buildCard(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // طبقة التمويه
          if (selectedCardIndex != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // إغلاق القائمة عند الضغط على التمويه
                  setState(() {
                    selectedCardIndex = null;
                  });
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          // الكارد والقائمة يظهران معًا عند البلور
          if (selectedCardIndex != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12, // موضع الكارد والقائمة
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCard(), // عرض الكارد الذي تم تحديده
                  const SizedBox(height: 20),
                  _buildMenu(), // عرض القائمة أسفل الكارد
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return const CardUser();
  }

  Widget _buildMenu() {
    return Menu(
      onCloseMenu: () {
        setState(() {
          selectedCardIndex = null; // إخفاء المنيو
        });
      },
    );
  }
}
