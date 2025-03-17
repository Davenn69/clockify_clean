import 'dart:async';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/navigation/navigation_service.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends ConsumerState<LoadingScreen>{
  double opacity = 1.0;
  bool hasNavigated = false;

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 500), (){
      setState((){
        opacity = 0;
      });
    });

    Future.delayed(Duration(milliseconds: 1500) , ()async {
      final sessionKey = await ref.read(getSessionKeyProvider.future);
      if (mounted && !hasNavigated) {
        hasNavigated = true;
        // if (sessionKey == null) {
          Navigator.of(context).pushReplacement(NavigationService.createRouteForLoginScreen());
        // } else {
        //   Navigator.of(context).pushReplacement(NavigationService.createRouteForTimerScreen());
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Color(0xFF233971),
        body:Center(
          child: AnimatedOpacity(
            opacity: opacity,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: Image.asset(
              width: 300,
              height: 300,
              "assets/images/clockify-big.png",
            ),
          ),
        )
    );
  }
}