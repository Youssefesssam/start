import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import 'package:star_t/model/modelEvent.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/compettion/attendUser.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/general/sweetTalkUser.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/general/taskUser.dart';
import 'package:star_t/ui/screens/homeScreen/settting.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../firebase/authProvider.dart';
import '../../../firebase/dataProvider.dart';
import '../../../model/modelSweetTalk.dart';
import '../../../utilites/appTexts.dart';
import '../../../utilites/consts.dart';
import '../features/featuresHomeScreenUsers/Contents/compettion/natification/natification.dart';
import '../features/featuresHomeScreenUsers/Contents/compettion/score.dart';
import '../features/featuresHomeScreenUsers/Contents/general/eventUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/idea/ideasUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/opnionUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/teamUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/weekUser.dart';
import '../features/featuresHomeScreenUsers/Contents/general/wordUser.dart';
import '../features/featuresHomeScreenUsers/Contents/shimaa/animatedAvatar.dart';
import '../features/featuresHomeScreenUsers/Contents/shimaa/shimmerCard.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import '../features/featuresHomeScreenUsers/bodyScreenUsers/chartsDigram/charts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenUsers extends StatefulWidget {
  HomeScreenUsers({super.key});

  static const String routeName = "homeScreenUsers";

  @override
  State<HomeScreenUsers> createState() => _HomeScreenUsersState();
}

