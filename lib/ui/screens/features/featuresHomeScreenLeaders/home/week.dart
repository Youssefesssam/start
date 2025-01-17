import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Week extends StatefulWidget {
   Week({super.key});

  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
  final List<String> letters = [
    'week 1', 'week 2'   , 'week 3', 'week 4',
    'week 5', 'week 6', 'week 7','week 8',
    'week 9', 'week 10'  , 'week 11', 'week 12', 'week 13',
    'week 14', 'week 15' , 'week 16', 'week 17', 'week 18',
    'week 19', 'week 20 ' , 'week 21', 'week 22', 'week 23',
    'week 24', 'week 25' , 'week 26', 'week 27', 'week 28',
    'week 29', 'week 30' , 'week 31', 'week 32', 'week 33',
    'week 34', 'week 35' , 'week 36', 'week 37', 'week 38',
    'week 39', 'week 40' , 'week 41', 'week 42', 'week 43',
    'week 44', 'week 45' , 'week 46', 'week 47','week 48',
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                colors: [
                  Colors.teal[800]!,
                  Colors.teal[600]!,
                  Colors.cyan[700]!,
                  Colors.cyan[500]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          const Text(
            'Select Week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 50,
              scrollController: FixedExtentScrollController(initialItem: selectedIndex),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedIndex = index;
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
              Navigator.pop(context, selectedIndex);
            },
            child: Container(
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [
                    Colors.teal[800]!,
                    Colors.teal[600]!,
                    Colors.cyan[700]!,
                    Colors.cyan[500]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
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
      ));
  }
}
