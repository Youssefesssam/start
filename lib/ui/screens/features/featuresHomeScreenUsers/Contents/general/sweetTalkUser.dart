import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:star_t/utilites/appAssets.dart';
import '../../../../../../model/modelSweetTalk.dart';

class SweetTalkUser extends StatefulWidget {
  SweetTalkUser({super.key});

  @override
  _SweetTalkUserState createState() => _SweetTalkUserState();
}

class _SweetTalkUserState extends State<SweetTalkUser> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
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
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sweet talk",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.favorite,color: Colors.teal,)
                  ],
                ),
                const SizedBox(height: 15),
                // Event Card
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Info
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 30,
                          ),
                          const SizedBox(width: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Youssef Essam",
                                style: GoogleFonts.poppins(
                                  color: Colors.teal[700],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),

                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Event Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          AppAssets.profile, // Replace with your image asset
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .45,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.favorite, size: 30, color: Colors.red),
                          SizedBox(width: 10),
                          Icon(Icons.mode_comment_rounded, size: 30, color: Colors.grey[500]),

                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection(ModelSweetTalk.collection).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator(color: Colors.teal));
                          }
                          var docs = snapshot.data!.docs;
                          String lastMessage = docs.isNotEmpty ? docs.first['talk'] : "No words yet";

                          return Builder(
                            builder: (context) {
                              bool isLongText = lastMessage.length > 100;
                              String displayText = isLongText
                                  ? (_isExpanded ? lastMessage : lastMessage.substring(0, 100) + "...")
                                  : lastMessage;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 18, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: displayText,
                                        ),
                                        if (isLongText)
                                          TextSpan(
                                            text: _isExpanded ? " Less" : " More",
                                            style: GoogleFonts.poppins(
                                              color: Colors.teal,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setState(() {
                                                  _isExpanded = !_isExpanded;
                                                });
                                              },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
