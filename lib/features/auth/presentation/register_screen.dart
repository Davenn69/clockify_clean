import 'dart:async';
import 'package:clockify_miniproject/core/navigation/navigation_service.dart';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:clockify_miniproject/features/auth/presentation/widgets/register_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/responsive_functions.dart';
import '../application/providers/register_providers.dart';


class RegisterScreen extends ConsumerWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 30,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      settingSizeForScreenSpaces(context, 0.04, 0),
                      SizedBox(
                        width: settingSizeForScreen(context, 270, 150),
                        child: FittedBox(
                          child: Text(
                            "Create New Account",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 28,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      settingSizeForScreenSpaces(context, 0.03, 0.01),
                      inputTextForEmail(context, _emailController, "Input your email", formKey),
                      settingSizeForScreenSpaces(context, 0.04, 0.03),
                      inputTextForPassword(context, ref, _passwordController, "Create your password", isPasswordVisible, formKey),
                      settingSizeForScreenSpaces(context, 0.04, 0.03),
                      inputTextForConfirmPassword(context, ref, _confirmPasswordController, "Confirm your password", isConfirmPasswordVisible, _passwordController),
                      settingSizeForScreenSpaces(context, 0.35, 0.05),
                      Container(
                        width: settingSizeForScreen(context, 400, 100),
                        height: settingSizeForScreen(context, 60, 40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                                color: Colors.black87.withAlpha(48),
                                offset: Offset(0, 2),
                                blurRadius: 10
                            )],
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xFF45CDDC),
                                  Color(0xFF2EBED9),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter
                            )
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent
                          ),
                          onPressed: (){
                            if (formKey.currentState!.validate()) {
                              final contextRef = context;

                              showDialog(
                                context: contextRef,
                                barrierDismissible: false,
                                builder: (context) => Center(child: CircularProgressIndicator()),
                              );

                              ref.read(registerUserDataProvider({'email': _emailController.text, 'password': _passwordController.text, 'confirmPassword' : _confirmPasswordController.text}).future).then((data) {
                                if(data['error'] == "Unknown error occurred"){
                                  WidgetsBinding.instance.addPostFrameCallback((_){
                                    Navigator.pop(contextRef);
                                    showModalForRegisterError(context, "Unknown error occurred");
                                    return;
                                  });
                                }else if(data['status']=='fail'){
                                  if(data['errors']['email'] != null){
                                    WidgetsBinding.instance.addPostFrameCallback((_){
                                      Navigator.pop(contextRef);
                                      showModalForRegisterError(context, "Email already exists");
                                    });
                                  }else if(data['errors']['password']!=null){
                                    WidgetsBinding.instance.addPostFrameCallback((_){
                                      Navigator.pop(contextRef);
                                      showModalForRegisterError(context, 'Password has to be strong!');
                                    });
                                  }
                                }else{
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pop(contextRef);
                                    showModal(contextRef);
                                    Timer(Duration(seconds: 2), () {
                                      Navigator.pushReplacement(contextRef, NavigationService.createRouteForRegisterToLoginScreen());
                                    });
                                  });
                                }
                              }).catchError((error) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pop(contextRef);
                                  showDialog(
                                    context: contextRef,
                                    builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(error.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(contextRef);
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              });
                            }
                          },
                          child: Text(
                            "OK",
                            style: GoogleFonts.nunitoSans(
                                fontSize: settingSizeForText(context, 20, 16),
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}