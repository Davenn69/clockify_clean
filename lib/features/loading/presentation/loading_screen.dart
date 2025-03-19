import 'dart:async';
import 'package:clockify_miniproject/features/loading/application/providers/loading_providers.dart';
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
    Future.delayed(Duration(milliseconds: 200), (){
      setState((){
        opacity = 0;
      });
    });

    Future.delayed(Duration(milliseconds: 1600), () {
      if (mounted) {
        ref.read(loadingNotifierProvider.notifier).checkSession();
      }
    });

    // Future.microtask(()=>ref.read(loadingNotifierProvider.notifier).checkSession());
  }

  @override
  Widget build(BuildContext context){

    ref.listen(loadingNotifierProvider, (previous, next) {
      if (next is AsyncData<Map<String,String>?>) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            next.value == null ?
            NavigationService.createRouteForLoginScreen()
                : NavigationService.createRouteForTimerScreen(),
          );
        }
      }
    });

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