class _HomeScreenUsersState extends State<HomeScreenUsers>
    with SingleTickerProviderStateMixin {
  String selectedMonthString = '01';
  int selectedMonthIntegr = 1;
  bool isRefreshing = false;
  bool _isGlobalLoading = false;

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
  int? lastSelectedWeek;
  bool unSeenSweetTalk = AppTexts.seenSweet; // متغير للتحكم في ظهور الإشعار
  bool unSeenWord = AppTexts.seenWord; // متغير للتحكم في ظهور الإشعار
  bool unSeenEvent = AppTexts.seenEvent;
  String lastEvent = "";
  String lastWord = "";
  String lastTask = "";
  String lastSweet = "";
  String newEvent = "";
  String newWord = "";
  String newTask = "";
  String newSweet = "";
  bool _isLoading = false; // حالة اللودر
  double _dragOffset = 0.0; // المسافة التي تم سحبها


  Future<void> _onPull() async {
    setState(() {
      _isLoading = true; // عرض اللودر
    });

    // محاكاة عملية التحميل أو التحديث
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false; // إخفاء اللودر بعد التحديث
    });
  } // حالة السحب

  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    saveUserIdInProvider(context);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> saveUserIdInProvider(BuildContext context) async {
    String? userId = await Consts.getUserId();
    String? profile = await Consts.getProfile();
    var snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('currentWeek')
        .get();

    if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey("weekNumber")) {
      Provider.of<AuthProviders>(context, listen: false).setCurrentWeek(snapshot["weekNumber"]);
      Provider.of<AuthProviders>(context, listen: false).setWeek(snapshot["weekNumber"]);
      Provider.of<AuthProviders>(context, listen: false).setCurrentMonth(snapshot["weekNumber"]);

    } else {
      print("No weekNumber found in snapshot!");
    }    if (userId != null) {
      Provider.of<AuthProviders>(context, listen: false).setUserId(userId);
      Provider.of<AuthProviders>(context, listen: false)
          .setUserProfile(profile!);
      print(
          "userId ---------- ${Provider.of<AuthProviders>(context, listen: false).userId}");
    }
  }

  Future<bool> hasNew(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> keys = {
      "event": "lastEventId",
      "word": "lastWordId",
      "task": "lastTaskId",
      "sweet": "lastSweetId",
    };

    if (!keys.containsKey(type)) {
      return false;
    }

    String lastId = prefs.getString(keys[type]!) ?? "";
    String newId = await hasNotification(type);

    return lastId != newId;
  }

  Future<String> hasNotification(String type) async {
    Map<String, String> collections = {
      "event": ModelHiEvent.collection,
      "word": "word",
      "task": "task",
      "sweet": ModelSweetTalk.collection,
    };

    if (!collections.containsKey(type)) {
      return "";
    }

    var fire = await FirebaseFirestore.instance
        .collection(collections[type]!)
        .limit(1)
        .get();

    return fire.docs.isNotEmpty ? fire.docs.first.id : "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      // تأكد إن الويجت لسه في الشاشة
    });
  }





  void _startLoading() async {
    setState(() {
      _isLoading = true; // تفعيل اللودر
    });
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    print(authProviders.weekUse);
    await FireBaseSetDataForUser.getThisWeek(userId: authProviders.userId!,numWeek:  authProviders.currentWeek!,monthId:authProviders.currentMonth!, numWeekUse:authProviders.weekUse!);
    await Future.delayed(const Duration(seconds: 1)); // محاكاة عملية التحميل

    setState(() {
      _isLoading = false; // إيقاف اللودر
      _dragOffset = 0; // إعادة تعيين _dragOffset بعد انتهاء التحميل
    });
  }

  void _resetDrag() {
    setState(() {
      _dragOffset = 0; // إعادة تعيين _dragOffset إلى الصفر
      // قم بإضافة أي عملية تحتاج إلى تنفيذها هنا بعد إعادة الضبط
    });
  }
  @override
  Widget build(BuildContext context) {

    DataProvider dataProvider = Provider.of(context);
    AuthProviders authProviders = Provider.of(context);
    final List<Widget> pic = [
      general("general"),
      competition("competition"),
    ];

    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor:Colors.teal[600]!,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (!_isLoading && details.primaryDelta! > 0) {
            setState(() {
              _dragOffset += details.primaryDelta! * 0.2;
            });
          }
        },
        onVerticalDragEnd: (details) {
          if (_dragOffset > 50) {
            _startLoading(); // تحميل
          } else {
            _resetDrag(); // إلغاء السحب
          }
        },
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, _dragOffset),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
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
                              SizedBox(
                                height: isTablet
                                    ? MediaQuery.of(context).size.height * 0.25
                                    : MediaQuery.of(context).size.height * 0.53,
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
                                        margin: const EdgeInsets.only(bottom: 20, right: 5),
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
                  ),
                  Positioned(
                    height: 200,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
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
                  ),
                  Positioned(
                    top: 100,
                    left: 20,
                    right: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.40,
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
                        child: Charts(selectMonth: selectedMonthIntegr),
                      ),
                    ),
                  ),
                  AnimatedAvatar(imageUrl:authProviders.profileURl! ),
                  Positioned(
                    top: 40,
                    left: 135,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consts.fetcher(
                            Consts.getName(),
                            GoogleFonts.aclonica(
                              fontSize: MediaQuery.of(context).size.height * .023,
                              color: AppColors.white,
                              letterSpacing: 1.2,
                            )),
                        SizedBox(
                          height: 7,
                        ),
                        Consts.fetcher(
                            Consts.getEmail(),
                            GoogleFonts.aclonica(
                              fontSize: MediaQuery.of(context).size.height * .012,
                              color: AppColors.white,
                              letterSpacing: 1.2,
                            )),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * .05,
                    right: MediaQuery.of(context).size.height * .01,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SettingUser.routeName);
                      },
                    ),
                  ),
                  Positioned(
                    top: 110,
                    right: -7,
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
                                  ((authProviders.weekUse! - 1) ~/ 4)),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedMonthString = (index + 1).toString().padLeft(2, '0');
                                  selectedMonthIntegr = index + 1;
                                });
                                final authProviders = Provider.of<AuthProviders>(context, listen: false);
                                FireBaseSetDataForUser.getThisWeek(userId:authProviders.userId!,numWeek:authProviders.currentWeek!,monthId: authProviders.currentMonth!, numWeekUse: authProviders.weekUse!);
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RankPage.routeName);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                right: 50, top: 10, left: 20, bottom: 10),
                            decoration: BoxDecoration(
                                color: AppColors.secColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            child: Column(
                              children: [
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
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Statistics.routeName);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                right: 50, top: 10, left: 20, bottom: 10),
                            decoration: BoxDecoration(
                                color: AppColors.secColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            child: Column(
                              children: [
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
                    ),
                  ),


                  // أي عناصر تانية عايزها تتحرك
                ],

              ),
            ),


            // مؤشر التحميل
            if (_isLoading)
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),


    );
  }

  Widget general(String head) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin:
            const EdgeInsets.only(left: 20, top: 0, right: 10, bottom: 0),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                  height: MediaQuery.of(context).size.width *
                                      0.005),
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
                                  height: MediaQuery.of(context).size.width *
                                      0.005),
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
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Optiongeneral(
                        "Sweet",
                        Icons.favorite_border,
                            () async {
                          _onTap();

                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          String newSweetId = await hasNotification(
                              "sweet"); // ✅ جلب آخر ID من Firestore

                          await prefs.setString("lastSweetId",
                              newSweetId); // ✅ تحديث آخر ID في SharedPreferences

                          setState(() {
                            unSeenSweetTalk = false; // ✅ إخفاء الإشعار عند النقر
                          });

                          showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => SweetTalkUser(),
                          );
                        },
                      ),
                      FutureBuilder<bool>(
                        future: hasNew("sweet"),
                        // ✅ التحقق من وجود رسائل جديدة في SweetTalk
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Notifications(
                              color: Colors.red,
                              num: 1,
                              appear: false,
                              appearIcon: true,
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return Notifications(
                              color: Colors.red,
                              num: 1,
                              appear: snapshot.data ?? false,
                              // ✅ استخدام القيمة المحسوبة
                              appearIcon: false,
                            );
                          }
                        },
                      ),
                    ],
                  )),
              Flexible(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Optiongeneral(
                        "Word",
                        Icons.text_fields,
                            () async {
                          _onTap();

                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          String newWordId = await hasNotification(
                              "word"); // ✅ جلب آخر ID من Firestore

                          await prefs.setString("lastWordId",
                              newWordId); // ✅ تحديث آخر ID في SharedPreferences

                          setState(() {
                            unSeenWord = false; // ✅ إخفاء الإشعار عند النقر
                          });

                          showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => WordUser(),
                          );
                        },
                      ),
                      FutureBuilder<bool>(
                        future: hasNew("word"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Notifications(
                              color: Colors.red,
                              num: 1,
                              appear: false,
                              appearIcon: false,
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return Notifications(
                              color: Colors.red,
                              num: 1,
                              appear: snapshot.data ?? false,
                              // ✅ استخدام القيمة المحسوبة
                              appearIcon: false,
                            );
                          }
                        },
                      ),
                    ],
                  )),
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
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Optiongeneral(
                        "Taskoo",
                        Icons.assignment,
                            () async {
                          _onTap();

                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          String newTaskId = await hasNotification(
                              "task"); // ✅ جلب آخر ID من Firestore

                          await prefs.setString("lastTaskId",
                              newTaskId); // ✅ تحديث آخر ID في SharedPreferences

                          setState(() {
                            unSeenEvent = false; // ✅ إخفاء الإشعار عند النقر
                          });

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
                        },
                      ),
                      FutureBuilder<bool>(
                        future: hasNew("task"),
                        // ✅ استخدام hasNew("task") للتحقق من المهام الجديدة
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Notifications(
                              color: Colors.red,
                              num: 1,
                              appear: false,
                              appearIcon: false,
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return Notifications(
                              color: Colors.red,
                              num: 1,
                              appear: snapshot.data ?? false,
                              // ✅ استخدام القيمة المحسوبة
                              appearIcon: false,
                            );
                          }
                        },
                      ),
                    ],
                  )),
              Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optiongeneral(
                      "Hi.Event",
                      Icons.event,
                          () async {
                        _onTap();

                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        String newEventId = await hasNotification(
                            "event"); // ✅ جلب آخر ID من Firestore

                        await prefs.setString("lastEventId",
                            newEventId); // ✅ تحديث آخر ID في SharedPreferences

                        setState(() {
                          lastEvent =
                              newEventId; // ✅ تحديث المتغير داخل الواجهة
                        });

                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => EventUser(),
                        );
                      },
                    ),
                    FutureBuilder<bool>(
                      future: hasNew("event"),
                      // ✅ استخدام hasNew("event") بدلًا من has()
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: false,
                            appearIcon: false,
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: snapshot.data ?? false,
                            appearIcon: false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget Optiongeneral(String optionName, IconData icon, VoidCallback onTap) {
    final size = MediaQuery.of(context).size.width * 0.21;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: ShimmerCard(
        size: size,
        isLoading: _isGlobalLoading,
        child: InkWell(
          onTap:  onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: size * 0.4,
                  color: AppColors.white,
                ),
                SizedBox(height: size * 0.07),
                Text(
                  optionName,
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: size * 0.15,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optioncompetition('Prize', Icons.military_tech_outlined, () {
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
                    Notifications(
                      color: Colors.red,
                      num: 1,
                      appear: true,
                      // استخدام القيمة المحسوبة
                      appearIcon: true,
                    )
                  ],
                )),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Score(
                numNatification: 5,
                appearNatification: false,
                colorNatification: Colors.grey,
                selectedMonth: '',
              ),
            ),
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
                    Notifications(
                      color: Colors.red,
                      num: 1,
                      appear: true,
                      // استخدام القيمة المحسوبة
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
                  builder: (context) => AttendUser(),
                );
              }),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }

  Widget Optioncompetition(String optionName, IconData icon, VoidCallback onTap) {
    final size = MediaQuery.of(context).size.width * 0.25;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: ShimmerCard(
        size: size,
        isLoading: _isGlobalLoading,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: size * 0.4,
                  color:AppColors.white,
                ),
                SizedBox(height: size * 0.07),
                Text(
                  optionName,
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: size * 0.15,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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