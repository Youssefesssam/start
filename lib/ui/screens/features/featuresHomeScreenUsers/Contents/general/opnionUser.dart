import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';

class OpinionUser extends StatelessWidget {
  OpinionUser({super.key});
  final TextEditingController opinion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // خط السحب
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Write Your Opinion",
                      style: GoogleFonts.abyssinicaSil(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.favorite,
                      size: 20,
                      color: Colors.blue[700],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // صورة رمزية لحدث
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height*.12,
                    width: MediaQuery.of(context).size.width*.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue[300]!, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.event,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // حقل إدخال النص
                TextField(
                  controller: opinion,
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Type your opinion here...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.poppins(
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 40),

                // أزرار المشاركة والخروج
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: SlideAction(
                        innerColor: Colors.white,
                        outerColor: Color(0xffd32f2f), // تغيير اللون الأحمر إلى أحمر أغمق
                        elevation: 10,
                        textColor: Colors.white,
                        sliderButtonIconSize: 10,
                        sliderButtonIconPadding: 8,
                        animationDuration: Duration( milliseconds: 200),

                        sliderButtonIcon: Icon(Icons.exit_to_app, size: 25, color: Color(0xffd32f2f)),
                        submittedIcon: Icon(Icons.check, size: 30, color: Colors.white),
                        key: GlobalKey<SlideActionState>(),
                        onSubmit: () {
                          Future.delayed(const Duration(seconds: 1), () {
                             Navigator.pop(context);

                          }
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              "Exit",  // تصحيح التسمية إلى Exit
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: SlideAction(
                        innerColor: Colors.white,
                        outerColor: Colors.blue,
                        elevation: 10,
                        textColor: Colors.white,
                        sliderButtonIconSize: 10,
                        sliderButtonIconPadding: 8,
                        animationDuration: Duration( milliseconds: 450),
                        sliderButtonIcon: Icon(Icons.send, size: 20, color: Colors.blue),
                        submittedIcon: Icon(Icons.check, size: 30, color: Colors.white),
                        key: GlobalKey<SlideActionState>(),
                        onSubmit: () async { // أضف async هنا
                          await FireBaseSetDataForUser.addOpinionUser(opinion.text, "5u0qEXBm0eaW7J0n5Y8VhF5WdBD2"); // استخدم await
                          opinion.clear(); // مسح النص بعد اكتمال العملية
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              "Share",
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
