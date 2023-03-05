import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primarySwatch: Colors.cyan,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xffeeeeee),
        fontSize: 21,
        fontFamily: 'Montserrat Bold',
      ),
      displayMedium: TextStyle(
        color: Color(0xffeeeeee),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'OpenSans',
      ),
      displaySmall: TextStyle(
        color: Color(0xffaeaeae),
        fontSize: 14,
        fontFamily: 'OpenSans',
      ),
    ),
    scaffoldBackgroundColor: const Color(0xff222831),
    fontFamily: 'OpenSans',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan[300],
        foregroundColor: const Color(0xff222831),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 16,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.cyan,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.cyan,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 14,
        fontFamily: 'Montserrat Black',
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff323a47),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xffeeeeee),
      size: 21,
    ),
  );
}
