import 'package:flutter/widgets.dart';

class SizeConfig{
  static double screenHeight = 0;
  static double screenWidth = 0;

  void init(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    screenHeight = mediaQuery.size.height/100;
    screenWidth = mediaQuery.size.width/100;
  }

  static double sizeVertical(double percentage) {
    return screenHeight * percentage;
  }

  static double sizeHorizontal(double percentage) {
    return screenWidth * percentage;
  }
}