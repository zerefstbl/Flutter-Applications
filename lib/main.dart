import 'package:flutter/material.dart';
import 'package:giphy_search/ui/home_page.dart';
import 'package:giphy_search/pages/view_page.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          )
        )
      )
    ),
  ));
}
