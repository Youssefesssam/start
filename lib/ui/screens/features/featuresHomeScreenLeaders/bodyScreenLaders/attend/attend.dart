import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/bodyScreenLaders/attend/cardUserAttend.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/bodyScreenLaders/attend/menuAttend.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/dataProvider.dart';
import '../../../../../../firebase/fireBase/fireBaseForUser/fireBaseGetDataForUser.dart';
import '../../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import '../../../../../../model/modelUserAttend.dart';

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


  @override
  void initState() {
    super.initState();
    FireBaseGetDataForLeader.fetchCurrentWeek().then((weekNum) {
      if (weekNum != null) {
        setState(() {
          currentWeekNum = weekNum;
        });
        Provider.of<AuthProviders>(context, listen: false)
            .readUsersAttendToLeaders(
            numWeek: weekNum); // استخدم weekNum مباشرةً
      }
    }).catchError((error) {
      print("Error fetching current week: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    //FireBaseGetDataForLeader.saveDateInProvider(context);
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    bool isUpdate = args['update'] ?? false;
    int? passedWeek = args['week'];
    AuthProviders authProviders = Provider.of(context);

    // Filter users based on the search query
    List<User> filteredUsers = authProviders.usersAttend
        .where((user) =>
    searchUserAttend.isEmpty ||
        (user.name
            .toLowerCase()
            .startsWith(searchUserAttend.toLowerCase())))
        .toList();

    // Reset selectedCardIndex if the list becomes empty
    if (filteredUsers.isEmpty && selectedCardIndex != null) {
      setState(() {
        selectedCardIndex = null;
      });
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        gradient: LinearGradient(
          colors: AppColors.backGround,
          begin: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ListOfUsers.routeName);
          },
          elevation: 0, // إزالة الظل
          shape: CircleBorder(
            side: BorderSide(color: Colors.white, width: 1.5), // إطار أسود
          ),
          child: Icon(Icons.add, size: 35, color: Colors.white), // أيقونة سوداء
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.withOpacity(0.4),
                    Colors.blueGrey.withOpacity(0.4),
                    Colors.blue.withOpacity(0.4),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
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
            if (selectedCardIndex != null)
              _buildSelectedCardOverlay(authProviders, filteredUsers),
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
        color: Colors.black.withOpacity(.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.black.withOpacity(0.8),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.blue, size: 35),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: userAttendence,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.blue),
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
             FireBaseGetDataForLeader.saveDateInProvider(context);
              Navigator.pushNamed(context, ListOfUsers.routeName);
            },
            child: Icon(Icons.people, color:Colors.blue, size: 35),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList(
      AuthProviders authProviders, List<User> filteredUsers) {
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(filteredUsers[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              authProviders.usersAttend.removeAt(index);
              FireBaseSetDataForLeader.deleteDec(authProviders.currentUser?.id);
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
                  selectedCardIndex =
                  (selectedCardIndex == index) ? null : index;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              child: _buildCard(filteredUsers[index]), // Use filteredUsers here
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

  Widget _buildSelectedCardOverlay(
      AuthProviders authProviders, List<User> filteredUsers) {
    // Ensure the list is not empty and the selectedCardIndex is valid
    if (filteredUsers.isEmpty ||
        selectedCardIndex == null ||
        selectedCardIndex! >= filteredUsers.length) {
      return Container(); // Return an empty container if conditions are not met
    }

    // Safely access the user at the selected index
    User selectedUser = filteredUsers[selectedCardIndex!];

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      left: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCard(selectedUser),
          // Use the safely accessed user
          const SizedBox(height: 20),
          _buildMenu(selectedUser, currentWeekNum ?? 1),
          // Provide a default week number if null
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
        child: const Text('Update',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCard(User user) {
    return CardUserAttend(users: user, score: 300, rank: 1,image: "null",);
  }

  Widget _buildMenu(User user, int weekNum) {
    return MenuAttend(
        user: user, userId: user.id, weekNum: weekNum, onCloseMenu: () {});
  }
}