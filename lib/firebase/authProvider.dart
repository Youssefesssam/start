import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../model/modelUser.dart';
import '../model/modelUserAttend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProviders extends ChangeNotifier {
  MyUser? currentUser;
  int? week;
  int? weekUse;
  int? cheakweek;
  String? currentMonth;
  List<MyUser> users = [];
  List<User> usersAttend = [];
  List<int> absentWeek = [];
  List<Map<String, dynamic>> absentUsers = []; // تخزين الاسم + عدد مرات الغياب
  bool get isUserLoggedIn => currentUser != null;

  String? _sweetId;
  String? _wordId;
  String? _hiEventId;

  //current user data
  String? _userId;
  String? _profileURl;
  String? _name;
  String? _address;
  String? _phone;
  String? _email;

  /////////////////////////////////

  String? get userId => _userId;

  String? get profileURl => _profileURl;

  String? get name => _name;

  String? get address => _address;

  String? get phone => _phone;

  String? get email => _email;

  int? get currentWeek => week;

  int? get currentWeekUse => weekUse;

  String? get sweetId => _sweetId;

  String? get wordId => _wordId;

  String? get hiEventId => _hiEventId;

  void setWeekUse(int newWeek) {
    weekUse = newWeek;
    notifyListeners();
  }

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }


  void setWeek(int numweek) {
    weekUse = numweek;
    print('+++++++++++++ after weekUse  : $numweek -------------');
    notifyListeners();
  }



  void setCurrentWeek(int numweek) {
    print('+++++++++++++ before week داخل الشهر: $week -------------');

    week = ((numweek - 1) % 4) + 1;
    print('+++++++++++++ after week داخل الشهر: $week -------------');
    print('+++++++++++++ currentWeek داخل الشهر: $currentWeek -------------');
    notifyListeners();
  }


  void setCurrentMonth(int week) {
    print('+++++++++++++ before current Month داخل الشهر: $currentMonth -------------');

    int month = ((week - 1) ~/ 4) + 1;
    print('+++++++++++++ before current Month داخل الشهر: $month -------------');

    currentMonth = month.toString().padLeft(2, '0');
    print('month number: $currentMonth');
    print('week number: $week');
    notifyListeners();
  }



  void setUserName(String name) {
    _name = name;
    notifyListeners();
  }

  void setUserAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setUserEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setUserPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void setUserProfile(String url) {
    _profileURl = url;
    notifyListeners();
  }

  void setSweetId(String sweetId) {
    _sweetId = sweetId;
    notifyListeners();
  }

  void setwordId(String wordId) {
    _wordId = wordId;
    notifyListeners();
  }

  void sethiEventId(String hiEventId) {
    _hiEventId = hiEventId;
    notifyListeners();
  }

  SharedPreferences? sharedPreferences;

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
      QuerySnapshot<MyUser> querySnapshot = await FireBaseGetDataForLeader.getUser().get();
      users = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();
      notifyListeners(); // تحديث الـ UI
    } catch (e) {
      print("Error reading users: $e");
    }
  }

  void readUsersAttendToLeaders({required int numWeek}) {
    try {
      // مسح بيانات الأسبوع السابق
      usersAttend.clear();

      CollectionReference<User> attendCollection =
      FireBaseSetDataForLeader.getAttend(numWeek);

      attendCollection.snapshots().listen((querySnapshot) {
        usersAttend = querySnapshot.docs.map((doc) => doc.data()).toList();
        notifyListeners(); // تحديث الواجهة عند وصول بيانات جديدة
      }, onError: (e) {
        print("Error reading attendance: $e");
      });
    } catch (e) {
      print("Error setting up listener: $e");
    }
  }

  void calculateAbsentUsers(int currentWeek) async {
    try {
      Map<String, int> absenceCount = {};

      for (var user in users) {
        // إذا لم يكن هناك lackWeek، نعتبر أن المستخدم لم يفتقد من قبل
        if (user.lackWeek == null) continue;

        // نبدأ الحساب من الأسبوع التالي لآخر افتقاد
        int startWeek = user.lackWeek! + 1;

        // نتأكد أن startWeek ليس أكبر من currentWeek
        if (startWeek > currentWeek) continue;

        // عدد الأسابيع المطلوب حسابها
        int weeksToCalculate = currentWeek - startWeek + 1;

        // إذا لم يكن هناك أسابيع للحساب
        if (weeksToCalculate <= 0) continue;

        absenceCount[user.id] = 0; // نبدأ العد من الصفر لهذا المستخدم

        for (int week = startWeek; week <= currentWeek; week++) {
          CollectionReference<User> attendCollection = FireBaseSetDataForLeader.getAttend(week);
          QuerySnapshot<User> querySnapshot = await attendCollection.get();

          List presentUserIds = querySnapshot.docs.map((doc) => doc.data().id).toList();

          if (!presentUserIds.contains(user.id)) {
            absenceCount[user.id] = (absenceCount[user.id] ?? 0) + 1;
          }
        }

        // في حالة وجود غياب، نقوم بزيادة absencesSinceLack في Firestore

      }

      // تحديث البيانات فقط للمستخدمين الذين لديهم غيابات
      absentUsers = absenceCount.entries.where((entry) => entry.value > 0).map((entry) {
        MyUser user = users.firstWhere((u) => u.id == entry.key);

        FireBaseSetDataForLeader.addAbsent(
          id: user.id,
          name: user.name,
          absentCount: entry.value,
          email: user.email,
          address: user.address,
          phone: user.phone,
          profile: user.profileUrl,
          whatsapp: user.phone,
          lack: user.lack,
          lackWeek: currentWeek, // نحدث lackWeek إلى الأسبوع الحالي
          facebook: user.facebook,
        );

        return {
          "name": user.name,
          "absences": entry.value,
          "id": user.id,
          "profile": user.profileUrl,
          "email": user.email,
          "phone": user.phone,
          "address": user.address,
          "whatsapp": user.phone,
          "lack": user.lack,
          "lackWeek": currentWeek,
          "facebook": user.facebook,
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error calculating absences since last lack: $e");
    }
  }


  Stream<List<int>> streamAbsentTimes(int weekNum) {
    int cond = weekNum % 4;
    List<int> absentWeeks = [];

    if (cond == 1) {
      return FirebaseFirestore.instance
          .collection('numWeek')
          .doc(weekNum.toString())
          .collection("attend")
          .doc("5u0qEXBm0eaW7J0n5Y8VhF5WdBD2")
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists) {
          return [cond]; // ✅ إضافة الأسبوع إذا كان غائبًا
        } else {
          return []; // ✅ لا يوجد غياب
        }
      });
    } else {
      //هنا هو بيستنى كل التحديثات تيجى وبعدين يشتغل
      //asyncMap دى كل فكرتها انها بتستنى تحميل الداتا كلها
      return FirebaseFirestore.instance
          .collection('numWeek')
          .snapshots()
          .asyncMap((querySnapshot) async {
        absentWeeks.clear();

        for (int i = 1; i <= (cond == 0 ? 4 : cond); i++) {
          DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('numWeek')
              .doc(i.toString())
              .collection("attend")
              .doc("5u0qEXBm0eaW7J0n5Y8VhF5WdBD2")
              .get();

          if (!snapshot.exists) {
            absentWeeks.add(i); // ✅ إضافة الأسبوع إذا كان غائبًا
          }
        }
        return absentWeeks;
      });
    }
  }

  Future<void> setDataForUser(
      String name,
      String email,
      String talent,
      String university,
      String phone,
      String gender,
      String profile,
      String password,
      ) async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences == null) {
      print("Error: sharedPreferences is null");
      return;
    }

    await sharedPreferences!.setString("name", name);
    await sharedPreferences!.setString("email", email);
    await sharedPreferences!.setString("talent", talent);
    await sharedPreferences!.setString("university", university);
    await sharedPreferences!.setString("phone", phone);
    await sharedPreferences!.setString("gender", gender);
    await sharedPreferences!.setString("profile", profile);
    await sharedPreferences!.setString("password", password);

    print("✅ بيانات المستخدم تم تخزينها في SharedPreferences");
  }
}