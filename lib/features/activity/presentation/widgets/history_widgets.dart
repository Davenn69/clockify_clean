import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/date_formatting.dart';
import '../../application/providers/history_providers.dart';
import '../../data/models/activity_hive_model.dart';
import 'activity_date_widget.dart';
import 'activity_history_widget.dart';

List<Widget> makeWidget(BuildContext context, WidgetRef ref, List<ActivityHive> activity) {
  final historyState = ref.watch(historyHiveStateNotifierProvider);
  final type = ref.watch(selectedChoiceProvider)?? "Latest Date";
  final query = ref.watch(searchQueryProvider);
  List<ActivityHive> filteredHistory;

  if (historyState.history == null || historyState.history.isEmpty) {
    return [
      FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 300)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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

  if(query.length < 3){
    filteredHistory = historyState.history;
  }else{
    filteredHistory = historyState.history.where((activity){
      return activity.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  if(filteredHistory.isEmpty){
    return [
      Center(child: Text("No results found", style: TextStyle(color : Colors.white),))
    ];
  }

  DateTime? current = DateTime(1000);
  List<Widget> content = [];

  if(type == "Latest Date"){
    for (int i = 0; i < filteredHistory.length; i++) {
      if (formatDate(filteredHistory[i].endTime).trim() !=
          formatDate(current!).trim()) {
        current = filteredHistory[i].endTime;
        content.add(activityDateWidget(filteredHistory[i].endTime));
      }
      content.add(activityHistoryWidget(filteredHistory[i], context, ref));
    }
  }else if(type == "Nearby"){
    for (int i = 0; i < filteredHistory.length; i++) {
      content.add(activityDateWidget(filteredHistory[i].endTime));
      content.add(activityHistoryWidget(filteredHistory[i], context, ref));
    }
  }else if(type == "Oldest"){
    for (int i = 0; i < filteredHistory.length; i++) {
      if (formatDate(filteredHistory[i].endTime).trim() !=
          formatDate(current!).trim()) {
        current = filteredHistory[i].endTime;
        content.add(activityDateWidget(filteredHistory[i].endTime));
      }
      content.add(activityHistoryWidget(filteredHistory[i], context, ref));
    }
  }


  return content;
}