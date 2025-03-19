import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../application/notifiers/time_location_notifier.dart';
import '../../application/providers/timer_providers.dart';

void startTimer(WidgetRef ref, TimeLocationNotifier notifier){
  final stopWatchTimer = ref.watch(stopWatchTimerProvider.notifier);
  stopWatchTimer.state = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  stopWatchTimer.state.onStartTimer();
  notifier.startTimer();
}

Future<void> stopTimer(WidgetRef ref, TimeLocationNotifier notifier)async{
  final stopWatchTimer = ref.watch(stopWatchTimerProvider.notifier);
  stopWatchTimer.state.onStopTimer();
  final elapsedMilliseconds = stopWatchTimer.state.rawTime.value;

  final duration = Duration(milliseconds:elapsedMilliseconds);
  notifier.stopTimer(duration);
}

void resetTimer(WidgetRef ref, TimeLocationNotifier notifier){
  final stopWatchTimer = ref.watch(stopWatchTimerProvider.notifier);
  stopWatchTimer.state.onResetTimer();
  notifier.resetTimer();
}