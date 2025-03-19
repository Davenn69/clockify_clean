import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showModalForLocationDenied(BuildContext context, String data){
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
                        "assets/images/alert.png"
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Location Error",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    data,
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