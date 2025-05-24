import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/leader_model.dart';
import 'churchService.dart';
import 'governorateserveces.dart';
import 'package:random_string/random_string.dart'; // ← import هنا

class FirebaseService {
  final CollectionReference leadersRef =
  FirebaseFirestore.instance.collection('leaders');

  Future<LeaderModel?> getLeaderByCode(String code) async {
    final DocumentSnapshot snapshot = await leadersRef.doc(code).get();
    if (snapshot.exists) {
      return LeaderModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addNewMasterLeader(String governorateCode, String churchCode,
      String specialty) async {
    final randomId = (Random().nextInt(9000) + 1000);
    final leaderCode = 'M$governorateCode$churchCode$randomId';
    await leadersRef.doc(leaderCode).set({
      'code': leaderCode,
      'name': 'الليدر العام - $specialty',
      'governorate': GovernorateService.getGovernorateName(governorateCode),
      'church': ChurchService.getChurchName(churchCode),
      'stage': 'X',
      'role': 'master_leader',
      'email': '',
      'specialty': specialty,
    });
  }

  Future<void> addNewSubLeader(String governorateCode,
      String churchCode,
      String stageCode,
      String specialty,
      String leaderName) async {
    // Step 1: Define the random ID for the sub-leader
    final randomId = randomNumeric(4); // Generate a 4-digit random number
    final leaderCode = 'L$governorateCode$churchCode$stageCode$randomId';

    // Step 2: Get the reference to the parent document (M011013977)
    final parentDocRef = leadersRef.doc('M011013977');

    // Step 3: Get the reference to the subcollection (sub_leaders)
    final subLeadersColRef = parentDocRef.collection('sub_leaders');

    // Step 4: Add a new document to the subcollection
    await subLeadersColRef.doc(leaderCode).set({
      'code': leaderCode,
      'name': leaderName,
      'governorate': GovernorateService.getGovernorateName(governorateCode),
      'governorate_code': governorateCode,
      'church': ChurchService.getChurchName(churchCode),
      'church_code': churchCode,
      'stage_code': stageCode,
      'stage_type': stageCode[0],
      'stage_year': stageCode.length > 1 ? stageCode.substring(1) : '',
      'role': 'sub_leader',
      'specialty': specialty,
      'is_registered': false,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

}