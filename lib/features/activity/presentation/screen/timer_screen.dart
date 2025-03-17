import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/utils/date_formatting.dart';
import '../../application/providers/activity_repository_provider.dart';
import '../../application/providers/button_provider.dart';
import '../../application/notifiers/time_location_notifier.dart';
import '../../application/providers/stopwatch_time_provider.dart';
import '../../application/providers/stopwatch_timer_provider.dart';
import '../../domain/entities/activity_entity.dart';
import '../../application/providers/time_location_provider.dart';
import '../widgets/button_widget.dart';
import 'history_screen.dart';

Route _createRouteForActivity(){
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondAnimation)=>ActivityScreen(),
      transitionDuration: Duration(milliseconds: 400),
      reverseTransitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondAnimation, child){
        var tween = Tween(begin: Offset(1.0, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      }
  );

}

class ContentScreen extends ConsumerWidget{
  final _descriptionController = TextEditingController();

  void startTimer(WidgetRef ref, TimeLocationNotifier notifier){
    String currentTime = DateTime.now().toString();
    print(currentTime);
    final stopWatchTimer = ref.watch(stopWatchTimerProvider.notifier);
    stopWatchTimer.state = StopWatchTimer(
      mode: StopWatchMode.countUp,
    );
    stopWatchTimer.state.onStartTimer();
    notifier.startTimer();
  }

  Future<void> stopTimer(WidgetRef ref, TimeLocationNotifier notifier)async{
    final stopWatchTimer = ref.watch(stopWatchTimerProvider.notifier);
    stopWatchTimer.state.onStopTimer();
    final elapsedMilliseconds = stopWatchTimer.state.rawTime.value;

    final duration = Duration(milliseconds:elapsedMilliseconds);
    notifier.stopTimer(duration);
    await notifier.updateGeolocation();
  }

  void resetTimer(WidgetRef ref, TimeLocationNotifier notifier){
    final stopWatchTimer = ref.watch(stopWatchTimerProvider.notifier);
    stopWatchTimer.state.onResetTimer();
    notifier.resetTimer();
  }

  Widget build(BuildContext context, WidgetRef ref){
    final condition = ref.watch(isStart);
    final stopWatchTime = ref.watch(stopWatchTimeProvider);
    final stopWatchTimer = ref.watch(stopWatchTimerProvider);
    final state = ref.watch(timeLocationProvider);
    final notifier = ref.read(timeLocationProvider.notifier);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('token')) {
      Future.microtask(() {
        ref.read(tokenProvider.notifier).state = args['token'];
      });
    }

    if(state.lat == null && state.lng == null){
      Future.delayed(Duration.zero, () {
        notifier.updateGeolocation();
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFF233971),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                        "assets/images/clockify-medium.png",
                        width: 200,
                        fit: BoxFit.cover
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){},
                            child: Hero(
                              tag: 'Timer',
                              child: Text(
                                "Timer",
                                style: GoogleFonts.nunitoSans(
                                    color: Color(0xFFF8D068),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Hero(
                            tag: "timer-activity",
                            child: AnimatedContainer(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: 3,
                              color : Color(0xFFF8D068),
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.of(context).push(_createRouteForActivity());
                        },
                        child: Hero(
                          tag: 'Activity',
                          child: Text(
                            "Activity",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  Text(
                    stopWatchTime.when(data: (value)=> StopWatchTimer.getDisplayTime(value, milliSecond: false).replaceAll(":", " : "), loading: () => "00 : 00 : 00", error: (err, stack) => "Error"),
                    style: GoogleFonts.nunitoSans(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color : Colors.white
                    ),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Start Time",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 12,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatTime(state.startTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatDate(state.startTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "End Time",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 12,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatTime(state.endTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatDate(state.endTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 275,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (state.lat == null && state.lng == null) ? <Widget>[SpinKitCircle(
                          color: Colors.white,
                          size: 30,
                        )] : <Widget>[
                          Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color:  Color(0xFFF8D068)
                          ),
                          Text(
                            "${state.lat} ${state.lng}",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Write your activity here...",
                          filled: true,
                          fillColor: Colors.white,
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  condition ? StartState(ref, isStart, startTimer, notifier) : NotStartState(ref, isResetStop, isStart, stopTimer, resetTimer, notifier, _descriptionController, ActivityEntity(
                    description: _descriptionController.text,
                    startTime:  state.startTime ?? DateTime.now(),
                    endTime: state.endTime ?? DateTime.now(),
                    locationLat: 12.0913,
                    locationLng: 12.9213,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime(2024, 3, 2, 6, 50),
                    userUuid: "user_002",
                  ),context),
                  SizedBox(height: 40)
                ],
              ),
            ),
          )
      ),
    );
  }
}