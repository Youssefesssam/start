import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/modelUser.dart';
import 'firebase.dart';

class AuthProviders extends ChangeNotifier {
  MyUser? currentUser;
  List<MyUser> users=[
  ];
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

}