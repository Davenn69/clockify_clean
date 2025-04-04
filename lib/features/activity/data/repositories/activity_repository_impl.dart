import 'package:clockify_miniproject/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/activity_entity.dart';
import '../datasources/activity_hive_data_source.dart';
import '../models/activity_hive_model.dart';

abstract class ActivityRepository{
  Future<void> saveActivity(ActivityEntity entity, String token);
  Future<List<ActivityHive>> getAllActivities(String token, String type, String query, double lat, double lng);
  Future<void> deleteActivity(String uuid, String token);
  Future<void> updateActivity(ActivityHive entity, String token);
}

class ActivityRepositoryImpl implements ActivityRepository{
  final ActivityHiveDataSource dataSource;
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl(this.dataSource, this.remoteDataSource);

  Future<bool> hasInternet() async {
    var connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.contains(ConnectivityResult.mobile) || connectivityResults.contains(ConnectivityResult.wifi);
  }

  @override
  Future<void> saveActivity(ActivityEntity entity, String token) async {
    // if(await hasInternet()){
      try{
        final response = await remoteDataSource.saveHistory(entity, token);
        final data = response.data['data']['activity'];
        final activityHive = ActivityHive(
          uuid: data['uuid'],
          description: data['description'],
          startTime: DateTime.parse(data['start_time']),
          endTime: DateTime.parse(data['end_time']),
          locationLat: data['location_lat'],
          locationLng: data['location_lng'],
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
          userUuid: data['user_uuid'],
        );
        await dataSource.saveActivity(activityHive);
      }catch(e){
        String uuid = Uuid().v4();
        final activityHive = ActivityHive(
          uuid: uuid,
          description: entity.description,
          startTime: entity.startTime,
          endTime: entity.endTime,
          locationLat: entity.locationLat,
          locationLng: entity.locationLng,
          createdAt: entity.createdAt,
          updatedAt: entity.updatedAt,
          userUuid: entity.userUuid,
        );
        await dataSource.saveActivity(activityHive);
        throw Exception("Remote repository error $e");
      }
    // }

  }

  @override
  Future<void> updateActivity(ActivityHive entity, String token) async{
    try{
      await remoteDataSource.updateActivity(entity.uuid, entity.description, token, entity.startTime, entity.endTime, entity.locationLat, entity.locationLng);

      final activityHive = ActivityHive(
        uuid: entity.uuid,
        description: entity.description,
        startTime: entity.startTime,
        endTime: entity.endTime,
        locationLat: entity.locationLat,
        locationLng: entity.locationLng,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        userUuid: entity.userUuid,
      );

      await dataSource.saveActivity(activityHive);
    }catch(e){
      throw Exception("Repository error $e");
    }
  }
  @override
  Future<List<ActivityHive>> getAllActivities(String token, String type, String query, double lat, double lng) async {

    try {
      // print(await hasInternet());
      if (await hasInternet()) {
        final response = await remoteDataSource.getHistory(
            token, type, query, lat, lng);
        final data = response.data['data']['activities'];
        List<ActivityHive> remoteActivities = data.map((json) =>
            ActivityHive.fromJson(json)).cast<ActivityHive>().toList();

        for (int i = 0; i < remoteActivities.length; i++) {
          dataSource.saveActivity(remoteActivities[i]);
        }

        return remoteActivities;
      }

      return [];
      } catch (e) {
      return [];
      // throw Exception("Repository error $e");
    }

    // final activities = await dataSource.getAllActivities();
    // return activities.map((e) => ActivityHive(
    //   uuid: e.uuid,
    //   description: e.description,
    //   createdAt: e.createdAt,
    //   updatedAt: e.updatedAt,
    //   startTime: e.startTime,
    //   endTime: e.endTime,
    //   locationLat: e.locationLat,
    //   locationLng: e.locationLng,
    //   userUuid: e.userUuid
    // )).toList();

  }

  @override
  Future<void> deleteActivity(String uuid, String token) async {
    await dataSource.deleteActivity(uuid);
    await remoteDataSource.deleteActivity(uuid, token);
  }

}
