import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import 'package:star_t/ui/screens/auth/loginScreen/loginScreen.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import '../../../../model/modelUser.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  String? selectedTalent;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String university = "";
  String phone = "";
  String whatsapp = "";
  String? gender;
  String address = "";
  String code = "";
  String facebook = "";
  String birthDay = "";
  bool isUploading = false; // متغير للتحكم في تحميل الصورة
  double blurValue = 0;
  String? imageUrl;
  String? userId;

  TextEditingController emailController = TextEditingController();
  Future<void> uploadImage() async {
    setState(() {
      isUploading = true; // بدء تحميل الصورة
      blurValue = 10; // بدء التمويه
    });

    String? uploadedImageUrl = await FireBaseGetDataForLeader.uploadImageToImgBB();

    setState(() {
      isUploading = false; // انتهاء التحميل
      if (uploadedImageUrl != null) {
        imageUrl = uploadedImageUrl;
        // إزالة التمويه تدريجيًا بعد تأخير
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            blurValue = 0; // إزالة التمويه
          });
        });
      }
    });
  }

  void _nextStep() {
    if (formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _registerUser() async {
    try {
      String emailToUse = emailController.text.trim();
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailToUse,
        password: password,
      );

      // حفظ الـ ID في المتغير
      setState(() {
        userId = userCredential.user!.uid;
      });

      MyUser myUser = MyUser(
          name: "$firstName $lastName",
          id: userId!, // استخدام المتغير هنا
          email: emailToUse,
          phone: phone,
          address: address,
          gender: gender!,
          talent: selectedTalent!,
          university: university,
          profileUrl: "",
          code: code,
          rank: 0,
          lack: 0,
          lackWeek: 0,
          facebook:facebook ,
          whatsapp: whatsapp,
          birthDay: birthDay
      );

      await FireBaseSetDataForLeader.addUser(myUser);

      print("User ID: $userId"); // للتأكد من وجود القيمة

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم التسجيل بنجاح!"),
          backgroundColor: Colors.green,
        ),
      );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء التسجيل: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
          Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 30, left: 16, right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.appBarColor,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade800.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          "Create Account",
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
                    const SizedBox(height: 0),
                    // Animated Stepper
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: EasyStepper(
                        activeStep: _currentStep,
                        stepRadius: MediaQuery.of(context).size.width*.05,
                        activeStepBorderColor: Colors.white,
                        finishedStepBorderColor: Colors.white,
                        unreachedStepTextColor: Colors.white.withOpacity(0.7),
                        unreachedStepIconColor: Colors.white.withOpacity(0.7),
                        unreachedStepBorderColor: Colors.white.withOpacity(0.3),
                        activeStepBackgroundColor: Colors.teal.shade700,
                        finishedStepBackgroundColor: Colors.teal.shade400,
                        activeStepTextColor: Colors.white,
                        finishedStepTextColor: Colors.white,
                        activeStepIconColor: Colors.white,
                        finishedStepIconColor: Colors.white,
                        borderThickness: 2,
                        padding: EdgeInsets.all(8),
                        stepShape: StepShape.rRectangle,
                        stepBorderRadius: 20,

                        steps: const [
                          EasyStep(
                            enabled: false,
                            title: "Basic Info",
                            icon: Icon(Icons.person_outline),
                          ),
                          EasyStep(
                            enabled: false,
                            title: "Details",
                            icon: Icon(Icons.assignment_outlined),
                          ),
                          EasyStep(
                            enabled: false,
                            title: "More detals",
                            icon: Icon(Icons.assignment_outlined),
                          ),
                          EasyStep(
                            enabled: false,
                            title: "Profile",
                            icon: Icon(Icons.camera_alt_outlined),
                          ),
                        ],
                        onStepReached: (index) {
                          setState(() => _currentStep = index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Form Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axis: Axis.vertical,
                                child: child,
                              ),
                            );
                          },
                          child: IndexedStack(
                            key: ValueKey<int>(_currentStep),
                            index: _currentStep,
                            children: [
                              _buildStepOne(),
                              _buildStepTwo(),
                              _buildStepThree(),
                              _buildStepFour(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Navigation Buttons - تم التعديل هنا
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if(_currentStep==2){
                                await _registerUser();
                                print("$userId");
                              }
                              if (_currentStep == 3) {
                                if (imageUrl != null) {
                                  await FireBaseSetDataForUser
                                      .saveProfileUrlToFirestore(imageUrl:imageUrl!,userId:userId!);
                                }
                                Navigator.pushNamed(context, LoginScreen.routeName);
                              } else {
                                _nextStep();
                              }
                            },

                            child: Text(
                              _currentStep == 3? "Register" : "Next",
                              style: TextStyle(fontSize: 16,color: AppColors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.teal.shade600,
                            ),
                          ),

                          if (_currentStep != 0)
                            ElevatedButton(
                              onPressed: _previousStep,
                              child: Text(
                                "Back",
                                style: TextStyle(fontSize: 16,color: AppColors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade400,
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                shadowColor: Colors.teal.shade300,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildStepOne() {
    return Form(
      key: formKeys[0],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _buildStepContainer([
          SizedBox(height: 15),
          Text(
            "Basic Information",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildTextFieldWithIcon(
            "First Name",
            Icons.person_outline,
                (value) => firstName = value,
          ),
          const SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "Last Name",
            Icons.person_outline,
                (value) => lastName = value,
          ),
          const SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "Email",
            Icons.email_outlined,
                (value) => email = value,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "Password",
            Icons.lock_outline,
                (value) => password = value,
            obscure: true,
          ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }
  Widget _buildStepTwo() {
    return Form(
      key: formKeys[1],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _buildStepContainer([
          SizedBox(height: 15),
          Text(
            "Additional Details",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildTalentDropdown(),
          SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "University",
            Icons.school_outlined,
                (value) => university = value,
          ),
          SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "Birth Day",
            Icons.date_range_outlined,
                (value) => birthDay = value,
          ),
          SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "Phone Number",
            Icons.phone_outlined,
                (value) => phone = value,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20),
          _buildGenderDropdown(),
          SizedBox(height: 30),
        ]),
      ),
    );
  }
  Widget _buildStepThree() {
    return Form(
      key: formKeys[2],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _buildStepContainer([
          SizedBox(height: 15),
          Text(
            "more Information",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildTextFieldWithIcon(
            "Address",
            hintText: "detals for address",
            Icons.home_filled,
                (value) => address = value,
          ),
          SizedBox(height: 30),

          _buildTextFieldWithIcon(
            "Facebook",
            hintText: "facebook url",
            Icons.facebook,
                (value) => facebook = value,
          ),
          SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "ًWahtsapp",
            Icons.phone_android_rounded,
                (value) => whatsapp = value,
          ),
          SizedBox(height: 20),
          _buildTextFieldWithIcon(
            "Code Number",
            Icons.confirmation_num_outlined,
                (value) => code = value,
          ),

          SizedBox(height: 30),
        ]),
      ),
    );
  }
  Widget _buildStepFour() {
    return Form(
      key: formKeys[3],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _buildStepContainer([
          SizedBox(height: 15),
          Text(
            "Profile Picture",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                // إضافة عنصر قبل الصورة
                if (imageUrl == null)
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey[200],
                    child: isUploading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                      ),
                    )
                        : Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[600],
                    ),
                  ),
                if (imageUrl != null)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 10, end: isUploading ? 10 : 0),  // البلور يظهر فقط أثناء التحميل
                    duration: Duration(seconds: 2),
                    builder: (context, value, child) {
                      return CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(imageUrl!),
                        child: Stack(
                          children: [
                            // التمويه أثناء التحميل
                            if (isUploading)
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: value,
                                  sigmaY: value,
                                ),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),

                            // Loader أثناء التحميل
                            if (isUploading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.2),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              uploadImage(); // ✅ استدعاء الفانكشن لو المستخدم ضغط على الزرار ده
            },
            icon: Icon(Icons.upload_outlined),
            label: Text(
              "Upload Profile Picture",
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade400,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: Colors.teal.shade300,
            ),
          ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }
  Widget _buildTextFieldWithIcon(
      String label,
      IconData icon,
      Function(String) onChanged, {
        TextEditingController? controller,
        bool obscure = false,
        TextInputType keyboardType = TextInputType.text,
        String? hintText, // إضافة هذا المتغير
      }) {
    return TextFormField(
      validator: (value){
        if (value == null || value.trim().isEmpty) {
          return "This field required";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal.shade600),
        floatingLabelStyle: TextStyle(color: Colors.teal.shade700),
        prefixIcon: Icon(icon, color: Colors.teal.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: hintText, // استخدام hintText هنا
        hintStyle: TextStyle(color: Colors.grey.shade500), // إضافة نمط للنص التوضيحي
      ),
      style: TextStyle(color: Colors.black87, fontSize: 16),
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }


  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: gender,
      decoration: InputDecoration(
        labelText: "Gender",
        labelStyle: TextStyle(color: Colors.teal.shade600),
        floatingLabelStyle: TextStyle(color: Colors.teal.shade700),
        prefixIcon: Icon(Icons.transgender, color: Colors.teal.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(
          value: "male",
          child: Text("Male", style: TextStyle(color: Colors.black87)),
        ),
        DropdownMenuItem(
          value: "female",
          child: Text("Female", style: TextStyle(color: Colors.black87)),
        ),
      ],
      onChanged: (value) => setState(() => gender = value!),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.teal.shade500),
    );
  }

  Widget _buildTalentDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedTalent,
      decoration: InputDecoration(
        labelText: 'selectTalent',
        labelStyle: TextStyle(color: Colors.teal.shade600),
        floatingLabelStyle: TextStyle(color: Colors.teal.shade700),
        prefixIcon: Icon(Icons.star, color: Colors.teal.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: "الترتيل / الإنشاد", child: Text("الترتيل / الإنشاد")),
        DropdownMenuItem(value: "العزف على آلة موسيقية", child: Text("العزف على آلة موسيقية")),
        DropdownMenuItem(value: "التمثيل المسرحي", child: Text("التمثيل المسرحي")),
        DropdownMenuItem(value: "الإخراج / التصوير", child: Text("الإخراج / التصوير")),
        DropdownMenuItem(value: "التصميم الجرافيكي", child: Text("التصميم الجرافيكي")),
        DropdownMenuItem(value: "الكتابة الإبداعية", child: Text("الكتابة الإبداعية")),
        DropdownMenuItem(value: "الترجمة", child: Text("الترجمة")),
        DropdownMenuItem(value: "التقديم / الإلقاء", child: Text("التقديم / الإلقاء")),
        DropdownMenuItem(value: "المونتاج", child: Text("المونتاج")),
        DropdownMenuItem(value: "البرمجة", child: Text("البرمجة")),
        DropdownMenuItem(value: "العمل الفني", child: Text("العمل الفني")),
        DropdownMenuItem(value: "التنظيم والإدارة", child: Text("التنظيم والإدارة")),
        DropdownMenuItem(value: "التعليم والتدريب", child: Text("التعليم والتدريب")),
        DropdownMenuItem(value: "التسويق الرقمي", child: Text("التسويق الرقمي")),
        DropdownMenuItem(value: "الطهي", child: Text("الطهي")),
        DropdownMenuItem(value: "الخط العربي", child: Text("الخط العربي")),
        DropdownMenuItem(value: "الترجمة الفورية", child: Text("الترجمة الفورية")),
        DropdownMenuItem(value: "الإبداع في التواصل", child: Text("الإبداع في التواصل")),
        DropdownMenuItem(value: "الإلقاء الشعري", child: Text("الإلقاء الشعري")),
        DropdownMenuItem(value: "التصوير الفوتوغرافي", child: Text("التصوير الفوتوغرافي")),
        DropdownMenuItem(value: "وسائل التواصل الاجتماعي", child: Text("وسائل التواصل الاجتماعي")),
        DropdownMenuItem(value: "إصلاح وصيانة الأجهزة", child: Text("إصلاح وصيانة الأجهزة")),
        DropdownMenuItem(value: "خدمة الآخرين", child: Text("خدمة الآخرين")),
        DropdownMenuItem(value: "التوجيه والإرشاد", child: Text("التوجيه والإرشاد")),
        DropdownMenuItem(value: "أخرى", child: Text("أخرى")),
      ],
      onChanged: (value) => setState(() => selectedTalent = value!),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.teal.shade500),
    );
  }


  Widget _buildStepContainer(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}