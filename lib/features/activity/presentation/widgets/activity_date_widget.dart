import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/date_formatting.dart';

class ActivityDateWidget extends StatefulWidget{
  final DateTime date;
  bool isLoading;

  ActivityDateWidget({super.key, required this.date, this.isLoading = false});

  @override
  State<ActivityDateWidget> createState() => ActivityDateWidgetState();
}

class ActivityDateWidgetState extends State<ActivityDateWidget>{
  @override
  Widget build(BuildContext context){
    return SizedBox(
        width: double.infinity,
        child: Container(
          color: Colors.white.withAlpha(50),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              formatDate(widget.date),
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  color: colors.secondary
              ),
            ),
          ),
        )
    );
  }
}
// Widget activityDateWidget(DateTime date, {bool isLoading = false}){
//   return SizedBox(
//       width: double.infinity,
//       child: Container(
//         color: Colors.white.withAlpha(50),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//           child: Text(
//             formatDate(date),
//             style: GoogleFonts.nunitoSans(
//                 fontWeight: FontWeight.bold,
//                 color: colors.secondary
//             ),
//           ),
//         ),
//       )
//   );
// }