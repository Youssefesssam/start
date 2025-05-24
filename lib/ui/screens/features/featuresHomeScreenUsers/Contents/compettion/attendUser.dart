import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import '../../../../../../firebase/fireBase/fireBaseForUser/fireBaseGetDataForUser.dart';
import '../../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import 'cardAbsent.dart';

class AttendUser extends StatefulWidget {
  const AttendUser({super.key});

  @override
  State<AttendUser> createState() => _AttendUserState();
}

class _AttendUserState extends State<AttendUser> {
  late int currentWeek;
  final List<String> month = [
    "",
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();

    FireBaseGetDataForLeader.fetchCurrentWeek().then((weekNum) {
      setState(() {
        currentWeek = weekNum;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of<AuthProviders>(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
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
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Absent",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Icon(
                            Icons.battery_charging_full,
                            size: 30,
                            color: Colors.teal,
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Event Card
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],

                        ),
                        child:  Container(
                          margin: const EdgeInsets.only(top: 10,left: 10,bottom: 10,right: 10),

                          child:     StreamBuilder<List<int>>(
                            stream: authProviders.streamAbsentTimes(currentWeek), // استدعاء streamAbsentTimes
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator()); // ⏳ تحميل البيانات
                              } else if (snapshot.hasError) {
                                return const Center(child: Text("Error loading data")); // ❌ في حالة الخطأ
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text("No absences found")); // 🟢 لا يوجد غياب
                              }

                              List<int> validAbsentWeeks = snapshot.data!; // ✅ الحصول على الأسابيع الغائبة

                              return Container(
                                  margin: const EdgeInsets.only(top: 15,left: 15,bottom: 10,right: 10),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Month : ${month[(currentWeek-1)~/4+1]}",style: GoogleFonts.abhayaLibre(color: Colors.teal[700],fontWeight: FontWeight.bold,fontSize: 25)),
                                      SizedBox(height: 10,),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: validAbsentWeeks.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return validAbsentWeeks[index]%2==0 ?Column(
                                            children: [
                                              CardAbsent(validAbsentWeeks: validAbsentWeeks[index],),
                                              SizedBox(height: 10,),
                                              Center(child: Text('Send Natification For Leader',style: TextStyle(color: Colors.red,fontSize: 10),)),
                                            ],
                                          ):
                                          Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              CardAbsent(validAbsentWeeks: validAbsentWeeks[index],),
                                              SizedBox(height: 10,),

                                            ],
                                          );
                                        },
                                      ),



                                    ],
                                  ));
                            },
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}