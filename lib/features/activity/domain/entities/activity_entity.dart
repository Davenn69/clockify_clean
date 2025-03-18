class ActivityEntity{
  late String? uuid;
  late String description;
  late DateTime startTime;
  late DateTime endTime;
  late double? locationLat;
  late double? locationLng;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String userUuid;

  ActivityEntity({this.uuid, required this.description, required this.startTime, required this.endTime, required this.locationLat, required this.locationLng, required this.createdAt, required this.updatedAt, required this.userUuid});
}