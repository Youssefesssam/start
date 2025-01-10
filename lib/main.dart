import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/authProvider.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/home.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistcsViewModel.dart';
import 'package:star_t/ui/screens/homeScreen/profile.dart';
import 'package:star_t/ui/screens/homeScreen/settting.dart';
import 'firebase/dataProvider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/auth/loginScreen/loginScreen.dart';
import 'package:star_t/ui/screens/auth/registerScreen/regsterScreen.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/appBarLeaders/attendManual/attendManual.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/appBarUser/setting/setting.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/chartsDigram/charts.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/slider/event/event.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/slider/task/task.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/slider/teem/teem.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenLeaders.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenUsers.dart';
import 'package:star_t/ui/screens/splashScreen/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseFirestore.instance.disableNetwork();
  FirebaseFirestore.instance.settings =
  const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context)=> AuthProviders(),),
    ChangeNotifierProvider(create: (context)=> DataProvider(),),
    ChangeNotifierProvider(create: (context)=> StatisticsViewModel(),),
  ],
    child: MyApp(),
  )

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreenUsers.routeName,
      // This trailing comma makes auto-formatting nicer for build methods.
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreenLeaders.routeName: (_) =>   HomeScreenLeaders(),
        HomeScreenUsers.routeName: (_) =>  HomeScreenUsers(),
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        Charts.routeName: (_) =>  Charts(),
        Setting.routeName: (_) => const Setting(),
        SettingUser.routeName: (_) => const SettingUser(),
        EventScreen.routeName: (_) => const EventScreen(),
        TeemScreen.routeName: (_) => const TeemScreen(),
        TaskScreen.routeName: (_) => const TaskScreen(),
        ListOfUsers.routeName: (_) =>  ListOfUsers(),
        AttendManual.routeName: (_) => const AttendManual(),
        Statistics.routeName: (_) =>  Statistics(),
        Home.routeName: (_) => const Home(),
        RankPage.routeName: (_) =>  RankPage(),
        AccountProfile.routeName: (_) =>  AccountProfile(),
      },
    );
  }
}