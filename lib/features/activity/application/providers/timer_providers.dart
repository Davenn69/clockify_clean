import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../notifiers/time_location_notifier.dart';

final timeLocationProvider = StateNotifierProvider<TimeLocationNotifier, TimeLocationState>((ref){
  return TimeLocationNotifier();
});

final stopWatchTimerProvider = StateProvider<StopWatchTimer>((ref){
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  return stopWatchTimer;
}
);

final stopWatchTimeProvider = StreamProvider<int>((ref){
  final stopWatch = ref.watch(stopWatchTimerProvider);
  return stopWatch.rawTime;
});