import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../application/notifiers/time_location_notifier.dart';
import '../../application/providers/history_providers.dart';
import '../../application/providers/timer_providers.dart';
import '../../domain/entities/activity_entity.dart';


class StartButtonWidget extends StatelessWidget{
  final WidgetRef ref;
  final StateProvider<bool> provider;
  final void Function(WidgetRef, TimeLocationNotifier) startTimer;
  final TimeLocationNotifier notifier;

  const StartButtonWidget({super.key, required this.ref, required this.provider, required this.startTimer, required this.notifier});

  @override
  Widget build(BuildContext context){
    return Container(
        width: 300,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              colors.lightBlue,
              colors.darkBlue,
            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: colors.transparent,
                shadowColor: colors.transparent
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
}

class ActivityDisabledWidgets extends StatefulWidget{
  final WidgetRef ref;
  final StateProvider<bool> isResetStop;
  final StateProvider<bool> isStart;
  final void Function(WidgetRef, TimeLocationNotifier) stopTimer;
  final void Function(WidgetRef, TimeLocationNotifier) resetTimer;
  final TimeLocationNotifier notifier;
  final TextEditingController controller;
  final ActivityEntity activity;

  const ActivityDisabledWidgets({super.key, required this.ref, required this.isResetStop, required this.isStart, required this.stopTimer, required this.resetTimer, required this.notifier, required this.controller, required this.activity});

  @override
  State<ActivityDisabledWidgets> createState() => _ActivityDisabledWidgetsState();
}

class _ActivityDisabledWidgetsState extends State<ActivityDisabledWidgets>{
  @override
  Widget build(BuildContext context) {
    return widget.ref.read(widget.isResetStop.notifier).state ? ResetingButtonWidgets(ref: widget.ref, isResetStop : widget.isResetStop, isStart : widget.isStart, stopTimer : widget.stopTimer, resetTimer : widget.resetTimer, notifier : widget.notifier) : SavingButtonWidgets(ref : widget.ref, provider1 : widget.isResetStop, provider2 : widget.isStart, notifier : widget.notifier, resetTimer : widget.resetTimer, activity : widget.activity, controller : widget.controller);
  }
}

class SavingButtonWidgets extends StatelessWidget{
  final WidgetRef ref;
  final StateProvider<bool> provider1;
  final StateProvider<bool> provider2;
  final TimeLocationNotifier notifier;
  final void Function(WidgetRef, TimeLocationNotifier) resetTimer;
  final ActivityEntity activity;
  final TextEditingController controller;

  const SavingButtonWidgets({super.key, required this.ref, required this.provider1, required this.provider2, required this.notifier, required this.resetTimer, required this.activity, required this.controller});

  @override
  Widget build(BuildContext context){
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
                          colors.lightBlue,
                          colors.darkBlue,
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colors.transparent,
                            shadowColor: colors.transparent
                        ),
                        onPressed: ()async{
                          if(controller.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Description must be filled")));
                          }else{
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
                            backgroundColor: colors.transparent,
                            shadowColor: colors.transparent
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
                              color: colors.fontGrey.shade500
                          ),
                        )
                    )
                )
            ),
          ]
      ),
    );
  }
}

class ResetingButtonWidgets extends StatelessWidget{
  final WidgetRef ref;
  final StateProvider<bool> isResetStop;
  final StateProvider<bool> isStart;
  final void Function(WidgetRef, TimeLocationNotifier) stopTimer;
  final void Function(WidgetRef, TimeLocationNotifier) resetTimer;
  final TimeLocationNotifier notifier;

  const ResetingButtonWidgets({super.key, required this.ref, required this.isResetStop, required this.isStart, required this.stopTimer, required this.resetTimer, required this.notifier});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          colors.lightBlue,
                          colors.darkBlue,
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colors.transparent,
                            shadowColor: colors.transparent
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
                            backgroundColor: colors.transparent,
                            shadowColor: colors.transparent
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
                              color: colors.fontGrey.shade500
                          ),
                        )
                    )
                )
            ),
          ]
      ),
    );
  }
}

