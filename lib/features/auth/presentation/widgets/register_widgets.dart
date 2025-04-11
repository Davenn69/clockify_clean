
import 'package:clockify_miniproject/core/utils/responsive_functions.dart';
import 'package:clockify_miniproject/features/auth/application/providers/register_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/email_validation.dart';
import '../../../../core/utils/password_validation.dart';

// void showModalForVerifyEmail(BuildContext context, WidgetRef ref, String emailToken){
//   showDialog(
//       context: context,
//       builder: (BuildContext context){
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: SizedBox(
//             width: 350,
//             height: 400,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Email is not verified",
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "You need to verify your email before you can use it",
//                         style: GoogleFonts.nunitoSans(
//                             fontSize: 18,
//                             color: colors.fontGrey.shade500
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 50),
//                       ElevatedButton(onPressed: ()async{
//                         final response = await ref.read(verifyEmailProvider(emailToken).future);
//                         if(response['error'] == "Unknown error occurred"){
//
//                           showModalForRegisterError(context, "Unknown error occurred");
//                           return;
//                         }
//
//
//                         if(response['status'] == 'fail'){
//                           WidgetsBinding.instance.addPostFrameCallback((_){
//                             showModalForRegisterError(context, response['errors']['message']);
//                           });
//                         }else{
//                           WidgetsBinding.instance.addPostFrameCallback((_){
//                             showModal(context);
//                             Timer(Duration(seconds: 2), () {
//                               Navigator.pushReplacement(context, NavigationService.createRouteForRegisterToLoginScreen());
//                             });
//                           });
//                         }
//                       }, child: Text(
//                         "Verify",
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 16,
//                           color: Colors.black54
//                         ),
//                       ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//   );
// }

class EmailInputField extends StatelessWidget{
  final TextEditingController controller;
  final String labelText1;
  final GlobalKey<FormState> formKey;

  const EmailInputField({super.key,required this.controller, required this.labelText1, required this.formKey});

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: settingSizeForScreen(context, 400, 200),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          labelText: labelText1,
          labelStyle: GoogleFonts.nunitoSans(
              fontSize: settingSizeForText(context, 16, 14)
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.primary.withAlpha(128), width: 2)
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.primary, width:2)
          ),
        ),
      ),
    );
  }
}

class PasswordInputField extends ConsumerWidget{
  final TextEditingController controller;
  final String labelText1;
  final GlobalKey<FormState> formKey;

  const PasswordInputField({super.key, required this.controller, required this.labelText1, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final state = ref.watch(registerProvider);
    return SizedBox(
      width: settingSizeForScreen(context, 400, 200),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        validator: validatePassword,
        obscureText: !state.isPasswordVisible,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
            labelText: "Input your password",
            labelStyle: GoogleFonts.nunitoSans(
                fontSize: settingSizeForText(context, 16, 14)
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary.withAlpha(128), width: 2)
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary, width:2)
            ),
            suffixIcon: GestureDetector(
                onTap: (){
                  ref.read(registerProvider.notifier).togglePasswordVisibility();
                },
                child: Icon(state.isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
            )
        ),
      ),
    );
  }
}

class ConfirmPasswordInputField extends ConsumerWidget{
  final TextEditingController controller;
  final String labelText1;
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordInput;

  const ConfirmPasswordInputField({super.key, required this.controller, required this.labelText1, required this.formKey, required this.passwordInput});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final state = ref.watch(registerProvider);
    return SizedBox(
      width: settingSizeForScreen(context, 400, 200),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => validateConfirmPassword(value, passwordInput.text),
        obscureText: !state.isConfirmPasswordVisible,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
            labelText: "Input your password",
            labelStyle: GoogleFonts.nunitoSans(
                fontSize: settingSizeForText(context, 16, 14)
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary.withAlpha(128), width: 2)
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary, width:2)
            ),
            suffixIcon: GestureDetector(
                onTap: (){
                  ref.read(registerProvider.notifier).toggleConfirmPasswordVisibility();
                },
                child: Icon(state.isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined)
            )
        ),
      ),
    );
  }
}
