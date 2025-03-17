import 'package:clockify_miniproject/core/utils/history_formatting.dart';
import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/delete_activity_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/history_hive_state_notifier_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/time_location_provider.dart';
import 'package:clockify_miniproject/features/activity/presentation/screen/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/date_formatting.dart';
import '../../../detail/presentation/screen/detail_screen.dart';
import '../../data/models/activity_hive_model.dart';

Route _createRouteForDetail(ActivityHive activity){
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondAnimation)=>DetailScreen(activity: activity,),
      transitionDuration: Duration(milliseconds: 400),
      reverseTransitionDuration:  Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondAnimation, child){
        var tween = Tween(begin: Offset(1.0, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child,);
      }
  );
}

Widget activityHistoryWidget(ActivityHive activity, BuildContext context, WidgetRef ref){
  final deleteActivityAsync = ref.watch(deleteActivityProvider);
  final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
  final token = ref.read(tokenProvider.notifier).state;
  final type = ref.watch(selectedChoiceProvider);
  final lat = ref.watch(timeLocationProvider).lat;
  final lng = ref.watch(timeLocationProvider).lng;

  return Slidable(
    endActionPane: ActionPane(motion: const DrawerMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) async {
              historyNotifier.deleteContent(activity.uuid, token, type!, lat!, lng!);
            },
            backgroundColor: Colors.redAccent,
            label: 'Delete',
          ),
        ]
    ),
    child: SizedBox(
      height: 60,
      width: double.infinity,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(_createRouteForDetail(activity));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey.withAlpha(100),
                    width: 1
                )
            ),
            color: Colors.transparent,
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
                      formatDuration(activity.endTime.difference(activity.startTime)),
                      style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.lock_clock,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          "${formatTime(activity.startTime)} - ${formatTime(activity.endTime)}",
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: Colors.grey
                          ),
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
                      formatHistory(activity.description),
                      style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          "${activity.locationLat} ${activity.locationLng}",
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: Colors.grey
                          ),
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