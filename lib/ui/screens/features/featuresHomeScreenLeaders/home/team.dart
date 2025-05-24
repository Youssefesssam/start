import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:star_t/utilites/appAssets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../utilites/appColors.dart';

class Team extends StatefulWidget {
  static const String routeName = 'Team';
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  String? _selectedTalent;
  bool _showAll = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  void openWhatsApp(String whatsapp)async{
    await launchUrl(Uri.parse("https://wa.me/+2$whatsapp?text= اهلين"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا يوجد أعضاء في الفريق بعد'));
          }

          final users = snapshot.data!.docs;
          final talents = <String>{};

          for (var user in users) {
            final talent = user['talent'] as String?;
            if (talent != null && talent.isNotEmpty && talent.length > 2) {
              talents.add(talent);
            }
          }

          final filteredUsers = _searchQuery.isEmpty
              ? users
              : users.where((user) {
            final name = user['name']?.toString().toLowerCase() ?? '';
            final talent = user['talent']?.toString().toLowerCase() ?? '';
            return name.contains(_searchQuery.toLowerCase()) ||
                talent.contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              _buildTalentsFilterSection(talents.toList()),
              Expanded(
                child: _buildMembersSection(
                  filteredUsers,
                  _showAll
                      ? talents.toList()
                      : (_selectedTalent != null ? [_selectedTalent!] : talents.toList()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildTalentsFilterSection(List<String> talents) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue!, Colors.blue[800]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                InkWell(
                  onTap:(){
                    Navigator.pop(context);
                  },

                    child: Icon(Icons.arrow_back_ios, color: Colors.white)),
                Text(
                  'Talent',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(

              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: "ابحث عن عضو أو موهبة...",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear, color: Colors.white, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                            _searchFocusNode.unfocus();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Filters for talents and Show All button
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FilterChip(
                    backgroundColor: _showAll ? Colors.blue[300]! : Colors.blue[100]!,
                    selectedColor: Colors.blue[300],
                    label: Text(
                      _showAll ? 'إلغاء الكل' : 'عرض الكل',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _showAll ? Colors.white : Colors.teal[800]),
                    ),
                    selected: _showAll,
                    onSelected: (isSelected) {
                      setState(() {
                        _showAll = isSelected;
                        if (_showAll) {
                          _selectedTalent = null;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: talents.length,
                    itemBuilder: (context, index) {
                      String talent = talents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FilterChip(
                          backgroundColor: _selectedTalent == talent ? Colors.blue[300]! : Colors.blue[100]!,
                          selectedColor: Colors.teal[300],
                          label: Text(
                            talent,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _selectedTalent == talent ? Colors.white : Colors.blue[800]),
                          ),
                          selected: _selectedTalent == talent,
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                _selectedTalent = talent;
                                _showAll = false;
                              } else {
                                if (_selectedTalent == talent) {
                                  _selectedTalent = null;
                                }
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // باقي الدوال (_buildMembersSection, _buildMemberCard, _buildUserAvatar) تبقى كما هي
  Widget _buildMembersSection(List<QueryDocumentSnapshot> users, List<String> talents) {
    if (_searchQuery.isNotEmpty && users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد نتائج مطابقة للبحث',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: talents.length,
      itemBuilder: (context, index) {
        String talent = talents[index];
        final talentUsers = users.where((user) => user['talent'] == talent).toList();

        if (talentUsers.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              margin: const EdgeInsets.only(top: 16.0),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                border: Border(
                  left: BorderSide(
                    color: Colors.blue[400]!,
                    width: 4,
                  ),
                ),
              ),
              child: Text(
                'موهبة: $talent (${talentUsers.length} عضو)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            ...talentUsers.map((user) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildMemberCard(user),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildMemberCard(QueryDocumentSnapshot user) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.blue.withOpacity(0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.blue.withOpacity(0.1),
          onTap: () {
            // تفاصيل العضو
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildUserAvatar(user),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? 'بدون اسم',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (user['university'] != null && user['university'].isNotEmpty)
                        Text(
                          user['university'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline, color: Colors.blue[400]),
                  onPressed: () {
                    openWhatsApp(user['whatsapp']);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(QueryDocumentSnapshot user) {
    final profileUrl = user['profileUrl'] as String?;

    return CircleAvatar(
      radius: 35,
      backgroundImage: profileUrl != null && profileUrl.isNotEmpty
          ? (profileUrl.startsWith('http') || profileUrl.startsWith('https')
          ? NetworkImage(profileUrl) as ImageProvider
          : AssetImage(profileUrl))
          : const AssetImage(AppAssets.profile),
    );
  }
}