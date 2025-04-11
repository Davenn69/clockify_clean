import 'package:clockify_miniproject/core/constants/button_themes.dart';
import 'package:clockify_miniproject/core/constants/image_paths.dart';
import 'package:clockify_miniproject/core/constants/text_theme.dart';
import 'package:clockify_miniproject/core/widgets/error_widgets.dart';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/colors.dart';
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
            ShowDialog.showErrorDialog(message: "Unknown error occurred");
            return;
          });
        }else if(result.contains(ConnectivityResult.none)){
          WidgetsBinding.instance.addPostFrameCallback((_){
            ShowDialog.showErrorDialog(message: "Unable to connect to the internet!");
          });
        }else if(data['errors']['message'] == "Account need to be verified!"){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowDialog.showErrorDialog(message: data['errors']['message'], description: "Please check you email for verification link!");
          });
        }else if(data['errors']['message'] == 'Account Invalid!, please sign up'){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowDialog.showErrorDialog(message: data['errors']['message']);
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
      backgroundColor: colors.primary,
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
                      images.clockifyLogo
                  ),
                  settingSizeForScreenSpaces(context, 0.22, 0),
                  SizedBox(
                    height: 80,
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        style: textTheme.headline1,
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
                          labelStyle: textTheme.labelText1,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.borderColorActive, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.borderColorActive, width: 2),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: colors.iconColorActive,
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
                              colors.lightBlue,
                              colors.darkBlue,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        )
                    ),
                    child: ElevatedButton(
                        style: buttonThemes.transparentButton,
                        onPressed: (){
                          _handleLogin();
                        },
                        child: FittedBox(
                          child: Text(
                            "SIGN IN",
                            style: textTheme.buttonText1
                          ),
                        )
                    ),
                  ),
                  Gap(40.h),
                  SizedBox(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(NavigationService.createRouteForRegisterScreen());
                      },
                      child: FittedBox(
                        child: Text(
                          "Create new account?",
                          style:textTheme.link1
                        ),
                      ),
                    ),
                  ),
                  Gap(30.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}