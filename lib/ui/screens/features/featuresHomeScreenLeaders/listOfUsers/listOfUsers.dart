import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../../../firebase/dataProvider.dart';
import '../../../../../firebase/authProvider.dart';
import '../../../../../model/modelUser.dart';
import 'cardUser.dart';
import 'menu.dart';

class ListOfUsers extends StatefulWidget {
  static const String routeName = "listOfUsers";
  ListOfUsers({super.key});

  @override
  State<ListOfUsers> createState() => _ListOfUsers();
}

class _ListOfUsers extends State<ListOfUsers> {
  int? selectedCardIndex;
  int? currentWeekNum;
  late int weekToUse;
  TextEditingController searchAllUser = TextEditingController();
  String searchUser = '';

  Future<void> fetchCurrentWeek() async {
    int? week = await FirebaseUtils.getCurrentWeek();
    setState(() {
      currentWeekNum = week ?? 1; // في حالة عدم وجود قيمة، اجعل الأسبوع الأول الافتراضي
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProviders>(context, listen: false).readUsersToLeaders();
      fetchCurrentWeek();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    bool isUpdate = args['update'] ?? false; // هل هي حالة تحديث؟
    int? passedWeek = args['week'];
    weekToUse = passedWeek ?? currentWeekNum ?? 1;
    AuthProviders authProviders = Provider.of<AuthProviders>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    dataProvider.getAllUserFromFirebase(authProviders.currentUser?.id ?? "");

    // تصفية المستخدمين بناءً على الاسم المدخل
    List<MyUser> filteredUsers = authProviders.users
        .where((user) =>
    searchUser.isEmpty || // عرض جميع المستخدمين إذا كان البحث فارغًا
        (user.name.toLowerCase().startsWith(searchUser.toLowerCase())) // مقارنة الأحرف بنفس الترتيب
    )
        .toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        gradient: LinearGradient(
          colors: AppColors.backGround,
          begin: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: authProviders.users.isEmpty
            ? Center(
          child: CircularProgressIndicator(
            color: AppColors.mainColor,
          ),
        )
            : Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkgrey,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.mainColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.mainColor,
                        size: 35,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchAllUser,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(color: AppColors.mainColor),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: AppColors.white),
                          cursorColor: AppColors.mainColor,
                          onChanged: (value) {
                            setState(() {
                              searchUser = value; // تحديث قيمة البحث عند الكتابة
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(filteredUsers[index].id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            authProviders.users.removeAt(index);
                            FirebaseUtils.deleteDec(authProviders.currentUser?.id);
                            if (selectedCardIndex == index) {
                              selectedCardIndex = null;
                            }
                          });
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey[900]!,
                                Colors.cyan[700]!,
                              ],
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
                            setState(() {
                              if (selectedCardIndex == index) {
                                selectedCardIndex = null;
                              } else {
                                selectedCardIndex = index;
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            child: _buildCard(filteredUsers[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (selectedCardIndex != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCardIndex = null;
                    });
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            if (selectedCardIndex != null)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                left: 20,
                right: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCard(filteredUsers[selectedCardIndex!]),
                    const SizedBox(height: 20),
                    _buildMenu(filteredUsers[selectedCardIndex!], isUpdate ? weekToUse : currentWeekNum!),
                  ],
                ),
              ),
            if (isUpdate) // عرض زرار "Update" لو في حالة تحديث
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print('Update week: $weekToUse');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(MyUser user) {
    return CardUser(
      users: user,
      userId: user.id,
      score: 300,
      rank: 1,
    );
  }

  Widget _buildMenu(MyUser user, int weekNum) {
    return Menu(
      onCloseMenu: () {
        setState(() {
          selectedCardIndex = null;
        });
      },
      user: user,
      userId: user.id,
      weekNum: weekNum,
    );
  }
}
