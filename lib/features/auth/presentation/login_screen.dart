import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:clockify_miniproject/features/auth/presentation/widgets/login_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/navigation/navigation_service.dart';
import '../../../core/utils/email_validation.dart';
import '../../../core/utils/responsive_functions.dart';

class LoginScreen extends ConsumerStatefulWidget{
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen>{
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleLogin()async{
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if(_formKey.currentState!.validate()){
      final contextRef = context;
      ref.read(fetchLoginDataProvider({'email' : _emailController.text, 'password' : " "}).future).then((data){
        if(data['error'] == "Unknown error occurred"){
          WidgetsBinding.instance.addPostFrameCallback((_){
            showModalForError(contextRef, "Unknown error occurred");
            return;
          });
        }else if(result.contains(ConnectivityResult.none)){
          WidgetsBinding.instance.addPostFrameCallback((_){
            showModalForError(contextRef, "Unable to connect to the internet");
          });
        }else if(data['errors']['message'] == "Account need to be verified!"){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModal(contextRef, data['errors']['message']);
          });
        }else if(data['errors']['message'] == 'Account Invalid!, please sign up'){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModal(contextRef, data['errors']['message']);
          });
        }else if(data == null){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModalForError(contextRef, data['error']);
          });
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(NavigationService.createRouteForPasswordScreen(_emailController.text));
          });
        }
      }
      );
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Color(0xFF233971),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                      width: settingSizeForScreen(context,230, 100),
                      height: settingSizeForScreen(context, 230, 100),
                      fit: BoxFit.contain,
                      "assets/images/clockify-medium.png"
                  ),
                  settingSizeForScreenSpaces(context, 0.22, 0),
                  SizedBox(
                    height: 80,
                    width: 300,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
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
                  settingSizeForScreenSpaces(context, 0.05, 0.03),
                  Container(
                    width: settingSizeForScreen(context, 400, 100),
                    height: settingSizeForScreen(context, 60, 40),
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
                          _handleLogin();
                        },
                        child: FittedBox(
                          child: Text(
                            "SIGN IN",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(NavigationService.createRouteForRegisterScreen());
                      },
                      child: FittedBox(
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
                    ),
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}