import 'package:flutter/material.dart';
import '../../../../utilites/appAssets.dart';
import '../../features/featuresHomeScreenLeaders/ScreenHomeLeaders/screenHomeLeaders.dart';
import '../registerScreen/regsterScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = "loginScreen";

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.loginScreen), fit: BoxFit.fill)),
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: heightScreen * .34,
                ),

                const Text("Login",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                const Divider(thickness: 4,height: 10),
                Container(
                  height: heightScreen * .1,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    suffixIcon: const Icon(Icons.account_circle_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hoverColor: Colors.black
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  decoration: InputDecoration(
                    labelText: "password",
                    suffixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                  )
                  ,obscureText: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, ScreenHomeLeaders.routeName);
                    },
                    child: Center(
                        child: Card(
                          elevation: 5,
                          child: Container(
                              padding: const EdgeInsets.only(left: 40,right: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueAccent,
                              ),
                              child: const Text(
                                "sign Up",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black87),
                              )),
                        ))),
                const SizedBox(height: 10,),
                Center(child: InkWell(
                  onTap: (){
                    Navigator.pushReplacementNamed(
                        context, RegisterScreen.routeName);
                  },
                    child: const Text("Creat new account",style: TextStyle(decoration: TextDecoration.underline),))),

              ],
            ),
          ),
        ));
  }
}
