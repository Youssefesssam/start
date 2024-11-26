import 'package:cloud_firestore/cloud_firestore.dart';
import 'ModelInfoUser.dart';

class FirebaseUtils {
 static CollectionReference<ModelInfoUser> getData() {
   var collectionReference = FirebaseFirestore.instance.collection(ModelInfoUser.collection)
      .withConverter<ModelInfoUser>(
   fromFirestore: (snapshot, options) => ModelInfoUser.fromJson(snapshot.data()!),
   toFirestore: (modelInfoUser, options) => modelInfoUser.toJson(),
  );
   return collectionReference;
 }

 static Future<void> addData(ModelInfoUser modelInfoUser) async {
  try {
   var collection = getData();
   var docRef = collection.doc();
   await docRef.set(modelInfoUser);
   print("Document successfully added");
  } catch (error) {
   print("Failed to add document: $error");
   throw error;
  }
 }

 static Future<List<DocumentSnapshot>> getAllDocuments(String collectionPath) async {
  try {
   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionPath).get();
   return snapshot.docs; // Returns a list of DocumentSnapshot
  } catch (e) {
   print('Error fetching documents: $e');
   return []; // Return an empty list in case of an error
  }
 }
 static Future<Map<String, dynamic>> getStatistics() async {
  try {
   var snapshot = await FirebaseFirestore.instance
       .collection(ModelInfoUser.collection)
       .doc('x83zILnoyVzhAoD3iwK3') // استبدل بالوثيقة الصحيحة
       .get();

   if (snapshot.exists) {
    return snapshot.data() as Map<String, dynamic>; // إرجاع جميع البيانات كخريطة
   } else {
    print("Document does not exist");
    return {};
   }
  } catch (e) {
   print("Error retrieving data from Firestore: $e");
   return {};
  }
 }


}



