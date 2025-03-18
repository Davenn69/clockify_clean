import 'package:clockify_miniproject/features/activity/domain/usecases/delete_activity.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/get_activities.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/save_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/activity_hive_model.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/usecases/update_activity.dart';
import '../providers/get_activities_provider.dart';
import '../providers/save_activities_provider.dart';
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

  void updateHistory(List<ActivityHive> newHistory) {
    state = HistoryHiveState(history: newHistory);
  }

  Future<void> getAllData(String token, String type, double lat, double lng) async {
    final activities = await getActivities.execute(token, type, lat, lng);

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

  Future<void> deleteContent(String uuid, String token, String type, double lat, double lng) async{
    await deleteActivity.call(uuid, token);
    getAllData(token, type, lat, lng);
  }
}
