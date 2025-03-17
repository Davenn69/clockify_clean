import 'dart:async';
import 'package:clockify_miniproject/core/navigation/navigation_service.dart';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:clockify_miniproject/features/auth/presentation/widgets/register_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../application/providers/register_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget{
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends ConsumerState<RegisterScreen>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Text(
                      "Create New Account",
                      style: GoogleFonts.nunitoSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 40),
                    inputTextForEmail(_emailController, "Input your email", _formKey),
                    SizedBox(height: 40),
                    inputTextForPassword(ref, _passwordController, "Create your password", isPasswordVisible, _formKey),
                    SizedBox(height: 40),
                    inputTextForConfirmPassword(ref, _confirmPasswordController, "Confirm your password", isConfirmPasswordVisible, _passwordController),
                    SizedBox(height: 50),
                    Stack(
                      children: [Padding(
                        padding: const EdgeInsets.only(top: 225),
                        child: Container(
                          width: 400,
                          height: 60,
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
                              if (_formKey.currentState!.validate()) {
                                final contextRef = context;

                                showDialog(
                                  context: contextRef,
                                  barrierDismissible: false,
                                  builder: (context) => Center(child: CircularProgressIndicator()),
                                );

                                ref.read(registerUserDataProvider({'email': _emailController.text, 'password': _passwordController.text}).future).then((data) {
                                  Navigator.pop(contextRef);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    showModal(contextRef);
                                    Timer(Duration(seconds: 2), () {
                                      Navigator.pushReplacement(contextRef, NavigationService.createRouteForRegisterToLoginScreen());
                                    });
                                  });

                                }).catchError((error) {
                                  Navigator.pop(contextRef);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
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
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      )],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}