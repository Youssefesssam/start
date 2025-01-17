import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/ideas.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/opnion.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/team.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/week.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/word.dart';

class Home extends StatefulWidget {
  static const String routeName = "home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int selectedWeekIndex = 0;

  @override
  void initState() {
    super.initState();
    // تهيئة AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // تهيئة ScaleAnimation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // التخلص من الـ AnimationController
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal[800]!,
              Colors.grey[900]!,
              Colors.grey[900]!,
            ],
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
                            builder: (context) => Week(),
                          );

                          if (selectedIndex != null) {
                            setState(() {
                              selectedWeekIndex = selectedIndex +
                                  1; // +1 لأن الأسابيع تبدأ من 1
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 120,
                          width: 120,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$selectedWeekIndex',
                                style: GoogleFonts.aclonica(
                                  fontSize: 60,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "week",
                                style: GoogleFonts.aclonica(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                              builder: (context) => Ideas(),
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
                          child: buildOption("TALKEN", Icons.chat, () {
                            _onTap();
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
                          }),
                        ),
                        Flexible(
                          child: buildOption("Event", Icons.event, () {
                            _onTap();
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
                size: 40,
                color: Colors.teal,
              ),
              const SizedBox(height: 10),
              Text(
                optionName,
                style: GoogleFonts.aclonica(
                  fontSize: 18,
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
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.4, 0.6, 0.9],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
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
                    color: Colors.grey[400],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
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
