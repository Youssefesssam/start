import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/opnion.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/sweetTalk.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/task.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/team.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/week.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/word.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/general/eventUser.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/general/ideasUser.dart';
import 'package:star_t/utilites/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../model/modelSweetTalk.dart';
import 'event.dart';

class Home extends StatefulWidget {
  static const String routeName = "home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int? lastSelectedWeek; // متغير لحفظ آخر قيمة

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }



  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backGround,
            begin: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                "GOOD Timing",
                style: GoogleFonts.aclonica(
                  color: Colors.teal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: InkWell(
                        onTap: () async {
                          final selectedIndex = await showModalBottomSheet<int>(
                            isScrollControlled: true,
                            isDismissible: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => Week(currentSelectedWeek: lastSelectedWeek!,),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          height: 120,
                          width: 120,
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
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseUtils.currentWeek(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // عرض آخر قيمة تم اختيارها
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${lastSelectedWeek ?? 0}",
                                      // إذا lastSelectedWeek == null، نعرض 0
                                      style: GoogleFonts.abyssinicaSil(
                                        fontSize: 50,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Week",
                                      style: GoogleFonts.abyssinicaSil(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${lastSelectedWeek ?? 0}",
                                      // إذا lastSelectedWeek == null، نعرض 0
                                      style: GoogleFonts.abyssinicaSil(
                                        fontSize: 50,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Week",
                                      style: GoogleFonts.abyssinicaSil(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              final weekNumber =
                              snapshot.data!['weekNumber'] as int;
                              lastSelectedWeek =
                                  weekNumber; // حفظ القيمة الجديدة
                              dataProvider.currentWeekNum = weekNumber;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$weekNumber",
                                    style: GoogleFonts.aclonica(
                                      fontSize: 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Week",
                                    style: GoogleFonts.abyssinicaSil(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child:
                          buildOption('IDeas', Icons.lightbulb_outline, () {
                            _onTap();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => IdeasUser(),
                            );
                          }),
                        ),
                        Flexible(
                          child: buildOption('Opinion', Icons.comment, () {
                            _onTap();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Opinion(),
                              ),
                            );
                          }),
                        ),
                        Flexible(
                          child: buildOption('Special', Icons.star, () {
                            _onTap();
                          }),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: buildOption(" SweetTalk", Icons.favorite_border, () {
                            _onTap();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: SweetTalk(),
                              ),
                            );
                          }),
                        ),
                        Flexible(
                          child: buildOption("Word", Icons.text_fields, () {
                            _onTap();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Word(),
                              ),
                            );
                          }),
                        ),
                        Flexible(
                          child: buildOption("Team", Icons.group, () {
                            _onTap();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) =>
                                  _buildDraggableScrollableSheet(Team()),
                            );
                          }),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: buildOption("Task", Icons.assignment, () {
                            _onTap();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Task(),
                              ),
                            );
                          }),
                        ),
                        Flexible(
                          child: buildOption("Event", Icons.event, () {
                            _onTap();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Event(),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(String optionName, IconData icon, VoidCallback onTap) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Color(0xfffcfcfc),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: MediaQuery.of(context).size.width * 0.08,
                color: Colors.teal,
              ),
              const SizedBox(height: 10),
              Text(
                optionName,
                style: GoogleFonts.abyssinicaSil(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  DraggableScrollableSheet _buildDraggableScrollableSheet(Widget nameWidget) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.4, 0.6, 0.9],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.lightgrey,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                ),
                nameWidget,

              ],
            ),
          ),
        );
      },
    );
  }
}