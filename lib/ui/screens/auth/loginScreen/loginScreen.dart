import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:star_t/model/modelData.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenLeaders.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenUsers.dart';
import '../../../../firebase/authProvider.dart';
import '../../../../utilites/appAssets.dart';
import '../registerScreen/regsterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "loginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    DataProvider dataProvider = Provider.of(context);
    AuthProviders authProviders = Provider.of(context);


    return Scaffold(

        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.loginScreen),
                    fit: BoxFit.fill)),
            child: Container(
              margin: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: heightScreen * .34,
                  ),
                  const Text("Login", textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),),
                  const Divider(thickness: 4, height: 10),
                  Container(
                    height: heightScreen * .1,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Email",
                        suffixIcon: const Icon(Icons.account_circle_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hoverColor: Colors.black
                    ),
                    controller: emailController,
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: "password",
                        suffixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40,),

                  Center(
                      child: Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: () {


                           signIn(emailController, passwordController, context);

                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent,
                            ),
                            child: const Text(
                              "sign Up",
                              style: TextStyle(fontSize: 30, color: Colors.black87),
                            ),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  Center(child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                      },
                      child: const Text("Create new account", style: TextStyle(decoration: TextDecoration.underline),))),
                  SizedBox(height: heightScreen * .01,),
                  Text("or sign in with ", textAlign: TextAlign.center,),
                  SizedBox(height: heightScreen * .01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: heightScreen * .02,
                        backgroundImage: NetworkImage("https://th.bing.com/th/id/OIP.Fll7WPtNT6jrz1oBP8GbCgHaHj?rs=1&pid=ImgDetMain"),
                      ),
                      SizedBox(width: heightScreen * .005,),
                      CircleAvatar(
                        radius: heightScreen * .02,
                        backgroundImage: NetworkImage("https://th.bing.com/th/id/OIP.d_aqJ-1Jz8Ok1Z9NYiYbVgAAAA?rs=1&pid=ImgDetMain"),
                      )
                    ],
                  ),
                  SizedBox(height: heightScreen * .01,),
                ],
              ),
            ),
          ),
        ));
  }

  // دالة signIn المعدلة
  void signIn(TextEditingController emailController, TextEditingController passwordController, BuildContext context) async {
    DataProvider dataProvider = Provider.of<DataProvider>(context, listen: false);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? firebaseUser = credential.user;
      String? userId = firebaseUser?.uid;

      // حفظ userId و تحميل البيانات
      dataProvider.uid = userId!;
      if (userId != null) {
        print("User ID: $userId");

        // تحميل بيانات المستخدم بعد تسجيل الدخول الناجح


        // الانتقال إلى HomeScreenUsers
        Navigator.pushNamed(context, HomeScreenUsers.routeName);
      }
    } catch (e) {
      print("Error logging in: $e");
    }
  }
}


