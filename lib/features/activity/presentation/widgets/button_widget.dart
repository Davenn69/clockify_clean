import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/history_hive_state_notifier_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../application/notifiers/time_location_notifier.dart';
import '../../application/providers/button_provider.dart';
import '../../application/providers/time_location_provider.dart';
import '../../domain/entities/activity_entity.dart';
import '../screen/history_screen.dart';

Widget StartState(WidgetRef ref, StateProvider<bool> provider, void Function(WidgetRef, TimeLocationNotifier) startTimer, TimeLocationNotifier notifier){
  return Container(
      width: 300,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF45CDDC),
            Color(0xFF2EBED9),
          ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
          borderRadius: BorderRadius.circular(10)
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent
          ),
          onPressed: (){
            ref.read(provider.notifier).state = !ref.read(provider.notifier).state;
            startTimer(ref, notifier);
          },
          child: Text(
            "START",
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white
            ),
          )
      )
  );
}

Widget NotStartState(WidgetRef ref, StateProvider<bool> isResetStop, StateProvider<bool> isStart, void Function(WidgetRef, TimeLocationNotifier) stopTimer, void Function(WidgetRef, TimeLocationNotifier) resetTimer, TimeLocationNotifier notifier,TextEditingController controller, ActivityEntity activity, BuildContext context){
  return ref.read(isResetStop.notifier).state ? ResetStopState(ref, isResetStop, isStart, stopTimer, resetTimer, notifier) : SaveDeleteState(ref, isResetStop, isStart, notifier, resetTimer, activity, controller, context);
}

Widget SaveDeleteState(WidgetRef ref, StateProvider<bool> provider1, StateProvider<bool> provider2, TimeLocationNotifier notifier, void Function(WidgetRef, TimeLocationNotifier) resetTimer, ActivityEntity activity, TextEditingController controller, BuildContext context){
  final resetStopCondition = ref.watch(isResetStop);
  final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
  final token = ref.read(tokenProvider.notifier).state;
  final type = ref.watch(selectedChoiceProvider);
  final lat = ref.watch(timeLocationProvider).lat;
  final lng = ref.watch(timeLocationProvider).lng;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFF45CDDC),
                        Color(0xFF2EBED9),
                      ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: ()async{
                        if(controller.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Description must be filled")));
                        }else{
                          print("here");
                          historyNotifier.saveActivity(ActivityEntity(description: controller.text, startTime: activity.startTime, endTime: activity.endTime, locationLat: activity.locationLat, locationLng: activity.locationLng, createdAt: activity.createdAt, updatedAt: activity.updatedAt, userUuid: activity.userUuid), token, type!, lat!, lng!);

                          controller.text = "";
                          ref.read(provider1.notifier).state = !ref.read(provider1.notifier).state;
                          ref.read(provider2.notifier).state = !ref.read(provider2.notifier).state;
                          resetTimer(ref, notifier);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save Successful")));
                        }
                      },
                      child: Text(
                        "SAVE",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white
                        ),
                      )
                  )
              )
          ),
          SizedBox(width: 20,),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: (){
                        ref.read(provider1.notifier).state = !ref.read(provider1.notifier).state;
                        ref.read(provider2.notifier).state = !ref.read(provider2.notifier).state;
                        resetTimer(ref, notifier);
                      },
                      child: Text(
                        "DELETE",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey.shade500
                        ),
                      )
                  )
              )
          ),
        ]
    ),
  );
}

Widget ResetStopState(WidgetRef ref, StateProvider<bool> isResetStop, StateProvider<bool> isStart, void Function(WidgetRef, TimeLocationNotifier) stopTimer, void Function(WidgetRef, TimeLocationNotifier) resetTimer, TimeLocationNotifier notifier){
  final resetStopCondition = ref.watch(isResetStop);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFF45CDDC),
                        Color(0xFF2EBED9),
                      ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: (){
                        ref.read(isResetStop.notifier).state = !ref.read(isResetStop.notifier).state;
                        stopTimer(ref, notifier);
                      },
                      child: Text(
                        "STOP",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white
                        ),
                      )
                  )
              )
          ),
          SizedBox(width: 20,),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: (){
                        ref.read(isStart.notifier).state = !ref.read(isStart.notifier).state;
                        resetTimer(ref, notifier);
                      },
                      child: Text(
                        "RESET",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey.shade500
                        ),
                      )
                  )
              )
          ),
        ]
    ),
  );
}