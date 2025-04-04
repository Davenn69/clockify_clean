import 'package:clockify_miniproject/core/utils/password_validation.dart';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:clockify_miniproject/features/auth/presentation/widgets/password_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/responsive_functions.dart';
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
          showModalForPasswordError(context, "Unable to connect to the internet");
        });
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.of(context).pushNamed("/loading_content", arguments: {
          'email' : widget.email,
          'password' : _passwordController.text
        });
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
                          style: GoogleFonts.nunitoSans(
                              fontSize: 28,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    settingSizeForScreenSpaces(context, 0.03, 0.01),
                    SizedBox(
                      width: 300,
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
                          _handleLoginPassword();
                        },
                        child: FittedBox(
                          child: Text(
                            "OK",
                            style: GoogleFonts.nunitoSans(
                                fontSize: settingSizeForText(context, 20, 14),
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    settingSizeForScreenSpaces(context, 0.05, 0.05),
                    GestureDetector(
                      onTap: ()async{
                        final response = await ref.read(sendPasswordLinkProvider(widget.email).future);
                        if(response?['error'] == "Unknown error occurred"){

                          showModalForPasswordError(context, "Unknown error occurred");
                          return;
                        }
                        if(response?['status'] == 'fail'){
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            showModalForPasswordError(context, response?['errors']['message']);
                          });
                        }else{
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            showModalForForgotPassword(context);
                          });
                        }
                      },
                      child: FittedBox(
                        child: Text(
                          "Forgot password?",
                          style: GoogleFonts.nunitoSans(
                              fontSize: settingSizeForText(context, 20, 14),
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black87.withAlpha(100),
                              color: Colors.black87.withAlpha(100)
                          ),
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