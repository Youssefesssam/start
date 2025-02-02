import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/firebase.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/bodyScreenLaders/attend/cardUserAttend.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/dataProvider.dart';
import '../../../../../../model/modelUser.dart';
import '../../../../../../model/modelUserAttend.dart';
import '../../listOfUsers/menu.dart';

class Attend extends StatefulWidget {
  static const String routeName = "Attend";

  Attend({super.key});

  @override
  State<Attend> createState() => _Attend();
}

class _Attend extends State<Attend> {
  int? selectedCardIndex;
  int? currentWeekNum;
  TextEditingController userAttendence = TextEditingController();
  String searchUserAttend = '';

  Future<int> fetchCurrentWeek() async {
    try {
      int? week = await FirebaseUtils.getCurrentWeek();
      print("Fetched current week: $week");

      if (week != null) {
        return week;
      } else {
        print("Error: week is null.");
        return 1; // Default value
      }
    } catch (e) {
      print("Error fetching current week: $e");
      throw Exception("Failed to fetch current week.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentWeek().then((weekNum) {
      if (weekNum != null) {
        setState(() {
          currentWeekNum = weekNum;
        });

        if (currentWeekNum != null) {
          print(currentWeekNum);
          print('++++++++++++++++----------+++++++++++++++++');

          Provider.of<AuthProviders>(context, listen: false)
              .readUsersAttendToLeaders(numWeek: currentWeekNum!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    bool isUpdate = args['update'] ?? false;
    int? passedWeek = args['week'];

    AuthProviders authProviders = Provider.of(context);
    DataProvider dataProvider = Provider.of(context);

    // فلترة المستخدمين بناءً على البحث
    List<User> filteredUsers = authProviders.usersAttend
        .where((user) =>
    searchUserAttend.isEmpty ||
        (user.name.toLowerCase().startsWith(searchUserAttend.toLowerCase()))
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
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchBar(),
                Expanded(
                  child: _buildAttendanceList(authProviders, filteredUsers),
                ),
              ],
            ),
            if (selectedCardIndex != null) _buildBlurredBackground(),
            if (selectedCardIndex != null) _buildSelectedCardOverlay(authProviders, filteredUsers),
            if (isUpdate) _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
          Icon(Icons.search, color: AppColors.mainColor, size: 35),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: userAttendence,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: AppColors.mainColor),
                border: InputBorder.none,
              ),
              style: TextStyle(color: AppColors.white),
              cursorColor: AppColors.mainColor,
              onChanged: (value) {
                setState(() {
                  searchUserAttend = value;
                });
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ListOfUsers.routeName);
            },
            child: Icon(Icons.people, color: AppColors.mainColor, size: 35),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList(AuthProviders authProviders, List<User> filteredUsers) {
    if (filteredUsers.isEmpty) {
      return Center(child: Text("No users found.",style: TextStyle(color: Colors.white),));
    }
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(filteredUsers[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              authProviders.usersAttend.removeAt(index);
              FirebaseUtils.deleteDec(authProviders.currentUser?.id);
              if (selectedCardIndex == index) {
                selectedCardIndex = null;
              }
            });
          },
          background: _buildDismissBackground(),
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (index < filteredUsers.length) {
                  selectedCardIndex = (selectedCardIndex == index) ? null : index;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              child: _buildCard(filteredUsers[index]), // استخدام filteredUsers هنا
            ),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.cyan[700]!],
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
    );
  }

  Widget _buildBlurredBackground() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCardIndex = null;
          });
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildSelectedCardOverlay(AuthProviders authProviders, List<User> filteredUsers) {
    // تحقق من أن filteredUsers ليست فارغة وأن selectedCardIndex صالح
    if (filteredUsers.isEmpty || selectedCardIndex == null || selectedCardIndex! >= filteredUsers.length) {
      return Container(); // إرجاع حاوية فارغة إذا كانت القائمة فارغة أو الفهرس غير صالح
    }

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      left: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCard(filteredUsers[selectedCardIndex!]),  // استخدام filteredUsers هنا
          const SizedBox(height: 20),
          _buildMenu(authProviders.users[selectedCardIndex!], currentWeekNum!),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Update', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCard(User user) {
    return CardUserAttend(users: user, score: 300, rank: 1);
  }

  Widget _buildMenu(MyUser user, int weekNum) {
    return Menu(user: user, userId: user.id, weekNum: weekNum, onCloseMenu: () {});
  }
}
