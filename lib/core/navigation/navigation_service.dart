import 'package:clockify_miniproject/features/activity/presentation/screen/timer_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/password_screen.dart';
import '../../features/auth/presentation/register_screen.dart';

class NavigationService{
  static Route createRouteForPasswordScreen(String email){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation)=>PasswordScreen(email: email,),
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondAnimation, child){
          var tween = Tween(begin: Offset(1.0, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        }
    );
  }

  static Route createRouteForRegisterScreen(){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation)=>RegisterScreen(),
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondAnimation, child){
          var tween = Tween(begin: Offset(1.0, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        }
    );
  }

  static Route createRouteForLoginScreen(){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => LoginScreen(),
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondAnimation, child){
          var tween = Tween(begin: Offset(1.0, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        }
    );
  }

  static Route createRouteForRegisterToLoginScreen(){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => LoginScreen(),
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondAnimation, child){
          var tween = Tween(begin: Offset(-1.0, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        }
    );
  }

  static Route createRouteForTimerScreen(){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => ContentScreen(),
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondAnimation, child){
          var tween = Tween(begin: Offset(1.0, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        }
    );
  }
}