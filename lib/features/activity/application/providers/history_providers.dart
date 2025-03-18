import 'package:clockify_miniproject/features/activity/application/providers/timer_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../main.dart';
import '../notifiers/history_hive_notifier.dart';
import '../notifiers/history_hive_state.dart';
import 'activity_repository_provider.dart';

final selectedChoiceProvider = StateProvider<String?>((ref)=>"Latest Date");

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