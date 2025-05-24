import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:star_t/screens/screen_profile_leader.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenLeaders.dart';

import '../models/leader_model.dart';
import '../providers/leader_provider.dart';
import 'add_sub_leader_screen.dart';

class RegisterLeaderScreen extends StatefulWidget {
  static const String routeName = 'RegisterLeaderScreen';
  final String leaderCode; // الكود اللي دخل به الليدر

  const RegisterLeaderScreen({Key? key, required this.leaderCode})
      : super(key: key);

  @override
  _RegisterLeaderScreenState createState() => _RegisterLeaderScreenState();
}

class _RegisterLeaderScreenState extends State<RegisterLeaderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final leaderProvider =
          Provider.of<LeaderProvider>(context, listen: false);

      Future<void> _submitForm(BuildContext context) async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });

          final leaderProvider =
              Provider.of<LeaderProvider>(context, listen: false);

          final leaderData = {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'is_registered': true,
            'registered_at': FieldValue.serverTimestamp(),
          };

          try {
            // تحديث بيانات الليدر في Firebase
            await FirebaseFirestore.instance
                .collection('leaders')
                .doc(widget.leaderCode)
                .update(leaderData);

            // جلب البيانات الكاملة من Firebase
            final snapshot = await FirebaseFirestore.instance
                .collection('leaders')
                .doc(widget.leaderCode)
                .get();

            final data = snapshot.data() as Map<String, dynamic>;
            final leader = LeaderModel.fromMap(data);
            leaderProvider.setCurrentLeader(leader);

            setState(() {
              _isLoading = false;
            });

            // --- 🔁 هنا التعديل ---
            // استخراج كود المحافظة والكنيسة من الكود
            String governorateCode =
                widget.leaderCode.substring(1, 3); // مثلاً: 02
            String churchCode = widget.leaderCode.substring(3, 6); // مثلاً: 105

            // انتقال للشاشة التالية مع إرسال الأكواد
            Navigator.pushReplacementNamed(
              context,
              AddSubLeaderScreen.routeName,
              arguments: {
                'gov_code': governorateCode,
                'church_code': churchCode,
              },
            );
          } catch (e) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('فشل في الحفظ')));
          }
        }
      }

      final leaderData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'is_registered': true,
        'registered_at': FieldValue.serverTimestamp(),
      };

      try {
        // تحديث بيانات الليدر في Firebase
        await FirebaseFirestore.instance
            .collection('leaders')
            .doc(widget.leaderCode)
            .update(leaderData);

        // جلب البيانات الكاملة من Firebase
        final snapshot = await FirebaseFirestore.instance
            .collection('leaders')
            .doc(widget.leaderCode)
            .get();

        final data = snapshot.data() as Map<String, dynamic>;
        final leader = LeaderModel.fromMap(data);
        leaderProvider.setCurrentLeader(leader);

        setState(() {
          _isLoading = false;
        });

        // الانتقال للملف الشخصي
        Navigator.pushReplacementNamed(context, HomeScreenLeaders.routeName);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('فشل في الحفظ')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إكمال بيانات الليدر')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'كود الليدر: ${widget.leaderCode}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'الاسم'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل اسمك';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل البريد الإلكتروني';
                  }
                  // يمكنك إضافة تحقق على صيغة البريد
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل رقم الهاتف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child: Text('حفظ البيانات'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
