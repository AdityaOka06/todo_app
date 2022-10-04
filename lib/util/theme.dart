import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor:const Color(0xff2E3440),
  primaryColor:const Color(0xff5E81AC),
  iconTheme: const IconThemeData(
    // color: Color(0xff141a1b),
    color: Color(0xff5E81AC),
  ),
  appBarTheme: const AppBarTheme(
    // backgroundColor: Color(0xff424853),
    backgroundColor: Color(0xff3B4252),
    centerTitle: true,
    elevation: 0.0
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xff5E81AC),
    textTheme: ButtonTextTheme.normal,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xff424853),
    elevation: 5.0,
    contentTextStyle: TextStyle(
      color: Color(0xffb7bbc3),
    )
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          color: Color(0xff5E81AC),
        ),
      )
    ),
  ),
  elevatedButtonTheme:const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll<Color>(
         Color(0xff5E81AC),
      ),
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          color: Color(0xffdee5ee),
        ),
      )
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffb7bbc3)
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffb7bbc3),
      ),
    ),
  ),
);