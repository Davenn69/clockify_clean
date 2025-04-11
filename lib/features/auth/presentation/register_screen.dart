import 'dart:async';
import 'package:clockify_miniproject/core/constants/button_themes.dart';
import 'package:clockify_miniproject/core/navigation/navigation_service.dart';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:clockify_miniproject/features/auth/presentation/widgets/register_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_theme.dart';
import '../../../core/utils/responsive_functions.dart';
import '../../../core/widgets/error_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget{
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends ConsumerState<RegisterScreen>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

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
                            style: textTheme.headline2,
                          ),
                        ),
                      ),
                      settingSizeForScreenSpaces(context, 0.03, 0.01),
                      EmailInputField(controller: _emailController,  labelText1: "Email", formKey: formKey,),
                      settingSizeForScreenSpaces(context, 0.04, 0.03),
                      PasswordInputField(controller: _passwordController, labelText1: "Enter your Password", formKey: formKey),
                      settingSizeForScreenSpaces(context, 0.04, 0.03),
                      ConfirmPasswordInputField(controller: _confirmPasswordController, labelText1: "Confirm your Password", formKey: formKey, passwordInput: _passwordController),
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
                                    ShowDialog.showErrorDialog(message: "Unknown error occurred");
                                    return;
                                  });
                                }else if(data['status']=='fail'){
                                  if(data['errors']['email'] != null){
                                    WidgetsBinding.instance.addPostFrameCallback((_){
                                      Navigator.pop(contextRef);
                                      ShowDialog.showErrorDialog(message: "Email already exists");
                                    });
                                  }else if(data['errors']['password']!=null){
                                    WidgetsBinding.instance.addPostFrameCallback((_){
                                      Navigator.pop(contextRef);
                                      ShowDialog.showErrorDialog(message: 'Password has to be strong!');
                                    });
                                  }
                                }else{
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pop(contextRef);
                                    // print("Data data here ${data['emailToken']}");
                                    // ref.read(emailTokenProvider.notifier).state = data['emailToken'];
                                    // showModalForVerifyEmail(contextRef, ref, data['emailToken']);
                                    ShowDialog.showSuccessModal();
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
                            style: textTheme.buttonText1,
                          ),
                        ),
                      ),
                      Gap(20.h),
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