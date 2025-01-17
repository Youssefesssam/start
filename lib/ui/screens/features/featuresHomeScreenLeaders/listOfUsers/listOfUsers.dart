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
   ListOfUsers({super.key,});

  @override
  State<ListOfUsers> createState() => _ListOfUsers();
}

class _ListOfUsers extends State<ListOfUsers> {
  int? selectedCardIndex;
  int selectedIndex = 0; // القيمة الافتراضية

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProviders>(context, listen: false).readUsersToLeaders();
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);
    DataProvider dataProvider = Provider.of(context);
    dataProvider.getDataFromFirebase(authProviders.currentUser?.id ?? "");
    return Container(
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        gradient: LinearGradient(colors: [Colors.teal[800]!, Colors.grey[900]!],     begin: Alignment.bottomCenter,

      ),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: authProviders.users.isEmpty
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
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
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.teal.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.teal,
                        size: 35,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(color: Colors.teal),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.teal,
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: authProviders.users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(authProviders.users[index].id),
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
                              Icon(Icons.delete, color: Colors.white, size: 30),
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
                            child: _buildCard(authProviders.users[index]),
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
                    _buildCard(authProviders.users[selectedCardIndex!]),
                    const SizedBox(height: 20),
                    _buildMenu(authProviders.users[selectedCardIndex!]),
                  ],
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

  Widget _buildMenu(MyUser user) {
    return Menu(
      onCloseMenu: () {
        setState(() {
          selectedCardIndex = null;
        });
      },
      userId: user.id,
      weekNum: selectedIndex + 1, // استخدام القيمة المستلمة هنا
    );
  }
}