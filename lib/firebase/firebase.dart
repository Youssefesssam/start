import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/modelData.dart';
import '../model/modelMonth.dart';
import '../model/modelUser.dart';
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

 static Future<List<DocumentSnapshot>> getAllDocuments(
     String collectionPath) async {
  try {
   QuerySnapshot snapshot =
   await FirebaseFirestore.instance.collection(collectionPath).get();
   return snapshot.docs; // Returns a list of DocumentSnapshot
  } catch (e) {
   print('Error fetching documents: $e');
   return []; // Return an empty list in case of an error
  }
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

 static Future<Stream<QuerySnapshot<Object?>>?> getAllDocs(
     {required String userId,
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
 static void setTotalScore({required String userId,
  required String yearId,required int totalScore}){
  var collectionReference = FirebaseFirestore.instance
      .collection(MyUser.collection)
      .doc(userId)
      .collection(ModelYear.collection)
      .doc(yearId);
  collectionReference.set({'TotalScoreOfYear':totalScore});
 }
 static Future<int?> getTotalScore({
  required String userId,
  required String yearId,
 }) async {
  try {
   // حدد مسار المستند
   var documentReference = FirebaseFirestore.instance
       .collection(MyUser.collection)
       .doc(userId)
       .collection(ModelYear.collection)
       .doc(yearId);

   // احصل على المستند من Firestore
   DocumentSnapshot documentSnapshot = await documentReference.get();

   // التحقق إذا كان المستند يحتوي على الحقل 'TotalScoreOfYear'
   if (documentSnapshot.exists && documentSnapshot.data() != null) {
    Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
    return data?['TotalScoreOfYear'] as int?; // إرجاع القيمة كـ int
   } else {
    print("Document does not exist or no data found.");
    return null; // إذا لم يكن هناك بيانات
   }
  } catch (e) {
   // معالجة الأخطاء أثناء جلب البيانات
   print("Error getting TotalScoreOfYear: $e");
   return null; // إذا حدث خطأ
  }
 }
// week=10 => 1 2 3 4
// 10 % 4 = 2

}