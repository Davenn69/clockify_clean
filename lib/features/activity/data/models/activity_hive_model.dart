import 'package:hive/hive.dart';
part 'activity_hive_model.g.dart';

@HiveType(typeId: 0)
class ActivityHive extends HiveObject{
  @HiveField(0)
  String uuid;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime endTime;

  @HiveField(4)
  double locationLat;

  @HiveField(5)
  double locationLng;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  @HiveField(8)
  String userUuid;

  ActivityHive({
    required this.uuid,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.locationLat,
    required this.locationLng,
    required this.createdAt,
    required this.updatedAt,
    required this.userUuid,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'useruuid': userUuid,
    };
  }

  factory ActivityHive.fromMap(Map<String, dynamic> data) {
    return ActivityHive(
      uuid: data['uuid'],
      description: data['description'],
      startTime: DateTime.parse(data['start_time']),
      endTime: DateTime.parse(data['end_time']),
      locationLat: data['location_lat'],
      locationLng: data['location_lng'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
      userUuid: data['useruuid'],
    );
  }

  factory ActivityHive.fromJson(Map<String, dynamic> json) {
    return ActivityHive(
      uuid: json['uuid'] as String,
      description: json['description'] as String,
      startTime : DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      locationLng: json['location_lat'].toDouble(),
      locationLat: json['location_lng'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userUuid: json['user_uuid']
    );
  }
}