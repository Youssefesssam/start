import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/firebase.dart';
import '../../../../../firebase/dataProvider.dart';
import '../../../../../firebase/authProvider.dart';
import '../../../../../model/modelUser.dart';
import 'cardUser.dart';
import 'menu.dart';

class ListOfUsers extends StatefulWidget {
  static const String routeName = "listOfUsers";

  const ListOfUsers({super.key});

  @override
  State<ListOfUsers> createState() => _ListOfUsers();
}

class _ListOfUsers extends State<ListOfUsers> {
  int? selectedCardIndex;

  // لتحديد الكارد الذي تم النقر عليه
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProviders>(context, listen: false).readUsersToLeaders();
    });
  }

  final List<String> letters = [
    'week 1', 'week 2'   , 'week 3', 'week 4',
    'week 5'   , 'week 6', 'week 7','week 8',
    'week 9', 'week 10'  , 'week 11', 'week 12', 'week 13',
    'week 14', 'week 15' , 'week 16', 'week 17', 'week 18',
    'week 19', 'week 2 ' , 'week 21', 'week 22', 'week 23',
    'week 24', 'week 25' , 'week 26', 'week 27', 'week 28',
    'week 29', 'week 30' , 'week 31', 'week 32', 'week 33',
    'week 34', 'week 35' , 'week 36', 'week 37', 'week 38',
    'week 39', 'week 40' , 'week 41', 'week 42', 'week 43',
    'week 44', 'week 45' , 'week 46', 'week 47','week 48',
  ];
  int selectedIndex = 0; // الحرف الحالي المختار

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);
    DataProvider dataProvider = Provider.of(context);
    dataProvider.getDataFromFirebase(authProviders.currentUser?.id ?? "");
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          gradient: LinearGradient(colors: [Colors.black,Colors.black12,Colors.black])

      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: authProviders.users.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.purple,
              ))
            : Stack(
                children: [
                  // الخلفية مع المحتوى الأساسي
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      InkWell(
                        onTap: (){
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent, // خلفية شفافة
                            context: context,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 5,
                                    margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(colors: [Colors.deepOrange,Colors.pink,Colors.pinkAccent,Colors.purple])

                                    ),
                                  ),
                                  Text(
                                    'Select Week',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 150, // ارتفاع الـ Picker
                                    child: CupertinoPicker(
                                      itemExtent: 50, // ارتفاع كل عنصر
                                      scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          selectedIndex = index; // تحديث العنصر المختار
                                        });
                                      },
                                      children: letters.map((letter) {
                                        return Center(
                                          child: Text(
                                            letter,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          gradient: LinearGradient(colors: [Colors.deepOrange,Colors.pink,Colors.pinkAccent,Colors.purple])
                                      ),
                                      child:  Center(
                                        child: Text(
                                          'Confirm',
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(00)),
                           gradient: LinearGradient(colors: [Colors.deepOrange,Colors.pink,Colors.pinkAccent,Colors.purple])
                         ),
                          height:30,

                          child: Center(
                            child: Text(
                              ' ${letters[selectedIndex]}',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white54),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: authProviders.users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(authProviders.users[index].id),
                              // مفتاح فريد لكل عنصر
                              direction: DismissDirection.endToStart,
                              // اتجاه السحب
                              onDismissed: (direction) {
                                setState(() {
                                  authProviders.users.removeAt(index);
                                  FirebaseUtils.deleteDec(authProviders
                                      .currentUser?.id); // حذف العنصر من القائمة
                                  if (selectedCardIndex == index) {
                                    selectedCardIndex = null;
                                  }
                                });
                              },
                              background: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.black,
                                      Colors.black
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.delete,
                                        color: Colors.white, size: 30),
                                  ],
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedCardIndex == index) {
                                      selectedCardIndex =
                                          null; // إغلاق القائمة إذا تم النقر على نفس الكارد
                                    } else {
                                      selectedCardIndex = index;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(15),
                                  child: _buildCard(authProviders.users[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // طبقة التمويه
                  if (selectedCardIndex != null)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          // إغلاق القائمة عند الضغط على التمويه
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
                  // الكارد والقائمة يظهران معًا عند البلور
                  if (selectedCardIndex != null)
                    Positioned(
                      top: MediaQuery.of(context).size.height *
                          0.12, // موضع الكارد والقائمة
                      left: 20,
                      right: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCard(
                            authProviders.users[selectedCardIndex!],
                          ),
                          // عرض الكارد الذي تم تحديده
                          const SizedBox(height: 20),
                          _buildMenu(
                            authProviders.users[selectedCardIndex!],
                          ),
                          // عرض القائمة أسفل الكارد
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
  Widget _buildCard(
    MyUser user,
  ) {
    return CardUser(
      users: user,
      userId: user.id,
      score: 300,
      rank: 1,
    );
  }
  Widget _buildMenu(MyUser user) {
    return Menu(
      onCloseMenu: () {
        setState(() {
          selectedCardIndex = null; // إخفاء المنيو
        });
      },
      userId: user.id,
      weekNum: selectedIndex + 1,
    );
  }
}
