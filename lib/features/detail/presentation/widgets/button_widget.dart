import 'package:clockify_miniproject/core/constants/text_theme.dart';
import 'package:clockify_miniproject/core/widgets/error_widgets.dart';
import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:clockify_miniproject/features/detail/application/providers/detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/colors.dart';
import '../../../activity/application/providers/history_providers.dart';
import '../../../activity/application/providers/timer_providers.dart';
import '../../../activity/data/models/activity_hive_model.dart';

class SavingButtonWidgetDetails extends StatelessWidget{

  final WidgetRef ref;
  final ActivityHive activity;
  final TextEditingController controller;

  const SavingButtonWidgetDetails({super.key, required this.ref, required this.activity, required this.controller});


  @override
  Widget build(BuildContext context){
    final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
    final token = ref.read(tokenProvider.notifier).state;
    final type = ref.watch(selectedChoiceProvider);
    final lat = ref.watch(timeLocationProvider).lat;
    final lng = ref.watch(timeLocationProvider).lng;
    final changedStartTime = ref.watch(detailProvider).changedStartTime;
    final changedEndTime = ref.watch(detailProvider).changedEndTime;

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
                          if(controller.text == ""){
                            WidgetsBinding.instance.addPostFrameCallback((_){
                              ShowDialog.showErrorDialog(message: "Please input a description");
                            });
                            return;
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            historyNotifier.updateExistingActivity(ActivityHive(uuid : activity.uuid, description: controller.text, startTime: changedStartTime, endTime: changedEndTime, locationLat: activity.locationLng, locationLng: activity.locationLat, createdAt: activity.createdAt, updatedAt: activity.updatedAt, userUuid: activity.userUuid), token, type!, lat!, lng!);
                            Navigator.pop(context);
                            ShowDialog.showModalForActivityDeletion();
                          });
                        },
                        child: Text(
                          "SAVE",
                          style: textTheme.buttonText1,
                        )
                    )
                )
            ),
            Gap(20.h),
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
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            ShowDialog.showModalToConfirm(context, activity, token, type!, lat!, lng!, historyNotifier);
                          });
                        },
                        child: Text(
                          "DELETE",
                          style: textTheme.buttonText2,
                        )
                    )
                )
            ),
          ]
      ),
    );
  }
}

// Widget saveDeleteState(WidgetRef ref, TextEditingController controller, ActivityHive activity, BuildContext context){
//   final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
//   final token = ref.read(tokenProvider.notifier).state;
//   final type = ref.watch(selectedChoiceProvider);
//   final lat = ref.watch(timeLocationProvider).lat;
//   final lng = ref.watch(timeLocationProvider).lng;
//   final changedStartTime = ref.watch(changedStartTimeProvider);
//   final changedEndTime = ref.watch(changedEndTimeProvider);
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
//                       onPressed: (){
//                         if(controller.text == ""){
//                           WidgetsBinding.instance.addPostFrameCallback((_){
//                             ShowDialog.showErrorDialog(message: "Please input a description");
//                           });
//                           return;
//                         }
//                         WidgetsBinding.instance.addPostFrameCallback((_){
//                           historyNotifier.updateExistingActivity(ActivityHive(uuid : activity.uuid, description: controller.text, startTime: changedStartTime, endTime: changedEndTime, locationLat: activity.locationLng, locationLng: activity.locationLat, createdAt: activity.createdAt, updatedAt: activity.updatedAt, userUuid: activity.userUuid), token, type!, lat!, lng!);
//                           Navigator.pop(context);
//                           showModal(context);
//                         });
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
//                         WidgetsBinding.instance.addPostFrameCallback((_){
//                           showModalToConfirm(context, activity, token, type!, lat!, lng!, historyNotifier);
//                         });
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