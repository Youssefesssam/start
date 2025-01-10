import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/ui/screens/homeScreen/settting.dart';
import '../../../firebase/dataProvider.dart';
import '../../../utilites/appAssets.dart';
import '../features/featuresHomeScreenUsers/Contents/achive/achive.dart';
import '../features/featuresHomeScreenUsers/Contents/aword.dart';
import '../features/featuresHomeScreenUsers/Contents/gift.dart';
import '../features/featuresHomeScreenUsers/Contents/score.dart';
import '../features/featuresHomeScreenUsers/appBarUser/appBarUsers/appBarUser.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/chartsDigram/charts.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/slider/slide.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreenUsers extends StatefulWidget {
  HomeScreenUsers({super.key});

  static const String routeName = "homeScreenUsers";

  @override
  State<HomeScreenUsers> createState() => _HomeScreenUsersState();
}

class _HomeScreenUsersState extends State<HomeScreenUsers> {
  String selectedMonth = '01'; // الشهر المحدد
  bool isRefreshing = false; // حالة التحديث
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

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true; // تفعيل حالة التحديث عند السحب لأسفل
    });

    // تنفيذ عملية التأخير (مثل تحميل البيانات)
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isRefreshing = false; // إيقاف التحديث بعد فترة
    });
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    final phone = MediaQuery.of(context).size.width < 600;
    List<Widget> content = [
      Container(
        margin: EdgeInsets.all(10),
        child: Score(
          color: Colors.black,
          path: AppAssets.bestScore,
          titleCard: "Score",
          numNatification: 3,
          colorNatification: Colors.orange,
          appearNatification: false,
          selectedMonth: selectedMonth,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: Aword(
          color: Colors.black,
          path: AppAssets.speech,
          titleCard: "Weekly word",
          numNatification: 8,
          colorNatification: Color(0xffe8bb80),
          appearNatification: true,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: Gift(
          color: Colors.black,
          path: AppAssets.giftCard,
          titleCard: "Gift",
          numNatification: 1,
          colorNatification: Colors.orange,
          appearNatification: true,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: Achive(
          color: Colors.black,
          path: AppAssets.achivement,
          titleCard: "Achive",
          numNatification: 8,
          colorNatification: Colors.orange,
          appearNatification: true,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xfff7eddf),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          // تحقق من حالة السحب لأسفل
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.metrics.pixels <= 0) {
              setState(() {
                isRefreshing = true; // تفعيل حالة التحديث عند السحب
              });

              // تنفيذ عملية التأخير (مثل تحميل البيانات)
              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  isRefreshing = false; // إيقاف التحديث بعد فترة
                });
              });
            }
          }
          return false; // يسمح ببقية السلوك الطبيعي
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // السماح بالسحب دائمًا
          child: Stack(
            children: [
              Column(
                children: [
                  if (isRefreshing)
                  // إظهار صورة عند السحب لأسفل
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(20),
                        height: 80,
                          width: 80,
                          child: Icon(Icons.refresh,size: 50,)),
                    ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x15e7ba7f),
                          Color(0x41e7ba7f)],
                        begin: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppBarUser(),
                        SizedBox(
                          height: 260,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, bottom: 20),
                              child: Text(
                                'Content',
                                style: GoogleFonts.aclonica(fontSize: 25, color: Colors.brown),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5, bottom: 20),
                              child: Image.asset(
                                AppAssets.content,
                                height: 30,
                                width: 40,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CarouselSlider(
                                items: content,
                                options: CarouselOptions(
                                  height: 160,
                                  viewportFraction: .4,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  autoPlay: false,
                                  autoPlayInterval: const Duration(seconds: 2),
                                  autoPlayAnimationDuration:
                                  const Duration(seconds: 2),
                                  autoPlayCurve: Curves.easeInOut,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.3,
                                  scrollDirection: Axis.horizontal,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child:  Text(
                                'General Content',
                                style: GoogleFonts.aclonica(fontSize: 25, color: Colors.brown),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Image.asset(
                                AppAssets.content,
                                height: 30,
                                width: 40,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                        SliderPic(),
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

                    width: 100,
                    height: 350,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ Colors.white,  Colors.white],
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Container(
                        margin: EdgeInsets.only(top: 30, right: 20),
                        child: Charts(selectedmonth: selectedMonth)),
                  )),
              Positioned(
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
                          style: GoogleFonts.aclonica(fontSize: 20, color: Colors.white, letterSpacing: 1.2,),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "User Bio or Description ",
                          style: GoogleFonts.aclonica(fontSize: 12, color: Colors.white70, letterSpacing: 1.2,),
                        ),
                      ],
                    ),
                    SizedBox(width: 25),
                    IconButton(
                      icon: Icon(
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
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.only(right: 70, top: 10, left: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Color(0xbede9436),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))),
                          child: Column(
                            children: [
                              Text(
                                "Rank#",
                                style: GoogleFonts.aclonica(fontSize: 15, color: Colors.white, letterSpacing: 1.2,),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RankPage.routeName);
                                },
                                child: Text(
                                  "#1",
                                  style: GoogleFonts.aclonica(fontSize: 30, color: Colors.white, letterSpacing: 1.2,),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 45, top: 10, left: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Color(0xbdde9436),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: Column(
                          children: [
                            Text(
                              "Statistics",
                              style: GoogleFonts.aclonica(fontSize: 15, color: Colors.white, letterSpacing: 1.2,),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Statistics.routeName);
                              },
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                value: 2.0,
                                // هنا وضعنا 0.0 في حالة انتظار الداتا
                                color: Colors.brown,
                                backgroundColor: Colors.white54,
                                strokeWidth: 5,
                              ),
                            ),
                          ],
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
}