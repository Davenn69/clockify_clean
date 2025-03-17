import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

final stopWatchTimerProvider = StateProvider<StopWatchTimer>((ref){
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  return stopWatchTimer;
}
);