import 'package:flutter/material.dart';

import '../../../utilites/appAssets.dart';
import '../auth/loginScreen/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "Splash screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), (){

      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(AppAssets.splashScreen, fit: BoxFit.fill,),
            ),
          ],
        )
    );
  }
}