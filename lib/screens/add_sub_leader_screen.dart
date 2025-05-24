import 'package:flutter/material.dart';
import '../services/churchService.dart';
import '../services/firebase_service.dart';
import '../services/governorateserveces.dart';

class AddSubLeaderScreen extends StatefulWidget {
  static const String routeName = '/add_sub_leader';

  final String masterLeaderCode; // مثل: M02105X4729 ← هنحلله هنا

  const AddSubLeaderScreen({
    Key? key,
    required this.masterLeaderCode,
  }) : super(key: key);

  @override
  _AddSubLeaderScreenState createState() => _AddSubLeaderScreenState();
}

class _AddSubLeaderScreenState extends State<AddSubLeaderScreen> {
  final TextEditingController _nameController = TextEditingController();

  String? _stageType; // P / S / U
  String? _stageYear; // 1 / 2 / 3
  String? _specialty;

  late String governorateCode;
  late String churchCode;

  final List<String> stageTypes = ['P', 'S', 'U'];
  final List<String> stageYears = ['1', '2', '3'];
  final List<String> specialties = ['عام', 'مسرح', 'كورال', 'إنشاد', 'تعليم'];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // --- 🔍 استخراج أكواد المحافظة والكنيسة من كود الليدر العام ---
    if (widget.masterLeaderCode.length >= 6) {
      governorateCode = widget.masterLeaderCode.substring(1, 3); // مثلاً: 02
      churchCode = widget.masterLeaderCode.substring(3, 6);     // مثلاً: 105
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('كود الليدر العام غير صحيح')),
      );
      governorateCode = 'XX';
      churchCode = 'XXX';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء ليديـر فرعي')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // --- 👁‍🗨 عرض اسم المحافظة ---
            ListTile(
              title: Text('المحافظة'),
              subtitle: Text(GovernorateService.getGovernorateName(governorateCode)),
            ),

            // --- 👁‍🗨 عرض اسم الكنيسة ---
            ListTile(
              title: Text('الكنيسة'),
              subtitle: Text(ChurchService.getChurchName(churchCode)),
            ),

            SizedBox(height: 20),

            // --- 🧑‍🏫 اسم الليدر ---
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'اسم الليدر'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'من فضلك أدخل اسم الليدر';
                return null;
              },
            ),

            SizedBox(height: 20),

            // --- 🎓 اختيار نوع المرحلة ---
            DropdownButtonFormField<String>(
              value: _stageType,
              items: stageTypes.map((value) {
                String name;
                if (value == 'P') {
                  name = 'إعدادي';
                } else if (value == 'S') {
                  name = 'ثانوي';
                } else if (value == 'U') {
                  name = 'جامعي';
                } else {
                  name = 'غير معروف'; // ← هنا التغيير
                }

                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _stageType = value;
                });
              },
              decoration: InputDecoration(labelText: 'اختر نوع المرحلة'),
            ),

            SizedBox(height: 20),

            // --- 📚 اختيار السنة الدراسية ---
            if (_stageType != null)
              DropdownButtonFormField<String>(
                value: _stageYear,
                items: stageYears.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _stageYear = value;
                  });
                },
                decoration: InputDecoration(labelText: 'اختر السنة الدراسية'),
              )
            else
              Container(),

            SizedBox(height: 20),

            // --- 🎨 اختيار التخصص ---
            DropdownButtonFormField<String>(
              value: _specialty,
              items: specialties.map((value) {
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

            SizedBox(height: 30),

            // --- 💾 زر الإنشاء ---
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: () async {
                if (_stageType != null &&
                    _stageYear != null &&
                    _specialty != null &&
                    _nameController.text.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });

                  final String stageCode = '$_stageType$_stageYear'; // مثل: S2 أو P1
                  final String leaderName = _nameController.text.trim();

                  await FirebaseService().addNewSubLeader(
                    governorateCode,
                    churchCode,
                    stageCode,
                    _specialty!,
                    leaderName,
                  );

                  setState(() {
                    _isLoading = false;
                  });



                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('من فضلك املأ كل الحقول'),
                  ));
                }
              },
              child: Text('إنشاء الكود'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}