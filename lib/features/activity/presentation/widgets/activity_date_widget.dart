import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/date_formatting.dart';

Widget activityDateWidget(DateTime date){
  return SizedBox(
      width: double.infinity,
      child: Container(
        color: Colors.white.withAlpha(50),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            formatDate(date),
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF8D068)
            ),
          ),
        ),
      )
  );
}