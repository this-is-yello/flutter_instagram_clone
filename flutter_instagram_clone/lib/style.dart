import 'package:flutter/material.dart';

var theme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.white,
    actionsIconTheme: IconThemeData(color: Colors.black, size: 30),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
  ),
  textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black, fontSize: 24)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
  )
);