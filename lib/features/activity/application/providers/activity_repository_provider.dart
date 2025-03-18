import 'package:clockify_miniproject/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'activity_hive_datasource_provider.dart';

final tokenProvider = StateProvider<String>((ref)=>"");

final activityRepositoryProvider = FutureProvider<ActivityRepository>((ref) async{
  final dataSource = await ref.watch(activityHiveDataSourceProvider.future);
  final remoteDataSource = await ref.watch(activityRemoteDataSourceProvider.future);

  return ActivityRepositoryImpl(dataSource, remoteDataSource);
});
