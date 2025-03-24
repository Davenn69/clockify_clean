import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/date_formatting.dart';
import '../../application/providers/history_providers.dart';
import '../../data/models/activity_hive_model.dart';
import 'activity_date_widget.dart';
import 'activity_history_widget.dart';

List<Widget> makeWidget(BuildContext context, WidgetRef ref, List<ActivityHive> activity) {
  final historyState = ref.watch(historyHiveStateNotifierProvider);
  final type = ref.watch(selectedChoiceProvider)?? "Latest Date";

  bool isLoading = historyState.history == null || historyState.history.isEmpty;

  ActivityHive temp = ActivityHive(uuid: "", description : "", startTime: DateTime.now(), endTime: DateTime.now(), locationLat: 0, locationLng: 0, createdAt: DateTime.now(), updatedAt: DateTime.now(), userUuid: "");

  if (isLoading) {
    return [
      FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 1500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              enabled: true,
                effect: ShimmerEffect(
                    baseColor: Colors.grey[600]!,
                    highlightColor: Colors.grey[500]!,
                  duration: Duration(milliseconds: 1000),
                ),
                child: Column(
                  children: <Widget>[
                    activityDateWidget(DateTime.now()),
                    activityHistoryWidget(temp, context, ref),
                    activityDateWidget(DateTime.now()),
                    activityHistoryWidget(temp, context, ref),
                    activityDateWidget(DateTime.now()),
                    activityHistoryWidget(temp, context, ref),
                    activityDateWidget(DateTime.now()),
                    activityHistoryWidget(temp, context, ref),
                    activityDateWidget(DateTime.now()),
                    activityHistoryWidget(temp, context, ref),
                    activityDateWidget(DateTime.now()),
                    activityHistoryWidget(temp, context, ref)
                  ],
                )
            );
          }
          return Center(
            child: Text(
              "There is no data available!",
              style: GoogleFonts.nunitoSans(color: Colors.white),
            ),
          );
        },
      ),
    ];
  }

  DateTime? current = DateTime(1000);
  List<Widget> content = [];

  if(type == "Latest Date"){
    for (int i = 0; i < historyState.history.length; i++) {
      if (formatDate(historyState.history[i].startTime).trim() !=
          formatDate(current!).trim()) {
        current = historyState.history[i].startTime;
        content.add(activityDateWidget(historyState.history[i].startTime));
      }
      content.add(activityHistoryWidget(historyState.history[i], context, ref));
    }
  }else if(type == "Nearby"){
    for (int i = 0; i < historyState.history.length; i++) {
      content.add(activityDateWidget(historyState.history[i].startTime));
      content.add(activityHistoryWidget(historyState.history[i], context, ref));
    }
  }else if(type == "Oldest"){
    for (int i = 0; i < historyState.history.length; i++) {
      if (formatDate(historyState.history[i].startTime).trim() !=
          formatDate(current!).trim()) {
        current = historyState.history[i].startTime;
        content.add(activityDateWidget(historyState.history[i].startTime));
      }
      content.add(activityHistoryWidget(historyState.history[i], context, ref));
    }
  }


  return content;
}