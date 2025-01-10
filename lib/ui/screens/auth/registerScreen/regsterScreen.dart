import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenLeaders.dart';
import '../../../../model/modelData.dart';
import '../../../../firebase/authProvider.dart';
import '../../../../model/modelUser.dart';
import '../../../../utilites/appAssets.dart';
import '../../homeScreen/homeScreenUsers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  static const String routeName = "registerScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  DateTime _birthdayController = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController talentController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  String _selectedGender = "male"; // Initial value for gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(AppAssets.registerScreen1),
            const Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your name",
                      suffixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      suffixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      suffixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Re-enter your password",
                      suffixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: repasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Address",
                      hintText: "Enter your address",
                      suffixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: addressController,
                  ),

                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Enter your phone number",
                      suffixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: phoneController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Talent",
                      hintText: "Enter your talent",
                      suffixIcon: const Icon(Icons.star),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: talentController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "university",
                      hintText: "Enter your university",
                      suffixIcon: const Icon(Icons.school_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: universityController,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "male",
                        child: Text("Male"),
                      ),
                      DropdownMenuItem(
                        value: "female",
                        child: Text("Female"),
                      ),
                      DropdownMenuItem(
                        value: "other",
                        child: Text("Other"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {

                      regiester();
                      Navigator.pushNamed(context,HomeScreenLeaders.routeName,);

                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.blue,
                      ),
                      child: const Text(
                        "Create",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateFormat(String s) {}

  void registerWithHierarchy() async {
    DataProvider dataProvider = Provider.of(context, listen: false);
    try {
      // التحقق من القيم المدخلة
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        print("Email or Password is empty");
        return;
      }

      // إنشاء المستخدم باستخدام Firebase Auth
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // إنشاء كائن المستخدم
      MyUser myUser = MyUser(
        name: nameController.text.trim(),
        id: credential.user!.uid,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        gender: _selectedGender,
        talent: talentController.text.trim(),
        university: universityController.text.trim(),
      );

      // تحديث المستخدم باستخدام Provider
      var authProvider = Provider.of<AuthProviders>(context, listen: false);
      authProvider.changeUser(myUser);

      // طباعة UID
      print("Registration success!");
      print("User ID: ${credential.user?.uid}");

      // تحديث الـ UID في DataProvider
      dataProvider.uid = credential.user!.uid;
      print("Stored UID: ${dataProvider.uid}");

      // إضافة المستخدم إلى Firestore
      await FirebaseUtils.getYear( authProvider.currentUser?.id);

      // إنشاء الهيكلية (Year -> Month -> Week)
      String userId = credential.user!.uid;

      // رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration and hierarchy creation successful!')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('FirebaseAuthException: ${e.message}');
      }

      // عرض رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  void regiester() async {
    DataProvider dataProvider = Provider.of(context, listen: false);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      MyUser myuser = MyUser(
        name: nameController.text,
        id: credential.user!.uid,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        gender: _selectedGender,
        talent: talentController.text,
        university: universityController.text,
      );

      // إضافة المستخدم إلى Firestore
      var authProvider = Provider.of<AuthProviders>(context, listen: false);
      authProvider.changeUser(myuser);

      print("User created successfully");
      print("User ID: ${credential.user?.uid}");

      dataProvider.uid = credential.user!.uid;
      print("Stored UID: ${dataProvider.uid}");

      // إضافة المستخدم إلى Firestore
      await FirebaseUtils.addUser(myuser);

      // إضافة هيكلية (Year -> Month -> Week) بعد إنشاء المستخدم
      String userId = credential.user!.uid;
      int weekNumber = 1; // يمكنك تغيير هذا بناءً على الأسبوع الحالي


      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration and hierarchy creation successful!')),
      );

      // التوجيه إلى الشاشة الرئيسية بعد التسجيل
      Navigator.pushNamed(context, HomeScreenUsers.routeName);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }


  void regiesterr() async {



    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      MyUser myuser = MyUser(
        name: nameController.text.trim(),
        id: credential.user!.uid,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        gender: _selectedGender,
        talent: talentController.text.trim(),
        university: universityController.text.trim(),
      );

      // إضافة المستخدم إلى Firestore




      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User and structure created successfully!')),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      if (e.code == 'weak-password') {
        errorMessage = "Password is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Email is already in use.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

}


