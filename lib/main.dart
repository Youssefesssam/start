import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/authProvider.dart';
import 'package:star_t/model/modelDataForUser.dart';
import 'package:star_t/providers/leader_provider.dart';
import 'package:star_t/screens/add_leaader_screen.dart';
import 'package:star_t/screens/add_sub_leader_screen.dart';
import 'package:star_t/screens/login_screen.dart';
import 'package:star_t/screens/regester_leader_screen.dart';
import 'package:star_t/screens/screen_profile_leader.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/bodyScreenLaders/attend/attend.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/absent/absentData.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/answers.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/home.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/home/team.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/shimaa/animatedProfile.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistcsViewModel.dart';
import 'package:star_t/ui/screens/homeScreen/profile.dart';
import 'package:star_t/ui/screens/homeScreen/settting.dart';
import 'package:star_t/widgets/user_checkbox.dart';
import 'firebase/dataProvider.dart';
import 'firebase/providerTotalScore.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/auth/loginScreen/loginScreen.dart';
import 'package:star_t/ui/screens/auth/registerScreen/regsterScreen.dart';
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
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthProviders(),
      ),
      ChangeNotifierProvider(
        create: (context) => DataProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => StatisticsViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProviderTotalScore(),
      ),
      ChangeNotifierProvider(
        create: (context) => LeaderProvider(),
      ),
    ],
    child: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      locale: const Locale('en'),
      supportedLocales: [
        Locale('en'),
        Locale('ar')
      ],

      /*localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],*/

      initialRoute:HomeScreenLeaders.routeName,
      // This trailing comma makes auto-formatting nicer for build methods.
      debugShowCheckedModeBanner: false,
      routes: {

        HomeScreenLeaders.routeName: (_) => HomeScreenLeaders(),
        HomeScreenUsers.routeName: (_) => HomeScreenUsers(),
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) =>  RegisterScreen(),
        Charts.routeName: (_) => Charts(),
        Setting.routeName: (_) => const Setting(),
        SettingUser.routeName: (_) => const SettingUser(),
        EventScreen.routeName: (_) => const EventScreen(),
        TeemScreen.routeName: (_) => const TeemScreen(),
        TaskScreen.routeName: (_) => const TaskScreen(),
        ListOfUsers.routeName: (_) => ListOfUsers(),
        Statistics.routeName: (_) => const Statistics(),
        Home.routeName: (_) =>  Home(),
        RankPage.routeName: (_) => const RankPage(),
        UserProfilePage.routeName: (_) => const UserProfilePage(),
        Attend.routeName: (_) => Attend(),
        Answers.routeName: (_) => const Answers(),
        AbsentData.routeName: (_) => const AbsentData(),
        Team.routeName: (_) => const Team(),
        AnimatedProfile.routeName: (_) => AnimatedProfile(),
        LoginScreenLeader.routeName: (_) => LoginScreenLeader(),
        RegisterLeaderScreen.routeName: (_) => RegisterLeaderScreen(leaderCode: 'M011013977',),
        ProfileScreen.routeName: (_) => ProfileScreen(),
        AddMasterLeaderScreen.routeName: (_) => AddMasterLeaderScreen(),
        AddSubLeaderScreen.routeName: (_) => AddSubLeaderScreen(masterLeaderCode: 'M011013977',),
      },
    );
  }
}