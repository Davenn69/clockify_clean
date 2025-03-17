import 'package:clockify_miniproject/features/activity/data/repositories/activity_repository_impl.dart';
import '../entities/activity_entity.dart';

class SaveActivities{
  final ActivityRepository repository;
  
  SaveActivities(this.repository);
  
  Future<void> call(ActivityEntity entity, String token)async{
    await repository.saveActivity(entity, token);
  }
}