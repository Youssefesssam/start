import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/general/sweetTalkUser.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/general/taskUser.dart';
import 'package:star_t/ui/screens/homeScreen/settting.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../firebase/dataProvider.dart';
import '../../../utilites/appAssets.dart';
import '../features/featuresHomeScreenUsers/Contents/compettion/natification/natification.dart';
import '../features/featuresHomeScreenUsers/Contents/compettion/score.dart';
import '../features/featuresHomeScreenUsers/Contents/general/eventUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/ideasUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/opnionUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/teamUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/weekUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/wordUser.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/chartsDigram/charts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int _currentIndex = 0;
  int? lastSelectedWeek; // متغير لحفظ آخر قيمة

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
      isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of(context);
    final List<Widget> pic = [
      general("general"),
      competition("competition"),
    ];

    final isTablet = MediaQuery.of(context).size.width > 600;

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
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Column(
                children: [
                  if (isRefreshing)
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
                        colors: AppColors.backGround,
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
                              colors: AppColors.appBarColor,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          height: isTablet
                              ? MediaQuery.of(context).size.height * 0.25
                              : MediaQuery.of(context).size.height * 0.33,
                        ),
                        Column(
                          children: [
                            CarouselSlider(
                              items: pic,
                              options: CarouselOptions(
                                height: isTablet
                                    ? MediaQuery.of(context).size.height * 0.6
                                    : MediaQuery.of(context).size.height * 0.45,
                                viewportFraction: 1.0,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                autoPlay: false,
                                autoPlayInterval: const Duration(seconds: 2),
                                autoPlayAnimationDuration:
                                const Duration(seconds: 2),
                                autoPlayCurve: Curves.easeInOut,
                                enlargeCenterPage: false,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(pic.length, (index) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(
                                      bottom: 20, right: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == index
                                        ? AppColors.mainColor
                                        : AppColors.darkgrey,
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
                      color: AppColors.white,
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
                            color: AppColors.white,
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
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.white,
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
                          scrollController: FixedExtentScrollController(
                              initialItem:
                              ((dataProvider.currentWeekNum - 1) ~/ 4)),
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
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
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
                              color: AppColors.secColor,
                              borderRadius: const BorderRadius.only(
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
                                    color: AppColors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  "#1",
                                  style: GoogleFonts.aclonica(
                                    fontSize: isTablet ? 40 : 30,
                                    color: AppColors.white,
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
                            color: AppColors.secColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Statistics.routeName);
                          },
                          child: Column(
                            children: [
                              Text(
                                "Analycse",
                                style: GoogleFonts.aclonica(
                                  fontSize: isTablet ? 20 : 15,
                                  color: AppColors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                value: 2.0,
                                color: AppColors.white,
                                backgroundColor: AppColors.lightgrey,
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

  Widget general(String head) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 0, right: 10, bottom: 0),
          child: Text(
            head,
            style: GoogleFonts.aboreto(
                color: AppColors.white,
                fontSize: MediaQuery.sizeOf(context).width * 0.08),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Optiongeneral('IDeas', Icons.lightbulb_outline, () {
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
            ScaleTransition(
              scale: _scaleAnimation,
              child: InkWell(
                onTap: () async {
                  WeekUser();

                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.width * 0.25,
                  width: MediaQuery.of(context).size.width * 0.25,
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
                    stream: FirebaseFirestore.instance
                        .collection('settings')
                        .doc('currentWeek')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${lastSelectedWeek ?? 0}",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.09,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.width * 0.005),
                            Text(
                              "week",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.03,
                                color: AppColors.white,
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
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.09,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.width * 0.005),
                            Text(
                              "week",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.03,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }

                      final weekNumber = snapshot.data!['weekNumber'] as int;
                      lastSelectedWeek = weekNumber;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$weekNumber",
                            style: GoogleFonts.aclonica(
                              fontSize: MediaQuery.of(context).size.width * 0.09,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.005),
                          Text(
                            "week",
                            style: GoogleFonts.aclonica(
                              fontSize: MediaQuery.of(context).size.width * 0.03,
                              color: AppColors.white,
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
            Flexible(
              child: Optiongeneral('Opinion', Icons.comment, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: OpinionUser(),
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
              child: Optiongeneral("Sweet Talk", Icons.favorite_border, () {
                _onTap();
                showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => SweetTalkUser());
              }),
            ),
            Flexible(
              child: Optiongeneral("Word", Icons.text_fields, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => WordUser(),
                );
              }),
            ),
            Flexible(
              child: Optiongeneral("Team", Icons.group, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) =>
                      _buildDraggableScrollableSheet(const TeamUser()),
                );
              }),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Optiongeneral("Taskoo", Icons.assignment, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Taskuser(),
                  ),
                );
              }),
            ),
            Flexible(
              child: Optiongeneral("Hi.Event", Icons.event, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => EventUser(),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget Optiongeneral(String optionName, IconData icon, VoidCallback onTap) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.width * 0.21,
          width: MediaQuery.of(context).size.width * 0.21,
          decoration: BoxDecoration(
            color: AppColors.white,
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
                size: MediaQuery.of(context).size.width * 0.09,
                color: AppColors.mainColor,
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.007),
              Text(
                optionName,
                style: GoogleFonts.aclonica(
                  fontSize: MediaQuery.of(context).size.width * 0.032,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget competition(String head) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin:
          const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 0),
          child: Text(
            head,
            style: GoogleFonts.aboreto(
                color: AppColors.white,
                fontSize: MediaQuery.sizeOf(context).width * 0.08),
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child:
              Optioncompetition('Prize', Icons.military_tech_outlined, () {
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
            ScaleTransition(
                scale: _scaleAnimation,
                child: Score(
                  numNatification: 5,
                  appearNatification: true,
                  colorNatification: Colors.grey,
                  selectedMonth: '',
                )),
            Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optioncompetition('mission', Icons.minor_crash_sharp, () {
                      _onTap();
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: OpinionUser(),
                        ),
                      );
                    }),
                    Natification(
                      color: Colors.red,
                      num: 1,
                      appear: true,
                      appearIcon: true,
                    )
                  ],
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Optioncompetition("Rank", Icons.numbers_outlined, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => RankPage(),
                );
              }),
            ),
            Flexible(
              child:
              Optioncompetition("Attend", Icons.battery_charging_full, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) =>
                      _buildDraggableScrollableSheet(const TeamUser()),
                );
              }),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }

  Widget Optioncompetition(
      String optionName, IconData icon, VoidCallback onTap) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            color: AppColors.white,
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
                size: MediaQuery.of(context).size.width * 0.11,
                color: AppColors.mainColor,
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.007),
              Text(
                optionName,
                style: GoogleFonts.abyssinicaSil(
                  fontSize: MediaQuery.of(context).size.width * 0.038,
                  color: AppColors.black,
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