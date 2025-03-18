import 'package:hive/hive.dart';

import '../models/activity_hive_model.dart';

class ActivityHiveDataSource{
  final CollectionBox<ActivityHive> activityBox;

  ActivityHiveDataSource(this.activityBox);

  Future<void> saveActivity(ActivityHive activity) async {
    await activityBox.put(activity.uuid, activity);
  }

  Future<List<ActivityHive>> getAllActivities() async {
    final keys = await activityBox.getAllKeys();
    List<ActivityHive> activities = [];

    for (var key in keys) {
      final data = await activityBox.get(key);
      if (data != null) {
        activities.add(data);
      }
    }

    return activities;
  }

  Future<void> deleteActivity(String uuid) async {
    await activityBox.delete(uuid);
  }
}