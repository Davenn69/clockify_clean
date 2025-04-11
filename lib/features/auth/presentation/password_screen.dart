import 'package:clockify_miniproject/core/constants/button_themes.dart';
import 'package:clockify_miniproject/core/constants/text_theme.dart';
import 'package:clockify_miniproject/core/utils/password_validation.dart';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/router/router_constants.dart';
import '../../../core/utils/responsive_functions.dart';
import '../../../core/widgets/error_widgets.dart';
import '../application/providers/password_providers.dart';

class PasswordScreen extends ConsumerStatefulWidget{
  final String email;

  const PasswordScreen({super.key, required this.email});

  @override
  ConsumerState<PasswordScreen> createState() => PasswordScreenState();
}

class PasswordScreenState extends ConsumerState<PasswordScreen>{
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleLoginPassword()async{
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if(_formKey.currentState!.validate()){
      if(result.contains(ConnectivityResult.none)){
        WidgetsBinding.instance.addPostFrameCallback((_){
          ShowDialog.showErrorDialog(message: "Unable to connect to the internet");
        });
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_){
        // Navigator.of(context).pushNamed("/loading_content", arguments: {
        //   'email' : widget.email,
        //   'password' : _passwordController.text
        // });

        context.pushNamed(routes.loadingToContent, extra: {'email' : widget.email, 'password' : _passwordController.text});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVisible = ref.watch(isVisibleProvider);
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    settingSizeForScreenSpaces(context, 0.04, 0.03),
                    SizedBox(
                      width: settingSizeForScreen(context, 130, 90),
                      child: FittedBox(
                        child: Text(
                          "Password",
                          style: textTheme.headline2,
                        ),
                      ),
                    ),
                    settingSizeForScreenSpaces(context, 0.03, 0.01),
                    SizedBox(
                      width: 300.w,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: validatePassword,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          obscureText: !isVisible,
                          decoration: InputDecoration(
                              labelText: "Input your password",
                              labelStyle: textTheme.labelText2,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colors.primary.withAlpha(128), width: 2)
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colors.primary, width:2)
                              ),
                              suffixIcon: GestureDetector(
                                  onTap: (){
                                    ref.read(isVisibleProvider.notifier).state = !isVisible;
                                  },
                                  child: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
                              )
                          ),
                        ),
                      ),
                    ),
                    settingSizeForScreenSpaces(context, 0.05, 0.05),
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
                          _handleLoginPassword();
                        },
                        child: FittedBox(
                          child: Text(
                            "OK",
                            style: textTheme.buttonText1,
                          ),
                        ),
                      ),
                    ),
                    settingSizeForScreenSpaces(context, 0.05, 0.05),
                    GestureDetector(
                      onTap: ()async{
                        final response = await ref.read(sendPasswordLinkProvider(widget.email).future);
                        if(response?['error'] == "Unknown error occurred"){
                          ShowDialog.showErrorDialog(message: "Unknown error occurred");
                          return;
                        }
                        if(response?['status'] == 'fail'){
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            ShowDialog.showErrorDialog(message: response?['errors']['message']);
                          });
                        }else{
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            ShowDialog.showModalForForgotPassword();
                          });
                        }
                      },
                      child: FittedBox(
                        child: Text(
                          "Forgot password?",
                          style: textTheme.link1
                          // GoogleFonts.nunitoSans(
                          //     fontSize: settingSizeForText(context, 20, 14),
                          //     decoration: TextDecoration.underline,
                          //     decorationColor: Colors.black87.withAlpha(100),
                          //     color: Colors.black87.withAlpha(100)
                          // ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}