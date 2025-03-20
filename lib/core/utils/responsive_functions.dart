import 'package:flutter/cupertino.dart';

double settingSizeForScreen(BuildContext context, double sizePortrait, double sizeLandscape){
  Orientation orientation = MediaQuery.of(context).orientation;
  return orientation == Orientation.portrait ? sizePortrait : sizeLandscape;
}

Widget settingSizeForScreenSpaces(BuildContext context, double sizePortrait, double sizeLandscape){
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  Orientation orientation = MediaQuery.of(context).orientation;
  return orientation == Orientation.portrait ? SizedBox(height: screenHeight * sizePortrait) : SizedBox(height: screenHeight * sizeLandscape);
}

double settingSizeForText(BuildContext context, double sizePortrait, double sizeLandscape){
  Orientation orientation = MediaQuery.of(context).orientation;
  return orientation == Orientation.portrait ? sizePortrait : sizeLandscape;
}