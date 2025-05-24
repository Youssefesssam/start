import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import 'package:star_t/firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import 'package:star_t/utilites/appAssets.dart';

import '../../../../../firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../firebase/fireBase/fireBaseForUser/fireBaseGetDataForUser.dart';
import '../../../../../model/modelEvent.dart';
import '../../../../../utilites/appTexts.dart';

class Event extends StatefulWidget {
  Event({super.key});

  @override
  State<Event> createState() => _Event();
}

class _Event extends State<Event> {
  String? imageUrl;
  bool? eventExists;
  bool isUploading = false; // متغير للتحكم في تحميل الصورة
  double blurValue = 0;
  bool _isExpanded = false;

// متغير للتحكم في قوة التمويه
  TextEditingController textEvent = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkEventExistence();
  }

  Future<void> checkEventExistence() async {
    bool exists = await FireBaseGetDataForLeader.eventExist();
    setState(() {
      eventExists = exists;
    });
  }

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
            padding: const EdgeInsets.all(10),
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

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hi.Event!",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.event, size: 30, color: Colors.blue[800]),
                      Spacer(),
                      // إخفاء الأيقونة أثناء التحميل
                      Visibility(
                        visible: !isUploading,
                        // إظهار الأيقونة فقط عندما لا يكون التحميل جاريًا
                        child: InkWell(
                          onTap: uploadImage,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // تحميل بيانات الحدث
                eventExists == null
                    ? Center(child: CircularProgressIndicator())
                    : eventExists!
                        ?  Container(
                  margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Container(
                            margin: EdgeInsets.all(15),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection(ModelHiEvent.collection)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    var docs = snapshot.data!.docs;
                                    String? imageUrl;

                                    // التحقق من وجود بيانات والتحقق من وجود الصورة
                                    if (docs.isNotEmpty &&
                                        docs.first.data() != null) {
                                      var data = docs.first.data()
                                          as Map<String, dynamic>;
                                      imageUrl = data.containsKey('image')
                                          ? data['image'] as String?
                                          : null;
                                    }

                                    return Container(
                                      margin: EdgeInsets.all(15),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: imageUrl != null &&
                                                imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    AppAssets.nothing,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .45,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                AppAssets.nothing,
                                                fit: BoxFit.fitWidth,
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .45,
                                              ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15,bottom: 15),

                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection(ModelHiEvent.collection)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      var docs = snapshot.data!.docs;
                                      String lastMessage = docs.isNotEmpty
                                          ? docs.first['hiEvent'] ??
                                              ""
                                          : "";

                                      return Builder(
                                        builder: (context) {
                                          bool isLongText =
                                              lastMessage.length > 100;
                                          String displayText = isLongText
                                              ? (_isExpanded
                                                  ? lastMessage
                                                  : lastMessage.substring(
                                                          0, 100) +
                                                      "...")
                                              : lastMessage;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(text: displayText),
                                                    if (isLongText)
                                                      TextSpan(
                                                        text: _isExpanded
                                                            ? " Less"
                                                            : "More",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.blue[800],
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                setState(() {
                                                                  _isExpanded =
                                                                      !_isExpanded;
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
                                ),
                                SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: SlideAction(
                                    innerColor: Colors.white,
                                    outerColor: Colors.red[600],
                                    elevation: 10,
                                    textColor: Colors.white,
                                    sliderButtonIconSize: 10,
                                    sliderButtonIconPadding: 8,
                                    sliderButtonIcon: Icon(Icons.delete,
                                        size: 20, color: Colors.red),
                                    submittedIcon: Icon(Icons.check,
                                        size: 30, color: Colors.white),
                                    onSubmit: () {
                                      FireBaseGetDataForLeader.deleteEvent();
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        "Delete",
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                ): Column(
                            children: [
                              // إضافة عنصر قبل الصورة
                              if (imageUrl == null)
                                Center(
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: isUploading
                                        ? Center(
                                            child:Text('Loding...!',style: TextStyle( color: Colors.blue,fontSize: 20),)
                                          )
                                        : Center(
                                            child: Text(
                                              "No Image Uploaded",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              if (imageUrl != null)
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 10, end: blurValue),
                                  duration: Duration(seconds: 2),
                                  builder: (context, value, child) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        children: [
                                          // الصورة
                                          Image.network(
                                            imageUrl!,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context).size.width,
                                            height:  MediaQuery.of(context).size.height*.55,
                                          ),

                                          // التمويه
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
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.blue[800],
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

                              TextField(
                                controller: textEvent,
                                maxLines: 3,
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

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: SlideAction(
                                      innerColor: Colors.white,
                                      outerColor: Colors.red[600],
                                      elevation: 10,
                                      textColor: Colors.white,
                                      sliderButtonIconSize: 10,
                                      sliderButtonIconPadding: 8,
                                      animationDuration:
                                          Duration(milliseconds: 750),
                                      sliderButtonIcon: Icon(
                                          Icons.exit_to_app_outlined,
                                          size: 20,
                                          color: Colors.red),
                                      submittedIcon: Icon(Icons.check,
                                          size: 30, color: Colors.white),
                                      onSubmit: () {
                                        Navigator.pop(context);
                                      },
                                      child: Center(
                                        child: Text(
                                          "Exit",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: SlideAction(
                                      innerColor: Colors.white,
                                      outerColor: Colors.blue[800],
                                      elevation: 10,
                                      textColor: Colors.white,
                                      sliderButtonIconSize: 10,
                                      sliderButtonIconPadding: 8,
                                      sliderButtonIcon: Icon(Icons.send,
                                          size: 20, color: Colors.blue[800]),
                                      submittedIcon: Icon(Icons.check,
                                          size: 30, color: Colors.white),
                                      onSubmit: () async {
                                        if (imageUrl != null) {
                                          await FireBaseSetDataForLeader
                                              .saveImageUrlToFirestore(
                                                  imageUrl!);
                                        }
                                        FireBaseSetDataForLeader.HiEventSet(
                                            hiEvent: textEvent.text);
                                        AppTexts.fristSeenEvent(true);

                                        Navigator.pop(context);
                                      },
                                      child: Center(
                                        child: Text(
                                          "Share",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
