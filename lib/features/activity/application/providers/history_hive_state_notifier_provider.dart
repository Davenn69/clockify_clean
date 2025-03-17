import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/get_activities_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/time_location_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/update_activity_provider.dart';
import 'package:clockify_miniproject/features/activity/presentation/screen/history_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../notifiers/history_hive_notifier.dart';
import '../notifiers/history_hive_state.dart';

final historyHiveStateNotifierProvider = StateNotifierProvider<HistoryHiveStateNotifier, HistoryHiveState>((ref){
  final getActivities = ref.watch(getActivitiesSyncProvider);
  final saveActivities = ref.watch(saveActivitiesSyncProvider);
  final deleteActivity = ref.watch(deleteActivitySyncProvider);
  final updateActivity = ref.watch(updateActivitySyncProvider);
  final token = ref.watch(tokenProvider.notifier).state;
  final type = ref.watch(selectedChoiceProvider);
  final lat = ref.watch(timeLocationProvider).lat;
  final lng = ref.watch(timeLocationProvider).lng;

  return HistoryHiveStateNotifier(ref, saveActivities, getActivities, deleteActivity, updateActivity, token, type!, lat!, lng!);
});