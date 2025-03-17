import 'package:clockify_miniproject/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/delete_activity.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/get_activities.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/save_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/date_formatting.dart';
import '../../../detail/presentation/screen/detail_screen.dart';
import '../../data/models/activity_hive_model.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/usecases/update_activity.dart';
import '../../presentation/widgets/activity_date_widget.dart';
import '../../presentation/widgets/activity_history_widget.dart';
import '../providers/get_activities_provider.dart';
import '../providers/save_activities_provider.dart';
import '../providers/time_location_provider.dart';
import 'history_hive_state.dart';

class HistoryHiveStateNotifier extends StateNotifier<HistoryHiveState> {

  GetActivities getActivities;
  SaveActivities saveActivities;
  DeleteActivity deleteActivity;
  UpdateActivity updateActivity;
  String token;
  final Ref ref;
  final String type;
  double lat;
  double lng;

  HistoryHiveStateNotifier(this.ref, this.saveActivities, this.getActivities,
      this.deleteActivity, this.updateActivity, this.token, this.type, this.lat, this.lng) : super(HistoryHiveState(history: [])) {
    Future.microtask(() async {
      await _init(token, type, lat, lng);
    });
  }

  Future<void> _init(String token, String type, double lat, double lng) async {
    try {
      getActivities = await ref.watch(getActivitiesProvider.future);
      saveActivities = await ref.watch(saveActivitiesProvider.future);
      await getAllData(token, type, lat, lng);
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  Future<void> getAllData(String token, String type, double lat, double lng) async {
    final activities = await getActivities.execute(token, type, lat, lng);

    if (activities.isNotEmpty) {
      activities.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    state = HistoryHiveState(history: [...activities]);
  }

  void saveActivity(ActivityEntity entity, String token, String type, double lat, double lng) async {
    await saveActivities.call(entity, token);

    getAllData(token, type, lat, lng);
  }

  void updateExistingActivity(ActivityHive entity, String token, String type, double lat, double lng) async{
    await updateActivity.call(entity, token);
    getAllData(token, type, lat, lng);
  }

  List<Widget> makeWidget(BuildContext context, WidgetRef ref, TextEditingController controller) {
    final locationLng = ref.watch(timeLocationProvider).lng;
    final locationLat = ref.watch(timeLocationProvider).lat;

    if (state.history.isEmpty) {
      return [
        Center(child: CircularProgressIndicator(color: Colors.white)),
      ];
    }

    List<ActivityHive> filteredHistory = state.history.where((activity){
      return activity.description.toLowerCase().contains(controller.text.toLowerCase());
    }).toList();

    if(filteredHistory.isEmpty){
      return [
        Center(child: Text("No results found", style: TextStyle(color : Colors.white),))
      ];
    }

    DateTime? current = state.history.first.startTime;
    List<Widget> content = [];

    if(current == null){
      return [
        Center(child: Text("No results found", style: TextStyle(color : Colors.white),))
      ];
    }else{
      content.add(activityDateWidget(current));
      for (int i = 0; i < filteredHistory.length; i++) {
        if (formatDate(filteredHistory[i].startTime).trim() !=
            formatDate(current!).trim()) {
          current = filteredHistory[i].startTime;
          content.add(activityDateWidget(filteredHistory[i].startTime));
        }
        content.add(activityHistoryWidget(filteredHistory[i], context, ref));
      }
    }

    return content;
  }

  Future<void> deleteContent(String uuid, String token, String type, double lat, double lng) async{
    await deleteActivity.call(uuid, token);
    getAllData(token, type, lat, lng);
  }
}
