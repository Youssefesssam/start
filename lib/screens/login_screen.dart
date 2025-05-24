import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:star_t/screens/regester_leader_screen.dart';
import '../models/leader_model.dart';
import '../providers/leader_provider.dart';

class LoginScreenLeader extends StatefulWidget {
  static const String routeName ="LoginScreenLeader";

  @override
  _LoginScreenLeaderState createState() => _LoginScreenLeaderState();
}

class _LoginScreenLeaderState extends State<LoginScreenLeader> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final leaderProvider = Provider.of<LeaderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'أدخل كود الليدر'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final code = _codeController.text.trim();

                if (code.startsWith('L') || code.startsWith('M')) {
                  final DocumentSnapshot snapshot =
                  await FirebaseFirestore.instance.collection('leaders').doc(code).get();

                  if (snapshot.exists) {
                    final data = snapshot.data() as Map<String, dynamic>;
                    final leader = LeaderModel.fromMap(data);
                    leaderProvider.setCurrentLeader(leader);
                    Navigator.pushReplacementNamed(context, RegisterLeaderScreen.routeName);
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('الكود غير موجود')));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('كود غير صحيح')));
                }
              },
              child: Text('دخول'),
            )
          ],
        ),
      ),
    );
  }
}