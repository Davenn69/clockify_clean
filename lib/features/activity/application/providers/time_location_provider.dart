import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/time_location_notifier.dart';
import '../notifiers/time_location_state.dart';

final timeLocationProvider = StateNotifierProvider<TimeLocationNotifier, TimeLocationState>((ref){
  return TimeLocationNotifier();
});