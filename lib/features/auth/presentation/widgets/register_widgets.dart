import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/email_validation.dart';
import '../../../../core/utils/password_validation.dart';

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
              child: SingleChildScrollView(
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
                      "Your account has been successfully created.",
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
          ),
        );
      }
  );
}

Widget inputTextForEmail(TextEditingController controller, String labelText, GlobalKey<FormState> key){
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    validator: validateEmail,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
    ],
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.nunitoSans(
          fontSize: 20
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF233971).withAlpha(128), width: 2)
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF233971), width:2)
      ),
    ),
  );
}

Widget inputTextForPassword(WidgetRef ref, TextEditingController controller, String labelText, StateProvider<bool> provider, GlobalKey<FormState> key){
  final bool isVisible = ref.watch(provider);
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.visiblePassword,
    validator: validatePassword,
    obscureText: !isVisible,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
    ],
    decoration: InputDecoration(
        labelText: "Input your password",
        labelStyle: GoogleFonts.nunitoSans(
            fontSize: 20
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF233971).withAlpha(128), width: 2)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF233971), width:2)
        ),
        suffixIcon: GestureDetector(
            onTap: (){
              ref.read(provider.notifier).state = !isVisible;
            },
            child: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
        )
    ),
  );
}

Widget inputTextForConfirmPassword(WidgetRef ref, TextEditingController controller, String labelText, StateProvider<bool> provider, TextEditingController controller2){
  final bool isVisible = ref.watch(provider);
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.visiblePassword,
    validator: (value) => validateConfirmPassword(value, controller2.text),
    obscureText: !isVisible,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
    ],
    decoration: InputDecoration(
        labelText: "Input your password",
        labelStyle: GoogleFonts.nunitoSans(
            fontSize: 20
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF233971).withAlpha(128), width: 2)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF233971), width:2)
        ),
        suffixIcon: GestureDetector(
            onTap: (){
              ref.read(provider.notifier).state = !isVisible;
            },
            child: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
        )
    ),
  );
}

void showModalForRegisterError(BuildContext context, String data){
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