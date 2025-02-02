import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:star_t/firebase/firebase.dart';

class WordUser extends StatelessWidget {
  const WordUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal[50]!, Colors.white],
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
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  " the word that will be said next week",
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseUtils.fetchMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator()); // عرض مؤشر تحميل
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Text(' wrong: ${snapshot.error}')); // عرض الخطأ
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('no messages')); // إذا لم توجد بيانات
                    }

                    final messages = snapshot.data!.docs;

                    return Column(
                      children: [
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
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mail_outline_sharp,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.24,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const RangeMaintainingScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final text = message['message']; // نص الرسالة
                              final sender = message['sender']; // اسم المرسل
                              final timestamp = message['Time']; // وقت الرسالة
                              return Center(
                                child: ListTile(
                                  title: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: MediaQuery.of(context).size.height*.065,),
                                        Text(
                                          text,
                                          style: GoogleFonts.abyssinicaSil(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .11,
                  width: MediaQuery.of(context).size.width * .7,
                  child: Center(child: Builder(
                    builder: (context) {
                      final GlobalKey<SlideActionState> _key = GlobalKey();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SlideAction(
                          innerColor: Colors.white,
                          sliderButtonIconPadding: 10,
                          sliderButtonIcon: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.teal,
                          ),
                          submittedIcon: const Icon(
                            Icons.favorite,
                            size: 50,
                            color: Colors.white,
                          ),
                          outerColor: Colors.teal,
                          enabled: true,
                          elevation: 12,
                          textColor: Colors.white,
                          sliderRotate: true,
                          height: 80,
                          key: _key,
                          onSubmit: () {
                            Future.delayed(
                              const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                            );
                          },
                          child: Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                child: Text(
                                  "Seen",
                                  style: GoogleFonts.aboreto(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
