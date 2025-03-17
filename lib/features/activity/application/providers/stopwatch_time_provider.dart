import 'package:clockify_miniproject/features/activity/application/providers/stopwatch_timer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopWatchTimeProvider = StreamProvider<int>((ref){
  final stopWatch = ref.watch(stopWatchTimerProvider);
  return stopWatch.rawTime;
});