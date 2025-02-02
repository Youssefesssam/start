import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../firebase/firebase.dart';

class IdeasUser extends StatelessWidget {
   IdeasUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
              ),
              Text("Voting opinion",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,),
              const SizedBox(height: 10),

              StreamBuilder<QuerySnapshot>(
                stream:FirebaseUtils.fetchOpinion(),
                builder: (context, snapshot) {

                  if (snapshot.hasError) {
                    return Center(child: Text(' wrong: ${snapshot.error}')); // عرض الخطأ
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('no messages')); // إذا لم توجد بيانات
                  }
                  final opinions = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const RangeMaintainingScrollPhysics(),
                    itemCount: opinions.length,
                    itemBuilder: (context, index) {
                      final opinion = opinions[index];
                      final text = opinion['opinion'];

                      return  Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            radius: 25,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10,
                                      left: 15,
                                      right: 10,
                                      bottom: 3),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight:
                                        Radius.circular(20),
                                        topLeft:
                                        Radius.circular(20),
                                        topRight:
                                        Radius.circular(20)),
                                    color: Color(0x6fa6a3a3),
                                  ),
                                  child:ListTile(
                                    title: Text(
                                      text,
                                      style: GoogleFonts.abyssinicaSil(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal[800],
                                      ),
                                    ),
                                  )
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5,
                                          left: 15,
                                          right: 5,
                                          bottom: 3),
                                      padding:
                                      const EdgeInsets.all(5),
                                      decoration:
                                      const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(
                                                20),
                                            bottomLeft:
                                            Radius.circular(
                                                20),
                                            topLeft:
                                            Radius.circular(
                                                0),
                                            topRight:
                                            Radius.circular(
                                                20)),
                                        color: Color(0x6fa6a3a3),
                                      ),
                                      child: const Text(
                                        "520",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration:
                                      const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(
                                                20),
                                            bottomLeft:
                                            Radius.circular(
                                                20),
                                            topLeft:
                                            Radius.circular(
                                                0),
                                            topRight:
                                            Radius.circular(
                                                20)),
                                        color: Colors.green,
                                      ),
                                      child: Center(
                                          child: Icon(
                                            Icons.lightbulb_outlined,
                                            color: Colors.white,
                                            size: 15,
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                      ;
                    },
                  );
                },
              ),

         SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(50)),
                  color: Colors.teal,
                ),
                child: const Center(
                    child:Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,)
                ),
              ),
            ),

          ],
        )
            ],
          ),
        ),
      ),
    );
  }
}
