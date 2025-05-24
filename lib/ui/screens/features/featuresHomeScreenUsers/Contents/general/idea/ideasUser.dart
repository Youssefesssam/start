import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/authProvider.dart';
import 'package:audioplayers/audioplayers.dart'; // 🎵

import '../../../../../../../firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/fireBaseGetDataForUser.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import 'countdownTimer.dart';

class IdeasUser extends StatefulWidget {
  IdeasUser({super.key});

  @override
  State<IdeasUser> createState() => _IdeasUserState();
}

class _IdeasUserState extends State<IdeasUser> with TickerProviderStateMixin {
  late int currentWeek;
  bool isVotingFinished = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchWeekNumber();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  Future<void> _fetchWeekNumber() async {
    int week = await FireBaseGetDataForLeader.fetchCurrentWeek();
    setState(() {
      currentWeek = week;
    });
  }

  void _playWinSound() async {
    await _audioPlayer.play(AssetSource('sounds/win.mp3')); // 👈 ضع ملف win.mp3 داخل assets/sounds
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Text(
              "Voting on opinion",
              style: GoogleFonts.aboreto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: CountdownTimer(
                currentWeekNumber: currentWeek,
                onTimerFinished: (bool finished) {
                  setState(() {
                    isVotingFinished = finished;
                  });
                  if (finished) {
                    _controller.forward();
                    _playWinSound();
                  }
                },
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FireBaseGetDataForUser.fetchOpinion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No opinions found.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  List opinions = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>? ?? {};
                    return {
                      'id': doc.id,
                      'opinion': data['opinion'] ?? 'No content',
                      'votes': data['votes'] ?? 0,
                      'voters': List<String>.from(data['voters'] ?? [])
                    };
                  }).toList();

                  opinions.sort((a, b) => (b['votes'] as int).compareTo(a['votes'] as int));

                  if (!isVotingFinished) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: opinions.length,
                      itemBuilder: (context, index) {
                        final opinion = opinions[index];
                        final hasVoted = opinion['voters'].contains(authProviders.userId);

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              opinion['opinion'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[800],
                              ),
                            ),
                            subtitle: Text(
                              'Votes: ${opinion['votes']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                hasVoted ? Icons.favorite : Icons.favorite_border,
                                color: hasVoted ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                FireBaseSetDataForUser.upvoteOpinion(
                                  opinion['id'],
                                  authProviders.userId!,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    final topOpinion = opinions.first;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                           Text(
                            "تم انتهاء التصويت لهذا الأسبوع ✅",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]!,
                            ),
                          ),
                          const SizedBox(height: 20),

                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListTile(
                                  leading: const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
                                  title: Text(
                                    topOpinion['opinion'],
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Total Votes: ${topOpinion['votes']}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}