import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_formatting.dart';
import '../../../activity/data/models/activity_hive_model.dart';
import '../widgets/button_widget.dart';

class DetailScreen extends ConsumerWidget{
  ActivityHive activity;
  DetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final TextEditingController descriptionController = TextEditingController();
    descriptionController.text = activity.description;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF233971),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detail",
          style: GoogleFonts.nunitoSans(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      backgroundColor: Color(0xFF233971),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap:(){
                        Navigator.pushReplacementNamed(context, "/activity");
                      },
                      child: Text(
                        formatDate(activity.createdAt),
                        style: GoogleFonts.nunitoSans(
                            color: Color(0xFFF8D068),
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Text(
                  formatDuration(activity.endTime!.difference(activity.startTime)),
                  style: GoogleFonts.nunitoSans(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color : Colors.white
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Start Time",
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          formatTime(activity.startTime),
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          formatDate(activity.startTime),
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "End Time",
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          formatTime(activity.endTime),
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          formatDate(activity.endTime),
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 275,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.location_on_outlined,
                          size: 30,
                          color: Color(0xFFF8D068),
                        ),
                        Text(
                          "${activity.locationLat} ${activity.locationLng}",
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 16
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                      hintText: "Write your activity here...",
                      filled: true,
                      fillColor: Colors.white,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                saveDeleteState(ref, descriptionController, activity, context),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }
}