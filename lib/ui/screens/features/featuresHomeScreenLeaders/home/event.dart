import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:star_t/firebase/firebase.dart';

class Event extends StatelessWidget {
  Event({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEvent =TextEditingController();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal[100]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // خط السحب
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // العنوان مع الأيقونة
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Hi.Event!",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.celebration,
                      size: 30,
                      color: Colors.teal[700],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // صورة رمزية لحدث
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.teal[300]!, Colors.teal[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.event,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // إدخال النص
                TextField(
                  controller: textEvent,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Type your message...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 25),

                // صف الأزرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // أضف خاصية تحميل الصورة
                      },
                      icon: const Icon(Icons.image, size: 20),
                      label: Text(
                        "Add Image",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        backgroundColor: Colors.teal[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // أزرار المشاركة والخروج
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 180,
                      child: SlideAction(
                        innerColor: Colors.white,
                        outerColor: Colors.red[600],
                        elevation: 10,
                        textColor: Colors.white,
                        sliderButtonIconSize: 10,
                        sliderButtonIconPadding: 12,
                        sliderButtonIcon: Icon(Icons.delete, size: 20, color: Colors.red),
                        submittedIcon: Icon(Icons.check, size: 30, color: Colors.white),
                        key: GlobalKey<SlideActionState>(),
                        onSubmit: () {
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.pop(context);
                          });
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
                      height: 60,
                      width: 180,
                      child: SlideAction(
                        innerColor: Colors.white,
                        outerColor: Colors.teal,
                        elevation: 10,
                        textColor: Colors.white,
                        sliderButtonIconSize: 10,
                        sliderButtonIconPadding: 12,
                        sliderButtonIcon: Icon(Icons.send, size: 20, color: Colors.teal),
                        submittedIcon: Icon(Icons.check, size: 30, color: Colors.white),
                        key: GlobalKey<SlideActionState>(),
                        onSubmit: () {
                         FirebaseUtils.HiEventSet( hiEvent:textEvent.text);
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
