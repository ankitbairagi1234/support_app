import 'package:flutter/material.dart';
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;


  // eCatalogue design
  static late double containHeight;
  static late double containWidth;
  static late double containMiddleWidth;
  static late double containButtonHeight;
  static late double containButtonWidth;

  // Product list design
  static late double productContainHeight;
  static late double productViewButtonHeight;
  static late double productViewButtonWidth;

  static late double productImageWidth;
  static late double productImageHeight;

  static late double productMiddleWidth;
  static const SizedBox size = SizedBox(height: 20 ,);



  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // eCatalogue design
    containHeight = screenHeight*0.12;
    containWidth = screenHeight*0.070;
    containMiddleWidth = screenWidth*0.52;
    containButtonHeight = screenHeight*0.035;
    containButtonWidth = screenWidth*0.18;

    // Product list design
    productViewButtonHeight = screenHeight*0.035;
    productViewButtonWidth = screenWidth*0.14;
    productMiddleWidth = screenWidth*0.38;
    productContainHeight = screenHeight*0.12;
    productImageWidth = screenWidth*0.18;
    productImageHeight = screenHeight*0.12;


  }
}


// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
