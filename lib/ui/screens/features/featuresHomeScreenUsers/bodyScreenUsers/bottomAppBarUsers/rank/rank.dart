import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:star_t/firebase/authProvider.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rankCard.dart';
import 'package:star_t/ui/screens/homeScreen/homeScreenUsers.dart';
import 'package:star_t/utilites/appAssets.dart';
import 'package:star_t/utilites/appColors.dart';
import '../../../../../../../model/modelUser.dart';

class RankPage extends StatefulWidget {
  static const String routeName = 'rank';

  const RankPage({Key? key}) : super(key: key);

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  final RankProvider rankProvider = RankProvider();
  final AuthProviders authProviders = AuthProviders();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  Map<String, dynamic>? currentUserData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await rankProvider.fetchUserRanks();
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .doc(currentUser.uid)
          .get();
      setState(() {
        currentUserData = userDoc.data() as Map<String, dynamic>?;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.appBarColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, HomeScreenUsers.routeName);
          },
        ),
      ),
      body: isLoading
          ?  Center(child: Text("Loding...",style: TextStyle(color: AppColors.mainColor,fontSize: 25),))
          : SingleChildScrollView(
        child: Column(
          children: [
            // Top 3 leaderboard section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2nd place
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: rankProvider.userRanks.length > 1 &&
                              rankProvider.userRanks[1]['profileUrl'] != null &&
                              rankProvider.userRanks[1]['profileUrl'].toString().isNotEmpty
                              ? NetworkImage(rankProvider.userRanks[1]['profileUrl'])
                              : const AssetImage(AppAssets.profile) as ImageProvider,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rankProvider.userRanks.length > 1
                              ? rankProvider.userRanks[1]['name']
                              : 'N/A',
                          style: GoogleFonts.abrilFatface(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          rankProvider.userRanks.length > 1
                              ? '${rankProvider.userRanks[1]['score']} pts'
                              : 'N/A',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Image.asset(AppAssets.silver, height: 60, width: 60),
                      ],
                    ),
                  ),

                  // 1st place
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: rankProvider.userRanks.isNotEmpty &&
                              rankProvider.userRanks[0]['profileUrl'] != null &&
                              rankProvider.userRanks[0]['profileUrl'].toString().isNotEmpty
                              ? NetworkImage(rankProvider.userRanks[0]['profileUrl'])
                              : const AssetImage(AppAssets.profile) as ImageProvider,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rankProvider.userRanks.isNotEmpty
                              ? rankProvider.userRanks[0]['name']
                              : 'N/A',
                          style: GoogleFonts.abrilFatface(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          rankProvider.userRanks.isNotEmpty
                              ? '${rankProvider.userRanks[0]['score']} pts'
                              : 'N/A',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Image.asset(AppAssets.gold, height: 100, width: 100),
                      ],
                    ),
                  ),

                  // 3rd place
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: rankProvider.userRanks.length > 2 &&
                              rankProvider.userRanks[2]['profileUrl'] != null &&
                              rankProvider.userRanks[2]['profileUrl'].toString().isNotEmpty
                              ? NetworkImage(rankProvider.userRanks[2]['profileUrl'])
                              : const AssetImage(AppAssets.profile) as ImageProvider,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rankProvider.userRanks.length > 2
                              ? rankProvider.userRanks[2]['name']
                              : 'N/A',
                          style: GoogleFonts.abrilFatface(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          rankProvider.userRanks.length > 2
                              ? '${rankProvider.userRanks[2]['score']} pts'
                              : 'N/A',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Image.asset(AppAssets.bronze, height: 60, width: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Current user info
            if (currentUserData != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.appBarColor,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: currentUserData!['profileUrl'] != null &&
                          currentUserData!['profileUrl'].toString().isNotEmpty
                          ? NetworkImage(currentUserData!['profileUrl'])
                          : const AssetImage(AppAssets.profile) as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUserData!['name'] ?? 'Unknown',
                            style: GoogleFonts.adamina(
                                fontSize: 18, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('Points : ',
                                  style: GoogleFonts.abrilFatface(
                                      fontSize: 14, color: Colors.white)),
                              Text(
                                  '${rankProvider.getUserScore(currentUserData!['id'] ?? '')}',
                                  style: GoogleFonts.adamina(
                                      fontSize: 14, color: Colors.yellow)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text('Position : ',
                                  style: GoogleFonts.abrilFatface(
                                      fontSize: 14, color: Colors.white)),
                              Text(
                                  '${rankProvider.getUserRank(currentUserData!['id'] ?? '')}',
                                  style: GoogleFonts.adamina(
                                      fontSize: 14, color: Colors.yellow)),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                        '${rankProvider.getUserRank(currentUserData!['id'] ?? '')}#',
                        style: GoogleFonts.adamina(
                            fontSize: 35, color: Colors.yellow)),
                  ],
                ),
              ),

            // All users leaderboard
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rankProvider.userRanks.length,
              itemBuilder: (BuildContext context, int index) {
                final user = rankProvider.userRanks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RankCard(
                    name: user['name'],
                    rank: index + 1,
                    profileImage: user['profileUrl']?.isNotEmpty == true
                        ? user['profileUrl']
                        : AppAssets.profile,
                    score: user['score'],
                  ),
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

        DocumentSnapshot summarySnapshot = await FirebaseFirestore.instance
            .collection(MyUser.collection)
            .doc(userId)
            .collection("summary")
            .doc("weeklyScores")
            .get();

        int totalScore = 0;

        if (summarySnapshot.exists) {
          final data = summarySnapshot.data() as Map<String, dynamic>;
          totalScore = data['totalScore'] ?? 0;
        }

        final userData = userDoc.data() as Map<String, dynamic>;
        tempRanks.add({
          'id': userId,
          'name': userData['name'] ?? 'Unknown',
          'score': totalScore,
          'profileUrl': userData['profileUrl'] ?? '',
        });
      }

      tempRanks.sort((a, b) => b['score'].compareTo(a['score']));
      userRanks = tempRanks;
    } catch (e) {
      print('Error fetching user ranks: $e');
    }
  }

  int getUserRank(String userId) {
    final index = userRanks.indexWhere((user) => user['id'] == userId);
    return index + 1; // Adding 1 because ranks start at 1, not 0
  }

  int getUserScore(String userId) {
    final user = userRanks.firstWhere((user) => user['id'] == userId, orElse: () => {'score': 0});
    return user['score'];
  }
}