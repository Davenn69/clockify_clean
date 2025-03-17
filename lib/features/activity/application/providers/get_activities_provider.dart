import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_activities.dart';
import 'activity_repository_provider.dart';

final getActivitiesProvider = FutureProvider<GetActivities>((ref) async{
  final repository = await ref.watch(activityRepositoryProvider.future);
  return GetActivities(repository);
});