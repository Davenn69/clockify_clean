import '../../domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity{
  ActivityModel({
    String? uuid,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required double locationLat,
    required double locationLng,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userUuid,
  }) : super(
    uuid: uuid,
    description: description,
    startTime: startTime,
    endTime: endTime,
    locationLat: locationLat,
    locationLng: locationLng,
    createdAt: createdAt,
    updatedAt: updatedAt,
    userUuid: userUuid,
  );

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      uuid: map['uuid'],
      description: map['description'],
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      locationLat: map['location_lat'],
      locationLng: map['location_lng'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      userUuid: map['useruuid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location_lat': locationLat,
      'location_lng': locationLng,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'useruuid': userUuid,
    };
  }
}