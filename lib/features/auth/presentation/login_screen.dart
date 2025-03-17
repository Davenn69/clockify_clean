import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:clockify_miniproject/features/auth/presentation/widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/navigation/navigation_service.dart';
import '../../../core/utils/email_validation.dart';

class LoginScreen extends ConsumerWidget{
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      backgroundColor: Color(0xFF233971),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(
                    width: 250,
                    height: 250,
                    "assets/images/clockify-medium.png"
                ),
                SizedBox(height: 150),
                SizedBox(
                  height: 80,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: Colors.white
                      ),
                      validator: validateEmail,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: EdgeInsets.only(left:20, top:10, bottom: 10),
                        labelText: "Email",
                        labelStyle: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 400,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
                        if(_formKey.currentState!.validate()){
                          final contextRef = context;
                          ref.read(fetchLoginDataProvider({'email' : _emailController.text, 'password' : " "}).future).then((data){
                            if(data['errors']['message'] == "Account need to be verified!"){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showModal(contextRef, data['errors']['message']);
                              });
                            }else if(data['errors']['message'] == 'Account Invalid!, please sign up'){
                              showModalForError(contextRef, data['errors']['message']);
                            }else{
                              Navigator.of(context).push(NavigationService.createRouteForPasswordScreen(_emailController.text));
                            }
                          }
                          );
                        }
                      },
                      child: Text(
                        "SIGN IN",
                        style: GoogleFonts.nunitoSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      )
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(NavigationService.createRouteForRegisterScreen());
                  },
                  child: Text(
                    "Create new account?",
                    style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}