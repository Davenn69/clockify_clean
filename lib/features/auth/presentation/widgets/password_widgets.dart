import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showModalForForgotPassword(BuildContext context){
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
                    "Successfully sent reset password link",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Please check your mail!",
                    style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        color: Colors.grey.shade500
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // GestureDetector(
                  //   child: Text(data),
                  // )
                ],
              ),
            ),
          ),
        );
      }
  );
}

void showModalForPasswordError(BuildContext context, String data){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 350,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/cancel.png",
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    data,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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