// Widget ResetStopState(WidgetRef ref, StateProvider<bool> isResetStop, StateProvider<bool> isStart, void Function(WidgetRef, TimeLocationNotifier) stopTimer, void Function(WidgetRef, TimeLocationNotifier) resetTimer, TimeLocationNotifier notifier){
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 30.0),
//     child: Row(
//         children: <Widget>[
//           Expanded(
//               child: Container(
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(colors: [
//                         colors.lightBlue,
//                         colors.darkBlue,
//                       ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter
//                       ),
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: colors.transparent,
//                           shadowColor: colors.transparent
//                       ),
//                       onPressed: (){
//                         ref.read(isResetStop.notifier).state = !ref.read(isResetStop.notifier).state;
//                         stopTimer(ref, notifier);
//                       },
//                       child: Text(
//                         "STOP",
//                         style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Colors.white
//                         ),
//                       )
//                   )
//               )
//           ),
//           SizedBox(width: 20,),
//           Expanded(
//               child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: colors.transparent,
//                           shadowColor: colors.transparent
//                       ),
//                       onPressed: (){
//                         ref.read(isStart.notifier).state = !ref.read(isStart.notifier).state;
//                         resetTimer(ref, notifier);
//                       },
//                       child: Text(
//                         "RESET",
//                         style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: colors.fontGrey.shade500
//                         ),
//                       )
//                   )
//               )
//           ),
//         ]
//     ),
//   );
// }

// Widget StartState(WidgetRef ref, StateProvider<bool> provider, void Function(WidgetRef, TimeLocationNotifier) startTimer, TimeLocationNotifier notifier){
//   return Container(
//       width: 300,
//       decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [
//             colors.lightBlue,
//             colors.darkBlue,
//           ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter
//           ),
//           borderRadius: BorderRadius.circular(10)
//       ),
//       child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: colors.transparent,
//               shadowColor: colors.transparent
//           ),
//           onPressed: (){
//             ref.read(provider.notifier).state = !ref.read(provider.notifier).state;
//             startTimer(ref, notifier);
//           },
//           child: Text(
//             "START",
//             style: GoogleFonts.nunitoSans(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white
//             ),
//           )
//       )
//   );
// }

// Widget NotStartState(WidgetRef ref, StateProvider<bool> isResetStop, StateProvider<bool> isStart, void Function(WidgetRef, TimeLocationNotifier) stopTimer, void Function(WidgetRef, TimeLocationNotifier) resetTimer, TimeLocationNotifier notifier,TextEditingController controller, ActivityEntity activity, BuildContext context){
//   return ref.read(isResetStop.notifier).state ? ResetStopState(ref, isResetStop, isStart, stopTimer, resetTimer, notifier) : SaveDeleteState(ref, isResetStop, isStart, notifier, resetTimer, activity, controller, context);
// }

// Widget SaveDeleteState(WidgetRef ref, StateProvider<bool> provider1, StateProvider<bool> provider2, TimeLocationNotifier notifier, void Function(WidgetRef, TimeLocationNotifier) resetTimer, ActivityEntity activity, TextEditingController controller){
//   final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
//   final token = ref.read(tokenProvider.notifier).state;
//   final type = ref.watch(selectedChoiceProvider);
//   final lat = ref.watch(timeLocationProvider).lat;
//   final lng = ref.watch(timeLocationProvider).lng;
//
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 30.0),
//     child: Row(
//         children: <Widget>[
//           Expanded(
//               child: Container(
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(colors: [
//                         colors.lightBlue,
//                         colors.darkBlue,
//                       ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter
//                       ),
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: colors.transparent,
//                           shadowColor: colors.transparent
//                       ),
//                       onPressed: ()async{
//                         if(controller.text.isEmpty){
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Description must be filled")));
//                         }else{
//                           historyNotifier.saveActivity(ActivityEntity(description: controller.text, startTime: activity.startTime, endTime: activity.endTime, locationLat: activity.locationLat, locationLng: activity.locationLng, createdAt: activity.createdAt, updatedAt: activity.updatedAt, userUuid: activity.userUuid), token, type!, lat!, lng!);
//
//                           controller.text = "";
//                           ref.read(provider1.notifier).state = !ref.read(provider1.notifier).state;
//                           ref.read(provider2.notifier).state = !ref.read(provider2.notifier).state;
//                           resetTimer(ref, notifier);
//
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save Successful")));
//                         }
//                       },
//                       child: Text(
//                         "SAVE",
//                         style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Colors.white
//                         ),
//                       )
//                   )
//               )
//           ),
//           SizedBox(width: 20,),
//           Expanded(
//               child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: colors.transparent,
//                           shadowColor: colors.transparent
//                       ),
//                       onPressed: (){
//                         ref.read(provider1.notifier).state = !ref.read(provider1.notifier).state;
//                         ref.read(provider2.notifier).state = !ref.read(provider2.notifier).state;
//                         resetTimer(ref, notifier);
//                       },
//                       child: Text(
//                         "DELETE",
//                         style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: colors.fontGrey.shade500
//                         ),
//                       )
//                   )
//               )
//           ),
//         ]
//     ),
//   );
// }