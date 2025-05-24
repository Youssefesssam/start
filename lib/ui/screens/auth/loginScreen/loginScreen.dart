import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import 'package:star_t/firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import 'package:star_t/model/modelUser.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenLeaders.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenUsers.dart';
import '../../../../utilites/appColors.dart';
import '../registerScreen/regsterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "loginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  void signIn(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        String userId = firebaseUser.uid;
        String? email = firebaseUser.email;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('email', email ?? "");
        MyUser? myUser= await FireBaseSetDataForUser.readUserData2(userId);
        await prefs.setString("name", myUser!.name);
        await prefs.setString("profileUrl", myUser.profileUrl);
        await prefs.setString("code", myUser.code);
        await prefs.setString("gender", myUser.gender);
        await prefs.setString("phone", myUser.phone);
        await prefs.setString("talent", myUser.talent);
        await prefs.setString("university", myUser.university);
        await prefs.setString("address", myUser.address);
        Provider
            .of<DataProvider>(context, listen: false)
            .uid = userId;
        Navigator.pushReplacementNamed(context, HomeScreenUsers.routeName);
      }
    } catch (e) {
      print("Error logging in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية متدرجة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.teal.shade800.withOpacity(0.2),
                  Colors.teal.shade200.withOpacity(0.1),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.only(
                      top: 50, bottom: 30, left: 16, right: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.appBarColor,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.shade800.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                // Form Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(30),
                    decoration:BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildTextFieldWithIcon(
                          "Email",
                          Icons.email_outlined,
                          emailController,
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithIcon(
                          "Password",
                          Icons.lock_outline,
                          passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => signIn(context),
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 18,color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.teal.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context,
                                  RegisterScreen.routeName),
                          child: Text(
                            "Create new account",
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon(String label,
      IconData icon,
      TextEditingController controller, {
        bool obscureText = false,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal.shade600),
        floatingLabelStyle: TextStyle(color: Colors.teal.shade700),
        prefixIcon: Icon(icon, color: Colors.teal.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: TextStyle(color: Colors.black87, fontSize: 16),
    );
  }
}