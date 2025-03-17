import 'dart:ffi';

class TimeLocationState{
  final DateTime? startTime;
  final DateTime? endTime;
  final double? lat;
  final double? lng;

  TimeLocationState({this.startTime, this.endTime, this.lat, this.lng});

  TimeLocationState copyWith({required bool resetStart, required bool resetEnd, DateTime? startTime, DateTime? endTime, double? lat, double? lng}){
    return TimeLocationState(
        startTime: resetStart ? null : (startTime ?? this.startTime),
        endTime: resetEnd ? null : (endTime ?? this.endTime),
        lat: lat ?? this.lat,
        lng: lng ?? this.lng
    );
  }
}