import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/get_location.dart';

class TimeLocationState{
  final DateTime? startTime;
  final DateTime? endTime;
  final double? lat;
  final double? lng;
  final String? errorMessage;
  final LocationPermission? permissionStatus;

  TimeLocationState({this.startTime, this.endTime, this.lat, this.lng, this.errorMessage, this.permissionStatus});

  TimeLocationState copyWith({required bool resetStart, required bool resetEnd, DateTime? startTime, DateTime? endTime, double? lat, double? lng, String? errorMessage, LocationPermission? permissionStatus}){
    return TimeLocationState(
        startTime: resetStart ? null : (startTime ?? this.startTime),
        endTime: resetEnd ? null : (endTime ?? this.endTime),
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        errorMessage: errorMessage,
        permissionStatus: permissionStatus ?? this.permissionStatus,
    );
  }
}

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
    LocationPermission permission = await checkLocationPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      state = state.copyWith(
        errorMessage: "Location permission denied",
        permissionStatus: permission, resetStart: false, resetEnd: false,
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      state = state.copyWith(
        lat: position.latitude,
        lng: position.longitude,
        permissionStatus: permission,
        errorMessage: null, resetStart: false, resetEnd: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Failed to get location: $e",
        resetStart: false, resetEnd: false,
      );
    }
  }

}