import 'package:flutter/material.dart';

abstract class AppTheme{
 static  TextField textField = TextField (
  decoration: InputDecoration(
  labelText: "Name",
  suffixIcon: const Icon(Icons.account_circle_rounded),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
  hoverColor: Colors.black
  ),
  );

}