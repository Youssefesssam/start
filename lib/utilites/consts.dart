import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Consts{
  static String? path;
  static Future<String?> getName()async{
    final prefs = await SharedPreferences.getInstance();
    String? testName = prefs.getString("name");
    return testName;
  }
  static Future<String?> getEmail()async{
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    return email;
  }
  static Future<String?> getPhone()async{
    final prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString("phone");
    return phone;
  }
  static Future<String?> getTalent()async{
    final prefs = await SharedPreferences.getInstance();
    String? talent = prefs.getString("talent");
    return talent;
  }
  static Future<String?> getUniversity()async{
    final prefs = await SharedPreferences.getInstance();
    String? university = prefs.getString("university");
    return university;
  }
  static Future<String?> getGender()async{
    final prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString("gender");
    return gender;
  }
  static Future<String?> getProfile()async{
    final prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString("profileUrl");
    return profile;
  }
  static Future<String?> getUserId()async{
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    return userId;
  }
  static Future<String?> getSweetTalkId()async{
    final prefs = await SharedPreferences.getInstance();
    String? sweetId = prefs.getString("sweetId");
    return sweetId;
  }
  static Future<String?>getHiEventId()async{
    final prefs = await SharedPreferences.getInstance();
    String? hiEventId = prefs.getString("hiEventId");
    return hiEventId;
  }
  static Future<String?>getWordId()async{
    final prefs = await SharedPreferences.getInstance();
    String? wordId = prefs.getString("wordId");
    return wordId;
  }
  static Future<String?>getScore()async{
    final prefs = await SharedPreferences.getInstance();
    String? score = prefs.getString("score");
    return score;
  }

  static Widget fetcher(Future<String?> function ,TextStyle style){
    return FutureBuilder<String?>(
      future: function, // استدعاء الدالة التي تجلب الاسم
      builder: (context, snapshot) {
        return snapshot.hasData? Text(
            snapshot.data!, // عرض الاسم المخزن
            style: style
        ):Text(
        "", // عرض الاسم المخزن
        style: style
        );
      },
    );
  }
  static Future<void> pathImg()async{
    path = await Consts.getProfile();
  }
}