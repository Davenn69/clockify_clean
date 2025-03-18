import 'package:clockify_miniproject/features/activity/data/datasources/activity_remote_data_source.dart';

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

    // if(await hasInternet()){
      try{
        final response = await remoteDataSource.saveHistory(entity, token);
        final data = response.data['data']['activity'] as ActivityHive;

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
        throw Exception("Repository error $e");
      }
    // }

  }

  @override
  Future<void> updateActivity(ActivityHive entity, String token) async{
    try{
      final response = await remoteDataSource.updateActivity(entity.uuid, entity.description, token);

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
  Future<List<ActivityHive>> getAllActivities(String token, String type, double lat, double lng) async {

    if(type == "Latest Date"){
      try{
        // print(await hasInternet());
        // if(await hasInternet()){
        final response = await remoteDataSource.getFilteredByLatestDateHistory(token);
        final data = response.data['data']['activities'];
        List<ActivityHive> remoteActivities = data.map((json)=>ActivityHive.fromJson(json)).cast<ActivityHive>().toList();

        for(int i=0; i<remoteActivities.length; i++){
          dataSource.saveActivity(remoteActivities[i]);
        }

        return remoteActivities;
        // }
      }catch(e){
        // throw Exception("Repository error $e");
      }
    }else if(type == "Nearby"){
      try{
        // print(await hasInternet());
        // if(await hasInternet()){
        final response = await remoteDataSource.getFilteredByNearbyHistory(token, lat, lng);
        final data = response.data['data']['activities'];
        List<ActivityHive> remoteActivities = data.map((json)=>ActivityHive.fromJson(json)).cast<ActivityHive>().toList();

        for(int i=0; i<remoteActivities.length; i++){
          dataSource.saveActivity(remoteActivities[i]);
        }

        return remoteActivities;
        // }
      }catch(e){
        // throw Exception("Repository error $e");
      }
    }

    try{
      // print(await hasInternet());
      // if(await hasInternet()){
        final response = await remoteDataSource.getHistory(token);
        final data = response.data['data']['activities'];
        List<ActivityHive> remoteActivities = data.map((json)=>ActivityHive.fromJson(json)).cast<ActivityHive>().toList();

        for(int i=0; i<remoteActivities.length; i++){
          dataSource.saveActivity(remoteActivities[i]);
        }

        return remoteActivities;
      // }
    }catch(e){
      // throw Exception("Repository error $e");
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
