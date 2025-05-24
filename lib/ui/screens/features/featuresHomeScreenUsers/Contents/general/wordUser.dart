import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/dataProvider.dart';
import '../../../../../../firebase/fireBase/fireBaseForUser/fireBaseGetDataForUser.dart';
import '../../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import '../../../../../../firebase/providerTotalScore.dart';
import '../../../../../../utilites/appTexts.dart';
import '../../../../../../utilites/consts.dart';

class WordUser extends StatefulWidget {
  const WordUser({super.key});

  @override
  State<WordUser> createState() => _WordUserState();
}

class _WordUserState extends State<WordUser> {
  @override
  bool isFirstSeen = AppTexts.seenWord;

  Widget build(BuildContext context) {

    ProviderTotalScore providerTotalScore =
        Provider.of<ProviderTotalScore>(context, listen: false);
    DataProvider dataProvider = Provider.of(context);
    AuthProviders authProviders = Provider.of(context);

    return Container(
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
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Text(
                  " the word that will be said next week",
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: FireBaseGetDataForUser.fetchMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child:
                              Text(' wrong: ${snapshot.error}')); // عرض الخطأ
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('no messages')); // إذا لم توجد بيانات
                    }
                    final messages = snapshot.data!.docs;
                    return Column(
                      children: [
                        const SizedBox(height: 30),

                        // صورة رمزية لحدث
                        Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.teal[300]!, Colors.teal[100]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mail_outline_sharp,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.24,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const RangeMaintainingScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final text = message['message']; // نص الرسالة
                              final sender = message['sender']; // اسم المرسل
                              final timestamp = message['Time']; // وقت الرسالة
                              return Center(
                                child: ListTile(
                                  title: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .065,
                                        ),
                                        Text(
                                          text,
                                          style: GoogleFonts.abyssinicaSil(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                  width: MediaQuery.of(context).size.width * .5,
                  child: Center(child: Builder(
                    builder: (context) {
                      final GlobalKey<SlideActionState> _key =
                      GlobalKey();
                      return Padding(
                        padding: const EdgeInsets.all(.1),
                        child: SlideAction(
                          innerColor: Colors.white,
                          sliderButtonIconPadding: 2,
                          sliderButtonIcon: const Icon(
                            Icons.person,
                            size: 22,
                            color: Colors.teal,
                          ),
                          submittedIcon: const Icon(
                            Icons.favorite,
                            size: 20,
                            color: Colors.white,
                          ),
                          outerColor: Colors.teal,
                          enabled: true,
                          elevation: 0,
                          textColor: Colors.white,
                          sliderRotate: true,
                          height: 80,
                          key: _key,
                          onSubmit: () async {
                            await Consts.getWordId();
                            CollectionReference wordRef = FirebaseFirestore.instance.collection('word');
                            QuerySnapshot snapshot = await wordRef.get();

                            if (snapshot.docs.isNotEmpty) {
                              var doc = snapshot.docs.first;
                              String docId = doc.id;
                              if (doc.id != authProviders.wordId || authProviders.wordId == null) {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString("wordId", docId);
                                authProviders.setwordId(docId);

                                int currentScore = await FireBaseSetDataForUser.getScore(
                                  yearId: '1',
                                  weekId: authProviders.week.toString(),
                                  monthId: authProviders.currentMonth.toString(),
                                  scoreType: 'scoreSeenUserWord',
                                  userId: authProviders.userId!,
                                );
                                int updatedScore = currentScore + 5;
                                await FireBaseSetDataForLeader.updateScore(
                                  yearId: '1',
                                  weekId: authProviders.week.toString(),
                                  monthId: authProviders.currentMonth.toString(),
                                  newValue: updatedScore,
                                  scoreType: 'scoreSeenUserWord',
                                  userId: authProviders.userId!,
                                );
                              }
                            }
                          },
                          child: Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                child: Text(
                                  "Seen",
                                  style: GoogleFonts.aboreto(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
