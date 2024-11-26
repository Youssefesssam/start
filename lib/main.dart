import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/home.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/achive/screenAchive.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/auth/loginScreen/loginScreen.dart';
import 'package:star_t/ui/screens/auth/registerScreen/regsterScreen.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/ScreenHomeLeaders/screenHomeLeaders.dart';
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
  runApp(const MyApp());
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
        HomeScreenLeaders.routeName: (_) =>  const HomeScreenLeaders(),
        HomeScreenUsers.routeName: (_) => const HomeScreenUsers(),
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        Charts.routeName: (_) => const Charts(),
        Setting.routeName: (_) => const Setting(),
        EventScreen.routeName: (_) => const EventScreen(),
        TeemScreen.routeName: (_) => const TeemScreen(),
        TaskScreen.routeName: (_) => const TaskScreen(),
        ScreenHomeLeaders.routeName: (_) => const ScreenHomeLeaders(),
        AttendManual.routeName: (_) => const AttendManual(),
        ScreenAchive.routeName: (_) => const ScreenAchive(),
        Statistics.routeName: (_) => const Statistics(),
        Home.routeName: (_) => const Home(),
      },
    );
  }
}
