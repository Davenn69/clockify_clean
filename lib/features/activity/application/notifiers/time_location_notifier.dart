import 'package:clockify_miniproject/features/activity/application/notifiers/time_location_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/get_location.dart';

class TimeLocationNotifier extends StateNotifier<TimeLocationState>{
  TimeLocationNotifier() : super(TimeLocationState());

  void startTimer(){
    state = state.copyWith(resetStart : false, resetEnd : false, startTime: DateTime.now());

  }

  void stopTimer(Duration duration) {
    state = state.copyWith(resetStart : false, resetEnd : false, endTime: state.startTime?.add(duration));
  }

  void resetTimer(){
    state = state.copyWith(resetStart : true, resetEnd : true);
  }

  Future<void> updateGeolocation() async {
    Position position = await getCurrentLocation();
    state = state.copyWith(resetStart : false, resetEnd : false, lat: position.latitude, lng: position.longitude);
  }

}