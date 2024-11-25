import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/appBarLeaders/appBar.dart';
import '../features/featuresHomeScreenLeaders/ScreenHomeLeaders/screenHomeLeaders.dart';
import '../features/featuresHomeScreenLeaders/home/home.dart';
import '../features/featuresHomeScreenUsers/appBarUser/setting/setting.dart';
class HomeScreenLeaders extends StatefulWidget {
  static const String routeName = "screenHomeLeaders";
  const HomeScreenLeaders({super.key,});
  @override
  _HomeScreenLeaders createState() => _HomeScreenLeaders();
}
class _HomeScreenLeaders extends State<HomeScreenLeaders> {
  int currentTapIndex = 0;
  List <Widget> screen =[const Home(),const ScreenHomeLeaders(),const Setting()];
  Widget currentTab =  const Home();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title:const AppBarLaeders(),
        backgroundColor:const Color(0x44aaaaff),
      ),
      bottomNavigationBar: bildBottomNavigation(),
      body: currentTab,
    );
  }
  Widget bildBottomNavigation()=> Theme(
      data: Theme.of(context).copyWith(
          canvasColor:const Color(0x5e474444)),
      child: Container(
        margin: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:const Color(0x44aaaaff),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: const Color(0xfffa8e00),
          items: [
            bottomNavigationBarItem(Icons.home_filled,"Home"),
            bottomNavigationBarItem(Icons.list_alt,"list"),
            bottomNavigationBarItem(Icons.settings,"setting"),
          ],
          currentIndex: currentTapIndex,
          onTap:(index){
            currentTapIndex=index;
            currentTab = screen[currentTapIndex];
            setState((){});
          } ,
        ),
      )
  );
  BottomNavigationBarItem bottomNavigationBarItem(
      IconData imagepath,String text
      ) => BottomNavigationBarItem(icon:Icon(imagepath,size: 40,) ,label: text ,) ;
}

class Search {
}