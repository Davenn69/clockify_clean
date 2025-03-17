import 'package:clockify_miniproject/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/activity_entity.dart';
import '../datasources/activity_hive_data_source.dart';
import '../models/activity_hive_model.dart';

abstract class ActivityRepository{
  Future<void> saveActivity(ActivityEntity entity, String token);
  Future<List<ActivityHive>> getAllActivities(String token, String type, double lat, double lng);
  Future<void> deleteActivity(String uuid, String token);
  Future<void> updateActivity(ActivityHive entity, String token);
}

class ActivityRepositoryImpl implements ActivityRepository{
  final ActivityHiveDataSource dataSource;
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl(this.dataSource, this.remoteDataSource);

  // Future<bool> hasInternet() async {
  //   var connectivityResults = await Connectivity().checkConnectivity();
  //   return connectivityResults.contains(ConnectivityResult.mobile) || connectivityResults.contains(ConnectivityResult.wifi);
  // }

  @override
  Future<void> saveActivity(ActivityEntity entity, String token) async {

    print("here now");
    // if(await hasInternet()){
      try{
        final response = await remoteDataSource.saveHistory(entity, token);
        final data = response.data['data']['activity'] as ActivityHive;
        print("Success save + $data");

        final activityHive = ActivityHive(
          uuid: data.uuid,
          description: data.description,
          startTime: data.startTime,
          endTime: data.endTime,
          locationLat: data.locationLat,
          locationLng: data.locationLng,
          createdAt: data.createdAt,
          updatedAt: data.updatedAt,
          userUuid: data.userUuid,
        );

        await dataSource.saveActivity(activityHive);
      }catch(e){
        print("error");
        print("Remote dataSource Error $e");
      }
    // }

  }

  @override
  Future<void> updateActivity(ActivityHive entity, String token) async{
    try{
      print("This is new + ${entity.description}");
      final response = await remoteDataSource.updateActivity(entity.uuid, entity.description, token);
      final data = response.data['activity'];

      print(data);

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
      print("repository error + $e");
    }
  }
  @override
  Future<List<ActivityHive>> getAllActivities(String token, String type, double lat, double lng) async {

    if(type == "Latest Date"){
      try{
        print("This is internet time");
        print("Token token here $token");
        // print(await hasInternet());
        // if(await hasInternet()){
        final response = await remoteDataSource.getFilteredByLatestDateHistory(token);
        print("dadadadasdddadad ${response}");
        final data = response.data['data']['activities'];
        print(response.data);
        List<ActivityHive> remoteActivities = data.map((json)=>ActivityHive.fromJson(json)).cast<ActivityHive>().toList();

        return remoteActivities;
        // }
      }catch(e){
        print("Remote data source error $e");
      }
    }else if(type == "Nearby"){
      try{
        print("This is internet time");
        print("Token token here $token");
        // print(await hasInternet());
        // if(await hasInternet()){
        final response = await remoteDataSource.getFilteredByNearbyHistory(token, lat, lng);
        print("dadadadasdddadad ${response}");
        final data = response.data['data']['activities'];
        print(response.data);
        List<ActivityHive> remoteActivities = data.map((json)=>ActivityHive.fromJson(json)).cast<ActivityHive>().toList();

        return remoteActivities;
        // }
      }catch(e){
        print("Remote data source error $e");
      }
    }

    try{
      print("This is internet time");
      print("Token token here $token");
      // print(await hasInternet());
      // if(await hasInternet()){
        final response = await remoteDataSource.getHistory(token);
        print("dadadadasdddadad ${response}");
        final data = response.data['data']['activities'];
        print(response.data);
        List<ActivityHive> remoteActivities = data.map((json)=>ActivityHive.fromJson(json)).cast<ActivityHive>().toList();

        return remoteActivities;
      // }
    }catch(e){
      print("Remote data source error $e");
    }


    final activities = await dataSource.getAllActivities();
    return activities.map((e) => ActivityHive(
      uuid: e.uuid,
      description: e.description,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      startTime: e.startTime,
      endTime: e.endTime,
      locationLat: e.locationLat,
      locationLng: e.locationLng,
      userUuid: e.userUuid
    )).toList();
  }

  @override
  Future<void> deleteActivity(String uuid, String token) async {
    await dataSource.deleteActivity(uuid);
    await remoteDataSource.deleteActivity(uuid, token);
  }

}
