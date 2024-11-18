import 'package:flutter/material.dart';

class Natification extends StatelessWidget {
  Color color =Colors.green;
  bool appear =false;
  int num ;
   Natification({
  super.key,
  required this.color,
  required this.num,
  required this.appear});
  @override
  Widget build(BuildContext context) {
    return  appear == true ? Container (
      width: 22,
      height: 22,
      decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(50)),
      child:  Center(
          child: Text(
            "${num}",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          )),
    ):Container (
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50)),
    );
  }
}
