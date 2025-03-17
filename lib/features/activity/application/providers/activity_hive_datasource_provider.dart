import 'package:clockify_miniproject/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:clockify_miniproject/features/activity/data/models/activity_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/activity_hive_data_source.dart';

final activityHiveDataSourceProvider = FutureProvider<ActivityHiveDataSource>((ref) async {
  final collection = await BoxCollection.open('MyAppCollection',
  {'activityBox'});

  final box = await collection.openBox<ActivityHive>('activityBox');

  return ActivityHiveDataSource(box);
});

final activityRemoteDataSourceProvider = FutureProvider<ActivityRemoteDataSource>((ref)async{
  return ActivityRemoteDataSource();
});