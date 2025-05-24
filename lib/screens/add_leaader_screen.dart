import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class AddMasterLeaderScreen extends StatefulWidget {
  static const String routeName ="AddMasterLeaderScreen";

  @override
  _AddMasterLeaderScreenState createState() => _AddMasterLeaderScreenState();
}

class _AddMasterLeaderScreenState extends State<AddMasterLeaderScreen> {
  String? _governorate;
  String? _church;
  String? _specialty;

  final List<String> governors = ['القاهرة (01)', 'الجيزة (02)', 'الإسكندرية (03)'];
  final List<String> churches = ['كنيسة السلام (101)', 'مدرسة المستقبل (102)'];
  final List<String> specialties = ['عام', 'مسرح', 'كورال', 'إنشاد', 'تعليم'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء كود لليدر عام')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // اختيار المحافظة
            DropdownButtonFormField<String>(
              value: _governorate,
              items: governors.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _governorate = value;
                });
              },
              decoration: InputDecoration(labelText: 'اختر المحافظة'),
            ),
            SizedBox(height: 20),

            // اختيار الكنيسة
            DropdownButtonFormField<String>(
              value: _church,
              items: churches.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _church = value;
                });
              },
              decoration: InputDecoration(labelText: 'اختر الكنيسة'),
            ),
            SizedBox(height: 20),

            // اختيار التخصص
            DropdownButtonFormField<String>(
              value: _specialty,
              items: specialties.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _specialty = value;
                });
              },
              decoration: InputDecoration(labelText: 'اختر التخصص'),
            ),
            SizedBox(height: 20),

            // زر حفظ وإنشاء الكود
            ElevatedButton(
              onPressed: () {
                if (_governorate != null && _church != null && _specialty != null) {
                  final govCode = _governorate!.split('(')[1].replaceAll(')', '');
                  final churchCode = _church!.split('(')[1].replaceAll(')', '');

                  FirebaseService().addNewMasterLeader(govCode, churchCode, _specialty!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إنشاء الكود')));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('من فضلك املأ كل الحقول')));
                }
              },
              child: Text('إنشاء الكود'),
            )
          ],
        ),
      ),
    );
  }
}