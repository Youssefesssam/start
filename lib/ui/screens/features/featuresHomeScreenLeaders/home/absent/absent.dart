import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../../utilites/appColors.dart';
import 'absentData.dart';

class Absent extends StatefulWidget {
  static const String routeName = "absent";

  const Absent({super.key});

  @override
  State<Absent> createState() => _AbsentState();
}

class _AbsentState extends State<Absent> {
  int? currentWeekNum;
  int absentLength = 0;
  List<Map<String, dynamic>> _absentUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final weekNum = await FireBaseGetDataForLeader.fetchCurrentWeek();
      final authProvider = Provider.of<AuthProviders>(context, listen: false);
      final data = await FireBaseGetDataForLeader.getAllAbsentData();

      setState(() {
        currentWeekNum = weekNum;
        _absentUsers = data.where((user) => user["count"] > 1).toList();
        _absentUsers.sort((a, b) => a["count"].compareTo(b["count"]));
        absentLength = _absentUsers.length;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    try {
      setState(() => _isLoading = true);

      await FireBaseSetDataForLeader.updateLack(user["id"], user["lack"]);
      await FireBaseSetDataForLeader.updatelackWeek(user["id"], currentWeekNum!);
      FireBaseSetDataForLeader.delAbsences(user["id"]);

      setState(() {
        _absentUsers.removeWhere((u) => u["id"] == user["id"]);
        absentLength = _absentUsers.length;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user["name"]} removed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove: ${e.toString()}')),
      );
      // إعادة تحميل البيانات في حالة الخطأ
      await _loadData();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal[50]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Column(
          children: [
            // Header Bar
            Container(
              margin: const EdgeInsets.all(15),
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios),
                          Text("$absentLength", style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Text(
                        "Absents",
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Icon(
                        Icons.battery_0_bar,
                        color: Colors.red[700],
                        size: 30,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () {
                      setState(() => _isLoading = true); // تظهر الـ loader
                       authProviders.calculateAbsentUsers(currentWeekNum!); // تحسب الغياب
                       _loadData(); // ترجع تجيب البيانات وتحدث الواجهة // إعادة تحميل البيانات بعد الحساب
                    },
                    child: Row(
                      children: [
                        Text(
                          "calculate",
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.cached,
                          color: Colors.red[700],
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Main Content
            _isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : _absentUsers.isEmpty
                ? const Expanded(
              child: Center(
                child: Text(
                  " No absents yet!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
                : Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _absentUsers.length,
                  itemBuilder: (context, index) {
                    final user = _absentUsers[index];
                    final absences = user["count"];
                    Color badgeColor;
                    if (absences == 2) {
                      badgeColor = Colors.indigo;
                    } else if (absences == 3) {
                      badgeColor = Colors.deepPurple;
                    } else if (absences == 4) {
                      badgeColor = Colors.pink.shade400;
                    } else {
                      badgeColor = Colors.redAccent.shade700;
                    }

                    return Dismissible(
                      key: Key(user["id"]),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) => _deleteUser(user),
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [Colors.grey[900]!, Colors.red[700]!],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.delete, color: Colors.white, size: 30),
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AbsentData.routeName,
                            arguments: {
                              'id': user["id"],
                              'profile': user["profile"],
                              'phone': user["phone"],
                              'address': user["address"],
                              'whatsapp': user["whatsapp"],
                              'email': user["email"],
                              'name': user["name"],
                              'lack': user["lack"],
                              'facebook': user["facebook"],
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: badgeColor.withOpacity(0.1),
                              child: Icon(Icons.person_off,
                                  size: 30, color: badgeColor),
                            ),
                            title: Text(
                              user["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                            subtitle: Text(
                              "Absent $absences time${absences > 1 ? "s" : ""}",
                              style: const TextStyle(
                                color: Color(0xFF6E6E6E),
                                fontSize: 14,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: badgeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "$absences",
                                style: TextStyle(
                                  color: badgeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}