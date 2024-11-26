import 'package:flutter/material.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenUsers/Contents/achive/screenAchive.dart';
import '../../bodyScreenUsers/designCard/designCard.dart';
class Achive extends StatefulWidget {
  Color color;
  String path;
  String titleCard;
  Color colorNatification;
  bool appearNatification;
  int numNatification;

  Achive({
    super.key,
    required this.titleCard,
    required this.color,
    required this.path,
    required this.numNatification,
    required this.colorNatification,
    required this.appearNatification,
  });

  @override
  State<Achive> createState() => _AchiveState();
}

class _AchiveState extends State<Achive> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       Navigator.pushNamed(context, ScreenAchive.routeName);
      },
      child: DesignCard(
        path: widget.path,
        titleCard: widget.titleCard,
        appearNatification: widget.appearNatification,
        colorNatification: widget.colorNatification,
        numNatification: widget.numNatification,
      ),
    );
  }
}
