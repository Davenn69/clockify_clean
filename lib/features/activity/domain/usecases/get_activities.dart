import 'package:clockify_miniproject/features/activity/data/models/activity_hive_model.dart';
import 'package:clockify_miniproject/features/activity/data/repositories/activity_repository_impl.dart';

class GetActivities{
  final ActivityRepository repository;

  GetActivities(this.repository);

  Future<List<ActivityHive>> execute(String token, String type, double lat, double lng) async{
    return await repository.getAllActivities(token, type, lat, lng);
  }

}