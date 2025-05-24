import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:star_t/firebase/authProvider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';

// Screens
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/week.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/opnion.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/absent/absent.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/event.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/sweetTalk.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/word.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/team.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/task.dart';

// User Features
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/general/idea/ideasUser.dart';

// Utilities
import 'package:star_t/utilites/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart'; // Lottie for background animation

class Home extends StatefulWidget {
  static const String routeName = "home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int? lastSelectedWeek;
  bool _isFirstRun = true;

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
    FireBaseGetDataForLeader.saveDateInProvider(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstRun) {
      FireBaseGetDataForLeader.saveDateInProvider(context);
      _isFirstRun = false;
    }
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

  void _showCustomBottomSheet(Widget widget) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية فضائية باستخدام Lottie


          // تدرج لوني خفيف فوق الخلفية
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo.withOpacity(0.4),
                  Colors.blueGrey.withOpacity(0.4),
                  Colors.blue.withOpacity(0.4),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // المحتوى الرئيسي
          Stack(
            children: [
              Positioned(
                top: 50,
                left: 20,
                child: Text(
                  "GOOD Timing",
                  style: GoogleFonts.aclonica(
                    color: Colors.white,
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
                              builder: (context) =>
                                  Week(currentSelectedWeek: lastSelectedWeek ?? 1),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(30),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade800,
                                  Colors.blue,
                                  Colors.indigo.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: FireBaseGetDataForLeader.currentWeek(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return _buildWeekDisplay(lastSelectedWeek ?? 0);
                                }
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return _buildWeekDisplay(lastSelectedWeek ?? 0);
                                }
                                final weekNumber =
                                snapshot.data!['weekNumber'] as int;
                                lastSelectedWeek = weekNumber;
                                dataProvider.currentWeekNum = weekNumber;
                                return _buildWeekDisplay(weekNumber);
                              },
                            ),
                          ),
                        ),
                      ),
                      _buildRowOptions(),
                      _buildSecondRowOptions(),
                      _buildThirdRowOptions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDisplay(int weekNumber) {
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
  }

  Widget _buildOption(String optionName, IconData icon, Color colorIcon,
      VoidCallback onTap, Gradient gradient) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
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
                color: colorIcon,
              ),
              const SizedBox(height: 10),
              Text(
                optionName,
                style: GoogleFonts.abyssinicaSil(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: _buildOption('IDeas', Icons.lightbulb_outline, Colors.blue,
                  () {
                _onTap();
                _showCustomBottomSheet(IdeasUser());
              }, const LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        ),
        Flexible(
          child: _buildOption('Opinion', Icons.comment, Colors.blue, () {
            _onTap();
            _showCustomBottomSheet(Opinion());
          }, const LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
        Flexible(
          child: _buildOption("Team", Icons.group, Colors.blue, () {
            _onTap();
            Navigator.pushNamed(context, Team.routeName);
          }, const LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ],
    );
  }

  Widget _buildSecondRowOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: _buildOption("Sweet", Icons.favorite_border, Colors.blue,
                  () {
                _onTap();
                _showCustomBottomSheet(SweetTalk());
              }, const LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        ),
        Flexible(
          child: _buildOption("Word", Icons.text_fields, Colors.blue, () {
            _onTap();
            _showCustomBottomSheet(Word());
          },  LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
        Flexible(
          child: _buildOption('Absent', Icons.notification_important_sharp,
              Colors.blue, () {
                _onTap();
                _showCustomBottomSheet(Absent());
              }, const LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        ),
      ],
    );
  }

  Widget _buildThirdRowOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: _buildOption("Task", Icons.assignment, Colors.blue, () {
            _onTap();
            _showCustomBottomSheet(Task());
          }, const LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
        Flexible(
          child: _buildOption("Event", Icons.event, Colors.blue, () {
            _onTap();
            _showCustomBottomSheet(Event());
          }, const LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ],
    );
  }
}