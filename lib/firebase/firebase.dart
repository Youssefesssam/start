import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_t/model/modelEvent.dart';
import 'package:star_t/model/modelSweetTalk.dart';

import '../model/modelData.dart';
import '../model/modelMonth.dart';
import '../model/modelUser.dart';
import '../model/modelUserAttend.dart';
import '../model/modelYear.dart';
import '../model/modelweek.dart';

class FirebaseUtils {
  static CollectionReference<MyUser> getUser() {
    var collectionReference = FirebaseFirestore.instance
        .collection(MyUser.collection)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromJson(snapshot.data()!),
          toFirestore: (myUser, options) => myUser.toJson(),
        );
    return collectionReference;
  }

  static CollectionReference<User> getAttend(int numWeek) {
    if (numWeek <= 0) {
      throw ArgumentError("numWeek must be a positive integer.");
    }
    return FirebaseFirestore.instance
        .collection('numWeek')
        .doc(numWeek.toString()) // تأكد من تحويل الرقم إلى نص
        .collection('attend')
        .withConverter<User>(
      fromFirestore: (snapshot, options) {
        if (snapshot.data() == null) {
          throw Exception("Document data is null for week $numWeek");
        }
        return User.fromJson(snapshot.data()!);
      },
      toFirestore: (user, options) => user.toJson(),
    );
  }


  static Future<void> addUser(MyUser myUser) {
    return getUser().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserData(userId) async {
    var querySnapshot = await getUser().doc(userId).get();
    return querySnapshot.data();
  }

  static void deleteDec(MyUser myUser) {
    FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc(myUser.id)
        .delete();
  }

  //youtube

  static CollectionReference<ModelYear> getYear(String userId) {
    var collectionReference = getUser()
        .doc(userId)
        .collection(ModelYear.collection)
        .withConverter<ModelYear>(
          fromFirestore: (snapshot, options) =>
              ModelYear.fromJson(snapshot.data()!),
          toFirestore: (modelYear, options) => modelYear.toJson(),
        );
    return collectionReference;
  }

  static CollectionReference<ModelMonth> getMonth(
      String userId, String yearId) {
    var collectionReference = getYear(userId)
        .doc(yearId)
        .collection(ModelMonth.collection)
        .withConverter<ModelMonth>(
          fromFirestore: (snapshot, options) =>
              ModelMonth.fromJson(snapshot.data()!),
          toFirestore: (modelMonth, options) => modelMonth.toJson(),
        );
    return collectionReference;
  }

  static CollectionReference<ModelWeek> getWeek(
      String userId, String yearId, String monthId) {
    var collectionReference = getMonth(userId, yearId)
        .doc(monthId)
        .collection(ModelWeek.collection)
        .withConverter<ModelWeek>(
          fromFirestore: (snapshot, options) =>
              ModelWeek.fromJson(snapshot.data()!),
          toFirestore: (modelWeek, options) => modelWeek.toJson(),
        );
    return collectionReference;
  }

  static CollectionReference<ModelData> getinfo(
      String userId, String yearId, String monthId, String weekId) {
    var collectionReference = getWeek(userId, yearId, monthId)
        .doc(weekId)
        .collection(ModelData.collection)
        .withConverter<ModelData>(
          fromFirestore: (snapshot, options) =>
              ModelData.fromJson(snapshot.data()!),
          toFirestore: (modelInfoUser, options) => modelInfoUser.toJson(),
        );
    return collectionReference;
  }

  static Future<void> setYearData(
      {required ModelData modelData,
      required String userId,
      required int weekNumber}) async {
    try {
      int year = 1;
      int monthNumber = ((weekNumber - 1) ~/ 4) + 1;
      String monthId = monthNumber
          .toString()
          .padLeft(2, '0'); // month ID as "01", "02", etc.

      while (monthNumber > 12) {
        year += 1; // زيادة السنة
        monthNumber -= 12;
        monthId = monthNumber.toString().padLeft(2, '0');
        print("New year created: $year");
      }

      String yearId = year.toString();

      int weekInMonth = ((weekNumber - 1) % 4) + 1;
      String weekId = 'week_$weekInMonth';

      // استخدام .add() لتعيين ID تلقائي
      var collectionReference = getinfo(userId, yearId, monthId, weekId);
      await collectionReference.add(modelData);

      print(
          "Data successfully added to user: $userId, year: $yearId, month: $monthId, week: $weekId");
    } catch (e) {
      print("Failed to set data: $e");
      throw e;
    }
  }

  static Future<Stream<QuerySnapshot<Object?>>?> getAllDocs({
    required String userId,
    required String yearId,
    required String monthId,
    required String weekId,
  }) async {
    var collectionReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Year')
        .doc(yearId)
        .collection('Month')
        .doc(monthId)
        .collection('Week')
        .doc(weekId)
        .collection('Data');
    return collectionReference.snapshots();
  }

  static void setTotalScore(
      {required String userId,
      required String yearId,
      required int totalScore}) {
    var collectionReference = FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc(userId)
        .collection(ModelYear.collection)
        .doc(yearId);
    collectionReference.set({'TotalScoreOfYear': totalScore});
  }

  static Future<void> sendWord({required String message, required String sender}) async {
    try {
      // الوصول إلى المجموعة
      CollectionReference wordsCollection = FirebaseFirestore.instance.collection('word');

      // البحث عن الكلمة الموجودة بالفعل
      QuerySnapshot querySnapshot = await wordsCollection.where('message', isEqualTo: message).get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await wordsCollection.doc(docId).update({
          'sender': sender,
          'Time': Timestamp.now(), // تحديث وقت الإرسال
        });
      } else {
        await wordsCollection.doc('1').set({
          'message': message,
          'sender': sender,
          'Time': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Eroor $e');
    }
  }


  static Stream<QuerySnapshot> fetchMessages() {
    return FirebaseFirestore.instance
        .collection('word') // اسم الكولكشن
        .orderBy('Time', descending: true)
        .snapshots(); // إرجاع Stream
  }

  static Future<void> sendOpinion({required opinion}) async {
    FirebaseFirestore.instance
        .collection('opinion')
        .add({'opinion': opinion, 'Time': Timestamp.now().toDate()});
  }

  static Stream<QuerySnapshot> fetchOpinion() {
    return FirebaseFirestore.instance
        .collection('opinion')
        .orderBy('Time', descending: true)
        .snapshots();
  }

  static Future<void> numWeek({required numWeek}) async {
    var week = await FirebaseFirestore.instance
        .collection('numWeek')
        .doc(numWeek.toString());
    var doc = await week.get();
    if (doc.exists) {
      print('week number exit');
    } else {
      await week.set({'weekNum': numWeek, 'date': DateTime.now()});
    }
  }

  static Stream<QuerySnapshot> fetchNumWeek() {
    return FirebaseFirestore.instance.collection('numWeek').snapshots();
  }

  static Future<void> sendTask(
      {required String task, required String leader}) async {
    QuerySnapshot taskSnapshot =
        await FirebaseFirestore.instance.collection('task').limit(1).get();
    if (taskSnapshot.docs.isNotEmpty) {
      String taskId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('task').doc(taskId).update({
        'task': task,
        'leader': leader,
      });
      print("updated");
    } else {
      FirebaseFirestore.instance.collection('task').add({
        'task': task,
        'leader': leader,
      });
      print("added");
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> recieveTask() {
    return FirebaseFirestore.instance.collection('task').snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> currentWeek() {
    return FirebaseFirestore.instance
        .collection('settings')
        .doc('currentWeek')
        .snapshots();
  }

  static Future<void> updateNextWeek(int current) async {
    final nextWeekRef =
        FirebaseFirestore.instance.collection('settings').doc('nextWeek');
    await nextWeekRef.set({'weekNumber': current + 2});
  }

  static Future<void> updatePreviousWeek(int current) async {
    final nextWeekRef =
        FirebaseFirestore.instance.collection('settings').doc('previousWeek');
    await nextWeekRef.set({'weekNumber': current});
  }

  static Future<void> updateCurrentWeek(int weekNumber) async {
    final currentWeekRef =
        FirebaseFirestore.instance.collection('settings').doc('currentWeek');
    await currentWeekRef.set({'weekNumber': weekNumber});
  }

  static Future<void> updateWeek(int weekNumber) async {
    final currentWeekRef =
        FirebaseFirestore.instance.collection('settings').doc('updateWeek');
    await currentWeekRef.set({'weekNumber': weekNumber});
  }

  static Future<void> attendUsers(
      int weekNum,
      MyUser user,
      int totalScore,
      int massScore,
      int communionScore,
      int confessionScore,
      int meetingScore,{
        int seenWord =0,
        int pons =0,
        int winVoting =0,
        int solTaskoo =0,
        int rank =0,
  }


      ) async {
    final currentWeekRef = FirebaseFirestore.instance
        .collection('numWeek') // مجموعة الأسابيع
        .doc(weekNum.toString()) // وثيقة الأسبوع الحالي
        .collection('attend') // مجموعة الحضور
        .doc(user.id); // استخدام اسم المستخدم كمفتاح للمستند

    await currentWeekRef.set({
      'name': user.name, // اسم المستخدم
      'id': user.id,
      'score': totalScore,
      'meetingScoreDB': meetingScore,
      'communionScoreDB': communionScore,
      'confessionScoreDB': confessionScore,
      'massScoreDB': massScore,
      'seenWord':seenWord,
      'pons':pons,
      'winVoting':winVoting,
      'solTaskoo':solTaskoo,
      'rank':rank,
    });
  }


  static Future<int?> getCurrentWeek() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('currentWeek')
        .get();
    return querySnapshot.data()?['weekNumber'] ?? 0;
  }

  static Future<int?> getPreviousWeek() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('previousWeek')
        .get();
    return querySnapshot.data()?['weekNumber'] ?? 0;
  }

  static Future<int?> getNextWeek() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('nextWeek')
        .get();
    return querySnapshot.data()?['weekNumber'] ?? 0;
  }

  static Future<QuerySnapshot> getUserAttend(int numWeek) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('numWeek')
        .doc(numWeek.toString())
        .collection('attend')
        .get();
    return snapshot; // Returns a list of DocumentSnapshot
  }
//**********************************************************///
  static Stream<QuerySnapshot> getSweetTalk() {
    return FirebaseFirestore.instance
        .collection(ModelSweetTalk.collection)
        .orderBy('Time', descending: true)
        .snapshots();
  }

  static Future<void> sweetTalkSet({required String sweetTalk}) async {
    QuerySnapshot taskSnapshot =
    await FirebaseFirestore.instance.collection(ModelSweetTalk.collection).limit(1).get();
    if (taskSnapshot.docs.isNotEmpty) {
      String textId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection(ModelSweetTalk.collection).doc(textId).update({
        'talk': sweetTalk,
      });
      print("updated");
    } else {
      FirebaseFirestore.instance.collection(ModelSweetTalk.collection).add({
        'talk': sweetTalk,
      });
      print("added");
    }
  }


  static Stream<QuerySnapshot> getHiEvent() {
    return FirebaseFirestore.instance
        .collection(ModelHiEvent.collection)
        .orderBy('Time', descending: true)
        .snapshots();
  }

  static Future<void> HiEventSet({required String hiEvent}) async {
    QuerySnapshot taskSnapshot =
    await FirebaseFirestore.instance.collection(ModelHiEvent.collection).limit(1).get();
    if (taskSnapshot.docs.isNotEmpty) {
      String textId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection(ModelHiEvent.collection).doc(textId).update({
        'hiEvent': hiEvent,
      });
      print("updated");
    } else {
      FirebaseFirestore.instance.collection(ModelHiEvent.collection).add({
        'hiEvent': hiEvent,
      });
      print("added");
    }
  }
  //*************************************************************//

// Answer
  static Future<void> sendAnswer({required String answer,required String name}) async {
    late String firstId;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('task') // 🔹 الوصول إلى مجموعة المهام
        .limit(1) // 🔥 جلب أول مستند فقط
        .get();

    if (snapshot.docs.isNotEmpty) {
      firstId= snapshot.docs.first.id; // 🔥 إرجاع أول taskId
    }
    FirebaseFirestore.instance.collection('task').doc(firstId.toString()).collection('answer').add({
      'answer':answer,
      'sender':name
    });
  }
  static Future<List<Map<String, String>>> receiveAnswers() async {
    late String firstId;

    // جلب أول taskId
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('task') // الوصول إلى مجموعة المهام
        .limit(1) // جلب أول مستند فقط
        .get();

    if (snapshot.docs.isNotEmpty) {
      firstId = snapshot.docs.first.id; // إرجاع أول taskId
    } else {
      // في حالة عدم وجود أي مستندات في مجموعة task
      return [];
    }

    // جلب الإجابات من المهمة
    QuerySnapshot answer = await FirebaseFirestore.instance
        .collection('task')
        .doc(firstId)
        .collection('answer')
        .get();

    if (answer.docs.isEmpty) {
      // في حالة عدم وجود إجابات في مجموعة answer
      return [];
    }

    // إرجاع الإجابات في صورة قائمة من الخرائط
    return answer.docs.map((doc) {
      return {
        'sender': doc['sender'] as String,
        'answer': doc['answer'] as String,
      };
    }).toList();
  }
  static Future<void> deleteAnswers()async {
    QuerySnapshot snapshot=await FirebaseFirestore.instance.collection('task').limit(1).get();
    for(QueryDocumentSnapshot doc in snapshot.docs){
      await doc.reference.delete();
    }
  }
//---------------------------------------------------------------------------------------------

}
