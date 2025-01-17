import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/ui/screens/homeScreen/settting.dart';
import '../../../firebase/dataProvider.dart';
import '../../../utilites/appAssets.dart';
import '../features/featuresHomeScreenLeaders/home/ideas.dart';
import '../features/featuresHomeScreenLeaders/home/opnion.dart';
import '../features/featuresHomeScreenLeaders/home/team.dart';
import '../features/featuresHomeScreenLeaders/home/week.dart';
import '../features/featuresHomeScreenLeaders/home/word.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/chartsDigram/charts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreenUsers extends StatefulWidget {
  HomeScreenUsers({super.key});

  static const String routeName = "homeScreenUsers";

  @override
  State<HomeScreenUsers> createState() => _HomeScreenUsersState();
}

class _HomeScreenUsersState extends State<HomeScreenUsers>
    with SingleTickerProviderStateMixin {
  String selectedMonth = '01';
  bool isRefreshing = false;
  final List<String> month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int selectedWeekIndex = 0;
  int _currentIndex = 0; // مؤشر الموضع الحالي

  @override
  void initState() {
    print('initState called'); // Debug statement
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

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true; // تفعيل حالة التحديث عند السحب لأسفل
    });

    // تنفيذ عملية التأخير (مثل تحميل البيانات)
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isRefreshing = false; // إيقاف التحديث بعد فترة
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pic = [
      _buildContentWidget("general"),
      _buildContentWidget("puplic"),
      _buildContentWidget("team"),
      _buildContentWidget("connection"),
    ];

    DataProvider dataProvider = Provider.of<DataProvider>(context);
    final isTablet = MediaQuery.of(context).size.width > 600; // تحديد إذا كان الجهاز تاب

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.metrics.pixels <= 0) {
              setState(() {
                isRefreshing = true;
              });
              Future.delayed(const Duration(seconds: 3), () {
                setState(() {
                  isRefreshing = false;
                });
              });
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // السماح بالسحب دائمًا
          child: Stack(
            children: [
              Column(
                children: [
                  if (isRefreshing)
                  // إظهار صورة عند السحب لأسفل
                    Center(
                      child: Container(
                          margin: const EdgeInsets.all(20),
                          height: 80,
                          width: 80,
                          child: const Icon(
                            Icons.refresh,
                            size: 50,
                          )),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal[900]!, Colors.grey[900]!],
                        begin: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: isTablet
                              ? MediaQuery.of(context).size.height * 0.3
                              : MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal[800]!, Colors.teal[800]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          height: isTablet
                              ? MediaQuery.of(context).size.height * 0.25
                              : MediaQuery.of(context).size.height * 0.31,
                        ),
                        Column(
                          children: [
                            // السلايدر
                            CarouselSlider(
                              items: pic,
                              options: CarouselOptions(
                                height: isTablet
                                    ? MediaQuery.of(context).size.height * 0.6
                                    : MediaQuery.of(context).size.height * 0.47,
                                viewportFraction: 1.0, // عرض العنصر بالكامل
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                autoPlay: false,
                                autoPlayInterval: const Duration(seconds: 2),
                                autoPlayAnimationDuration: const Duration(seconds: 2),
                                autoPlayCurve: Curves.easeInOut,
                                enlargeCenterPage: false, // تعطيل تكبير العنصر في المنتصف
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index; // تحديث الموضع الحالي
                                  });
                                },
                              ),
                            ),
                            // مسافة بين السلايدر والنقاط
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  pic.length, (index) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.only(bottom: 20, right: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Container(
                        margin: const EdgeInsets.only(top: 30, right: 20),
                        child: Charts(selectedmonth: selectedMonth)),
                  )),
              const Positioned(
                top: 30,
                left: 30,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(AppAssets.profile),
                ),
              ),
              Positioned(
                top: 40,
                left: 140,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Name",
                          style: GoogleFonts.aclonica(
                            fontSize: isTablet ? 24 : 20,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "User Bio or Description ",
                          style: GoogleFonts.aclonica(
                            fontSize: isTablet ? 16 : 12,
                            color: Colors.white70,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 25),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SettingUser.routeName);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 120,
                right: -5,
                child: Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 85,
                        child: CupertinoPicker(
                          itemExtent: 20,
                          scrollController:
                          FixedExtentScrollController(initialItem: 1),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedMonth =
                                  (index + 1).toString().padLeft(2, '0');
                            });
                          },
                          children: month.map((letter) {
                            return Center(
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 180,
                  right: -30,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.only(
                              right: 70, top: 10, left: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.teal[800]!,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, RankPage.routeName);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Rank#",
                                  style: GoogleFonts.aclonica(
                                    fontSize: isTablet ? 20 : 15,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  "#1",
                                  style: GoogleFonts.aclonica(
                                    fontSize: isTablet ? 40 : 30,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            right: 45, top: 10, left: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.teal[800]!,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Statistics.routeName);
                          },
                          child: Column(
                            children: [
                              Text(
                                "Statistics",
                                style: GoogleFonts.aclonica(
                                  fontSize: isTablet ? 20 : 15,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                value: 2.0,
                                // هنا وضعنا 0.0 في حالة انتظار الداتا
                                color: Colors.white,
                                backgroundColor: Colors.white54,
                                strokeWidth: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentWidget(String head) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 0, right: 10, bottom: 0),
            child: Text(
              head,
              style: GoogleFonts.aboreto(color: Colors.white, fontSize: 40),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: buildOption('IDeas', Icons.lightbulb_outline, () {
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
                        selectedWeekIndex = selectedIndex + 1; // +1 لأن الأسابيع تبدأ من 1
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 90,
                    width: 90,
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
                            fontSize: 50,
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
                    builder: (context) => _buildDraggableScrollableSheet(Team()),
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
    );
  }

  Widget buildOption(String optionName, IconData icon, VoidCallback onTap) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 85,
          width: 85,
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