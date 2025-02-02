import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/modelUser.dart';
import '../model/modelUserAttend.dart';
import 'firebase.dart';

class AuthProviders extends ChangeNotifier {
  MyUser? currentUser;
  List<MyUser> users=[];
  List<User> usersAttend=[];
  bool get isUserLoggedIn => currentUser != null;


  void changeUser(MyUser newUser) {
    if (newUser.id.isEmpty) {
      print("Error: newUser ID is empty");
      return;
    }
    currentUser = newUser;
    print("Changed current user to: ${currentUser?.name}");
    readUsersToLeaders();
    notifyListeners();
  }

  void readUsersToLeaders() async {
    try {
      QuerySnapshot<MyUser> querySnapshot = await FirebaseUtils.getUser().get();
      users = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();
      notifyListeners(); // تحديث الـ UI
    } catch (e) {
      print("Error reading users: $e");
    }

  }
  void readUsersAttendToLeaders({required int numWeek}) async {
    try {
      print('🔍 Fetching attendance data for week: $numWeek');

      // **مسح بيانات الأسبوع السابق**
      usersAttend.clear();

      CollectionReference<User> attendCollection = FirebaseUtils.getAttend(numWeek);
      QuerySnapshot<User> querySnapshot = await attendCollection.get();

      if (querySnapshot.docs.isEmpty) {
        print("⚠️ No attendance data found for week $numWeek");
      } else {
        usersAttend = querySnapshot.docs.map((doc) => doc.data()).toList();
        print("✅ Fetched ${usersAttend.length} attendance records.");
      }

      notifyListeners(); // تحديث الواجهة
    } catch (e) {
      print("❌ Error reading attendance: $e");
    }
  }


}