import 'package:clockify_miniproject/features/activity/application/notifiers/history_hive_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../activity/data/models/activity_hive_model.dart';

void showModal(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 350,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                        "assets/images/success-medium.png"
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Success",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Activity has been successfully updated.",
                    style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        color: Colors.grey.shade500
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
  );
}

void showModalToConfirm(BuildContext context, ActivityHive activity, String token, String type, double lat, double lng, HistoryHiveStateNotifier historyNotifier){
  showDialog(context: context, builder: (BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: SizedBox(
        width: 350,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:20),
              SizedBox(
                width: 75,
                height: 75,
                child: Image.asset(
                    "assets/images/alert.png"
                ),
              ),
              SizedBox(height: 50),
              Text(
                "You are about to delete a data",
                style: GoogleFonts.nunitoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Are you sure?",
                style: GoogleFonts.nunitoSans(
                    fontSize: 18,
                    color: Colors.grey.shade500
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        "Cancel",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black54
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        historyNotifier.deleteContent(activity.uuid, token, type, lat, lng);
                        showModalForDeleted(context);
                      });
                    },
                    child: Text(
                        "Delete",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  });
}
void showModalForDeleted(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 350,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                        "assets/images/success-medium.png"
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Success",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Activity has been successfully deleted.",
                    style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        color: Colors.grey.shade500
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
  );
}