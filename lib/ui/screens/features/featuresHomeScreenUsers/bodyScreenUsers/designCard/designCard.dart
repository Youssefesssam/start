import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/designCard/natification/natification.dart';

class DesignCard extends StatelessWidget {
  String titleCard = "";
  String? path;
  Color colorNatification = Colors.green;
  bool appearNatification = false;
  int numNatification;

  DesignCard({
    super.key,
    required this.titleCard,
    required this.appearNatification,
    required this.colorNatification,
    required this.numNatification,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
                color: Color(0x88e0e0e0),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleCard,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.all(5),
                        child: Image(image: AssetImage(path!)))),
              ],
            ),
          ),
          Positioned(
            top: -10,
            right: -8,
            child: Natification(
              color: colorNatification,
              appear: appearNatification,
              num: numNatification,
            ),
          ),
        ],
      ),
    );
  }
}
