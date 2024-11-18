import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';
import '../bodyScreenUsers/designCard/designCard.dart';

class Aword extends StatefulWidget {
  Color color;
  String path;
  String titleCard;
  Color colorNatification;
  bool appearNatification;
  int numNatification;

  Aword({
    super.key,
    required this.titleCard,
    required this.color,
    required this.path,
    required this.numNatification,
    required this.colorNatification,
    required this.appearNatification,
  });

  @override
  State<Aword> createState() => _ContentsState();
}

class _ContentsState extends State<Aword> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        StatusAlert.show(
          backgroundColor: const Color(0x8e9d9696),
          borderRadius: BorderRadius.circular(40),
          context,
          duration: const Duration(seconds: 5),
          configuration: const WidgetConfiguration(
            widget: Column(
              children: [
                Center(
                    child: Text("الكلمه",
                        style: TextStyle(
                            fontSize: 50,
                            color: Color(0xfffbb800),
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 20,
                ),
                Text("Aword for week",
                    style: TextStyle(
                        fontSize: 30,
                        color: Color(0xfffbb800),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          maxWidth: 260,
        );
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
