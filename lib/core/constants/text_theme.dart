import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/responsive_functions.dart';
import 'colors.dart';

class _TextTheme {
  final headline1 = GoogleFonts.nunitoSans(
      fontSize: 16.sp,
      color: Colors.white
  );

  final headline2 = GoogleFonts.nunitoSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold
  );

  final labelText1 = GoogleFonts.nunitoSans(
      fontSize: 16.sp,
      color: Colors.white
  );

  final labelText2 = GoogleFonts.nunitoSans(
      fontSize: 16.sp,
  );

  final buttonText1 = GoogleFonts.nunitoSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white
  );

  final buttonText2 = GoogleFonts.nunitoSans(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: colors.fontGrey.shade500
  );

  final link1 = GoogleFonts.nunitoSans(
      color: Colors.white,
      fontSize: 16.sp,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white
  );

  //Modal & dialogs

  final messageText1 = GoogleFonts.nunitoSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  final descriptionText1 = GoogleFonts.nunitoSans(
      fontSize: 18,
      color: colors.fontGrey.shade500
  );

  // Navigation Bar

  final navigationTextActive = GoogleFonts.nunitoSans(
      color: colors.secondary,
      fontWeight: FontWeight.bold,
      fontSize: 20.sp
  );

  final navigationTextInactive = GoogleFonts.nunitoSans(
      color: colors.fontGrey.shade500,
      fontWeight: FontWeight.bold,
      fontSize: 18.sp
  );

  // Timer related

  final timeDisplay = GoogleFonts.nunitoSans(
      fontSize: 38,
      fontWeight: FontWeight.bold,
      color : Colors.white
  );

  final timeDateHeadlineText = GoogleFonts.nunitoSans(
      fontSize: 12,
      color: Colors.white
  );

  final timeText = GoogleFonts.nunitoSans(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white
  );

  final dateText = GoogleFonts.nunitoSans(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white
  );

  final locationText = GoogleFonts.nunitoSans(
      color: Colors.white,
      fontSize: 12
  );

  final activityDescriptionText = GoogleFonts.nunitoSans(
      fontSize: 16,
      color: Colors.black
  );

  // Input text

  final inputHintText = GoogleFonts.nunitoSans(
      fontSize: 14,
      color: colors.fontGrey
  );

  // Dropdown

  final dropDownText = GoogleFonts.nunitoSans(
      color: Colors.black87
  );

  // Cards
   final durationText = GoogleFonts.nunitoSans(
       fontSize: 16,
       fontWeight: FontWeight.bold,
       color: Colors.white
   );

   final fromToTimeText = GoogleFonts.nunitoSans(
       fontSize: 12,
       color: colors.fontGrey
   );

   final historyText = GoogleFonts.nunitoSans(
       fontSize: 16,
       fontWeight: FontWeight.bold,
       color: Colors.white
   );

   final locationTextCard = GoogleFonts.nunitoSans(
       fontSize: 12,
       color: colors.fontGrey
   );

   final dateDisplayText = GoogleFonts.nunitoSans(
       color: colors.secondary,
       fontWeight: FontWeight.bold,
       fontSize: 18.sp
   );

   final durationDetailText = GoogleFonts.nunitoSans(
       fontSize: 28.sp,
       fontWeight: FontWeight.bold,
       color : Colors.white
   );

}

final textTheme = _TextTheme();