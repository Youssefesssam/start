import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/appBarLeaders/appBar.dart';
import '../features/featuresHomeScreenLeaders/home/home.dart';
import '../features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import '../features/featuresHomeScreenUsers/appBarUser/setting/setting.dart';

class HomeScreenLeaders extends StatefulWidget {
  static const String routeName = "HomeScreenLeaders";

  HomeScreenLeaders({super.key});

  @override
  _HomeScreenLeaders createState() => _HomeScreenLeaders();
}

class _HomeScreenLeaders extends State<HomeScreenLeaders> {
  int currentTapIndex = 0;

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const Home(),
      ListOfUsers(),
      const Setting(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      bottomNavigationBar: buildBottomNavigation(),
      body: screens[currentTapIndex],
    );
  }

  Widget buildBottomNavigation() => Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: BottomNavigationBar(
      elevation: 10,
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey[500],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      currentIndex: currentTapIndex,
      selectedIconTheme: IconThemeData(color: Colors.teal),
      onTap: (index) {
        setState(() {
          currentTapIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 30),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt, size: 30),
          label: "List",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: 30),
          label: "Settings",
        ),
      ],
    ),
  );
}