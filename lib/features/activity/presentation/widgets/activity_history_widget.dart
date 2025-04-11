import 'package:clockify_miniproject/core/constants/text_theme.dart';
import 'package:clockify_miniproject/core/utils/history_formatting.dart';
import 'package:clockify_miniproject/core/widgets/error_widgets.dart';
import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/utils/date_formatting.dart';
import '../../application/providers/history_providers.dart';
import '../../application/providers/timer_providers.dart';
import '../../data/models/activity_hive_model.dart';

class ActivityHistoryWidget extends StatefulWidget{
  final ActivityHive activity;
  final WidgetRef ref;
  final bool isLoading;

  const ActivityHistoryWidget({super.key, required this.activity, required this.ref, this.isLoading = false});

  @override
  State<ActivityHistoryWidget> createState() => ActivityHistoryWidgetState();
}

class ActivityHistoryWidgetState extends State<ActivityHistoryWidget>{
  @override
  Widget build(BuildContext context){
    final historyNotifier = widget.ref.watch(historyHiveStateNotifierProvider.notifier);
    final token = widget.ref.read(tokenProvider.notifier).state;
    final type = widget.ref.watch(selectedChoiceProvider);
    final lat = widget.ref.watch(timeLocationProvider).lat;
    final lng = widget.ref.watch(timeLocationProvider).lng;

    return Slidable(
      endActionPane: ActionPane(motion: const DrawerMotion(),
          children: [
            SlidableAction(
              flex: 1,
              onPressed: (BuildContext context) async {
                WidgetsBinding.instance.addPostFrameCallback((_){
                  ShowDialog.showModalForActivityDeletion();
                  historyNotifier.deleteContent(widget.activity.uuid, token, type!, lat!, lng!);
                });
              },
              backgroundColor: Colors.redAccent,
              label: 'Delete',
            ),
          ]
      ),
      child: SizedBox(
        height: 60.h,
        width: double.infinity,
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(NavigationService.createRouteForDetail(widget.activity));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: colors.borderColorInactive.withAlpha(100),
                      width: 1
                  )
              ),
              color: colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        formatDuration(widget.activity.endTime.difference(widget.activity.startTime)),
                        style: textTheme.durationText,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.lock_clock,
                            color: colors.iconColorInactive,
                            size: 20,
                          ),
                          Text(
                            "${formatTime(widget.activity.startTime)} - ${formatTime(widget.activity.endTime)}",
                            style: textTheme.fromToTimeText,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        formatHistory(widget.activity.description),
                        style: textTheme.historyText,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: colors.iconColorInactive,
                            size: 20,
                          ),
                          Text(
                            "${widget.activity.locationLat} ${widget.activity.locationLng}",
                            style: textTheme.locationTextCard,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget activityHistoryWidget(ActivityHive activity, BuildContext context, WidgetRef ref, {bool isLoading = false}){
//   final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
//   final token = ref.read(tokenProvider.notifier).state;
//   final type = ref.watch(selectedChoiceProvider);
//   final lat = ref.watch(timeLocationProvider).lat;
//   final lng = ref.watch(timeLocationProvider).lng;
//
//   return Slidable(
//     endActionPane: ActionPane(motion: const DrawerMotion(),
//         children: [
//           SlidableAction(
//             flex: 1,
//             onPressed: (BuildContext context) async {
//               WidgetsBinding.instance.addPostFrameCallback((_){
//                 showModal(context);
//                 historyNotifier.deleteContent(activity.uuid, token, type!, lat!, lng!);
//               });
//             },
//             backgroundColor: Colors.redAccent,
//             label: 'Delete',
//           ),
//         ]
//     ),
//     child: SizedBox(
//       height: 60,
//       width: double.infinity,
//       child: GestureDetector(
//         onTap: (){
//           Navigator.of(context).push(_createRouteForDetail(activity));
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border(
//                 bottom: BorderSide(
//                     color: colors.borderColorInactive.withAlpha(100),
//                     width: 1
//                 )
//             ),
//             color: colors.transparent,
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       formatDuration(activity.endTime.difference(activity.startTime)),
//                       style: GoogleFonts.nunitoSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(
//                           Icons.lock_clock,
//                           color: colors.iconColorInactive,
//                           size: 20,
//                         ),
//                         Text(
//                           "${formatTime(activity.startTime)} - ${formatTime(activity.endTime)}",
//                           style: GoogleFonts.nunitoSans(
//                               fontSize: 12,
//                               color: colors.fontGrey
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: <Widget>[
//                     Text(
//                       formatHistory(activity.description),
//                       style: GoogleFonts.nunitoSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           color: colors.iconColorInactive,
//                           size: 20,
//                         ),
//                         Text(
//                           "${activity.locationLat} ${activity.locationLng}",
//                           style: GoogleFonts.nunitoSans(
//                               fontSize: 12,
//                               color: colors.fontGrey
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }