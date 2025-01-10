import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rankCard.dart';
import 'package:star_t/utilites/appAssets.dart';
import '../../../../../../../model/modelUser.dart';
import '../../../../../../../model/modelYear.dart';

class RankPage extends StatefulWidget {
  static const String routeName = 'rank';

  const RankPage({Key? key}) : super(key: key);

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  final RankProvider rankProvider = RankProvider();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await rankProvider.fetchUserRanks();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Rank',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown, Colors.brown],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top 3 leaderboard section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: rankProvider.fetchUserRanks(), // تأكد من أن البيانات يتم جلبها بشكل صحيح
                builder: (context, snapshot) {

                  // استخراج المراكز الثلاثة الأولى
                  var topRanks = rankProvider.userRanks.take(3).toList();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 3rd place
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(AppAssets.profile),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            topRanks.length > 2 ? topRanks[2]['name'] : 'N/A',
                            style: GoogleFonts.abrilFatface(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            topRanks.length > 2 ? '${topRanks[2]['score']} points' : 'N/A',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: 80,
                            width: 80,
                            child: Image.asset(AppAssets.bronze), // Rank image
                          ),
                        ],
                      ),
                      // 1st place
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(AppAssets.profile),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            topRanks.isNotEmpty ? topRanks[0]['name'] : 'N/A',
                            style: GoogleFonts.abrilFatface(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            topRanks.isNotEmpty ? '${topRanks[0]['score']} points' : 'N/A',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: 180,
                            width: 160,
                            child: Image.asset(AppAssets.gold), // Rank image
                          ),
                        ],
                      ),
                      // 2nd place
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(AppAssets.profile),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            topRanks.length > 1 ? topRanks[1]['name'] : 'N/A',
                            style: GoogleFonts.abrilFatface(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            topRanks.length > 1 ? '${topRanks[1]['score']} points' : 'N/A',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: 80,
                            width: 80,
                            child: Image.asset(AppAssets.silver), // Rank image
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            // Current user info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown.withOpacity(.9), Colors.brown.withOpacity(0.4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(AppAssets.profile),
                          ),
                          Text(
                            'Warren',
                            style: GoogleFonts.adamina(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Points:',
                            style: GoogleFonts.abrilFatface(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            '258',
                            style: GoogleFonts.adamina(fontSize: 18, color: Colors.yellow),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Position: ',
                            style: GoogleFonts.abrilFatface(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            '258',
                            style: GoogleFonts.adamina(fontSize: 18, color: Colors.yellow),
                          )
                        ],
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),

            // Other leaderboard items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rankProvider.userRanks.length,
              itemBuilder: (BuildContext context, int index) {
                final user = rankProvider.userRanks[index];
                return RankCard(
                  name: user['name'],
                  rank: index + 1,
                  profileImage: AppAssets.profile, // Profile image path
                  score: user['score'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RankProvider {
  List<Map<String, dynamic>> userRanks = [];

  Future<void> fetchUserRanks() async {
    try {
      QuerySnapshot userSnapshot =
      await FirebaseFirestore.instance.collection(MyUser.collection).get();

      List<Map<String, dynamic>> tempRanks = [];

      for (var userDoc in userSnapshot.docs) {
        String userId = userDoc.id;

        QuerySnapshot yearSnapshot = await FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(userId)
            .collection(ModelYear.collection)
            .get();

        int totalScore = yearSnapshot.docs.fold(0, (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          return sum + (data['TotalScoreOfYear'] ?? 0) as int;
        });

        final userData = userDoc.data() as Map<String, dynamic>;
        tempRanks.add({
          'id': userId,
          'name': userData['name'] ?? 'Unknown',
          'score': totalScore,
        });
      }

      tempRanks.sort((a, b) => b['score'].compareTo(a['score']));

      userRanks = tempRanks;
    } catch (e) {
      print('Error fetching user ranks: $e');
    }
  }
}
