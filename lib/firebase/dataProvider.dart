import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:star_t/model/modelData.dart';
import 'package:star_t/model/modelYear.dart';
import 'package:star_t/model/modelweek.dart';

import '../model/modelUser.dart';

class DataProvider extends ChangeNotifier {

  ModelData? infoUser;
  late String uid;



  // دالة جلب البيانات من Firebase
  Future<void> getDataFromFirebase(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(MyUser.collection) // اسم المجموعة الرئيسية
          .doc(userId) // الوثيقة الخاصة بالمستخدم
          .collection(ModelData.collection) // المجموعة الفرعية
          .doc(userId) // الوثيقة داخل المجموعة الفرعية
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        infoUser = ModelData.fromJson(userData);
        notifyListeners(); // تحديث واجهة المستخدم
      } else {
        print("Fetching data for userId: $userId");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  List<Map<String, dynamic>> dataList = []; // لتخزين البيانات المسترجعة

// تعديل retrieveOnce لتخزين البيانات في dataList
  void retrieveOnce() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(MyUser.collection).get();

      dataList.clear(); // مسح البيانات القديمة
      snapshot.docs.forEach((element) {
        dataList.add(element.data() as Map<String, dynamic>);
      });

      print("Data retrieved successfully: $dataList");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void retriveSubCol(String userId) async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(MyUser.collection).get();

      dataList.clear(); // مسح البيانات القديمة
      for (var element in snapshot.docs) {
        // استخراج البيانات من المجموعات الفرعية
        QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(userId)
            .collection(ModelYear.collection)
            .get();

        for (var subElement in subCollectionSnapshot.docs) {
          var subData = subElement.data() as Map<String, dynamic>;
          dataList.add(subData);
        }
      }

      print("Sub-collection data retrieved: $dataList");
    } catch (e) {
      print("Error fetching sub-collection data: $e");
    }
  }


  List<int> scoresList = [];
  void retrieveScoresById(String uid) async {
    try {
      // استرجاع الوثائق من المجموعة الفرعية بناءً على UID
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .doc(uid) // الوثيقة الرئيسية بناءً على UID
          .collection(ModelYear.collection) // المجموعة الفرعية
          .get();


      snapshot.docs.forEach((element) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        if (data.containsKey('TotalScoreOfYear')) { // التأكد من وجود الحقل score
          scoresList.add(data['TotalScoreOfYear']); // إضافة قيمة score إلى المصفوفة
        }
      });

      print("Scores retrieved for UID $uid: $scoresList");
    } catch (e) {
      print("Error fetching scores for UID $uid: $e");
    }
  }



  int massScore = 0;
  int communionScore = 0;
  int confessionScore = 0;
  int meetingScore = 0;
  int score = 0;

  Future<void> onlyAtrbute(String userId) async {
    print(userId);
    try {
      // استخدام userId لاسترجاع بيانات المستخدم المحدد
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .doc(userId) // استرجاع البيانات الخاصة بالـ userId
          .get();

      if (snapshot.exists) {
        // إذا كان المستند موجودًا، استرجاع البيانات
        CollectionReference subCollectionRef = FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(userId) // استخدام userId
            .collection(ModelYear.collection);

        QuerySnapshot subSnapshot = await subCollectionRef.get();

        if (subSnapshot.docs.isNotEmpty) {
          var subData = subSnapshot.docs.first.data() as Map<String, dynamic>;

          massScore = subData['massScore'] ?? 0;
          communionScore = subData['communionScore'] ?? 0;
          confessionScore = subData['confessionScore'] ?? 0;
          meetingScore = subData['meetingScore'] ?? 0;
          score = subData['score'] ?? 0;

          print('User ID: $userId');
          print('Mass Score: $massScore');
          print('Communion Score: $communionScore');
          print('Confession Score: $confessionScore');
          print('Meeting Score: $meetingScore');
          print('Total Score: $score');

          // تحديث واجهة المستخدم
          notifyListeners();
        } else {
          print("No sub-collection data found.");
        }
      } else {
        print("No data found for user with ID: $userId");
      }
    } catch (e) {
      print("Error fetching sub-collection data: $e");
    }
    notifyListeners();
  }

  void tina(String userId) async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(MyUser.collection).get();

      dataList.clear(); // مسح البيانات القديمة
      for (var element in snapshot.docs) {
        // استخراج البيانات من المجموعات الفرعية
        QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(userId)
            .collection(ModelYear.collection).orderBy('TotalScoreOfYear',descending: true)
            .get();

        for (var subElement in subCollectionSnapshot.docs) {
          var subData = subElement.data() as Map<String, dynamic>;
          dataList.add(subData);
        }
      }

      print("Sub-collection data retrieved: $dataList");
    } catch (e) {
      print("Error fetching sub-collection data: $e");
    }
  }

  List<String> idList = []; // لتخزين البيانات المسترجعة
  void retrieveid() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(MyUser.collection).get();

      dataList.clear(); // مسح البيانات القديمة
      // مصفوفة لتخزين الـ IDs

      snapshot.docs.forEach((element) {
        dataList.add(element.data() as Map<String, dynamic>);
        idList.add(element.id); // إضافة الـ ID إلى المصفوفة
      });

      print("Data retrieved successfully: $dataList");
      print("Document IDs: $idList");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }



  void retrieveIdByScore() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .orderBy('TotalScoreOfYear', descending: true) // الترتيب حسب الـ score تنازليًا
          .get();

      dataList.clear(); // مسح البيانات القديمة
      List<String> idList = []; // مصفوفة لتخزين الـ IDs

      snapshot.docs.forEach((element) {
        dataList.add(element.data() as Map<String, dynamic>);
        idList.add(element.id); // إضافة الـ ID إلى المصفوفة
      });

      print("Data retrieved and sorted by score: $dataList");
      print("Sorted Document IDs: $idList");
    } catch (e) {
      print("Error fetching and sorting data: $e");
    }
  }

  Future<void> retrieveAndSortUsersByScores() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .get();

      List<Map<String, dynamic>> usersData = [];

      // اجلب بيانات المستخدمين ومجموعاتهم الفرعية
      for (var userDoc in snapshot.docs) {
        String uid = userDoc.id;
        var userData = userDoc.data() as Map<String, dynamic>;

        QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(uid)
            .collection(ModelYear.collection)
            .get();

        // جمع جميع الأسكور
        int totalScore = subCollectionSnapshot.docs.fold(0, (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          final score = (data['TotalScoreOfYear'] ?? 0) as int;
          return sum + score;      });

        // إضافة بيانات المستخدم والمجموع الإجمالي
        userData['TotalScoreOfYear'] = totalScore;
        usersData.add(userData);
      }

      // ترتيب البيانات
      usersData.sort((a, b) => b['TotalScoreOfYear'].compareTo(a['TotalScoreOfYear']));

      // تحديث القائمة
      dataList = usersData;
      notifyListeners();
    } catch (e) {
      print("Error retrieving and sorting users by scores: $e");
    }
  }


  void scoreId(String userId) async {
    try {
      // جلب المستند بناءً على الـ ID المحدد
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .doc(userId) // استخدام الـ userId لجلب المستند
          .get();

      if (snapshot.exists) {
        // استرجاع النقاط (score) من المستند
        int score = snapshot['score']; // قم بتغيير 'score' إلى الاسم الصحيح في مستندك إذا لزم الأمر

        // طباعة النقاط
        print("User $userId has score: $score");
      } else {
        print("No user found with ID: $userId");
      }
    } catch (e) {
      print("Error fetching score: $e");
    }
  }

  List<Map<String, dynamic>> userRanks = [];

  Future<void> fetchUserRanks() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .get();

      List<Map<String, dynamic>> tempRanks = [];

      for (var userDoc in userSnapshot.docs) {
        String userId = userDoc.id;

        QuerySnapshot yearSnapshot = await FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(userId)
            .collection(ModelYear.collection)
            .get();

        // حساب مجموع السكور لكل يوزر
        int totalScore = yearSnapshot.docs.fold(0, (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          return sum + (data['TotalScoreOfYear'] ?? 0)as int;
        });

        // إضافة بيانات المستخدم مع مجموع السكور
        final userData = userDoc.data() as Map<String, dynamic>;
        tempRanks.add({
          'id': userId,
          'name': userData['name'] ?? 'Unknown',
          'score': totalScore,
        });
      }

      // ترتيب المستخدمين بناءً على السكور تنازلياً
      tempRanks.sort((a, b) => b['score'].compareTo(a['score']));

      userRanks = tempRanks;
    } catch (e) {
      print('Error fetching user ranks: $e');
    }
  }


}