import 'package:clockify_miniproject/features/activity/data/repositories/activity_repository_impl.dart';

import '../../data/models/activity_hive_model.dart';

class UpdateActivity{
  ActivityRepository repository;

  UpdateActivity(this.repository);

  Future<void> call(ActivityHive entity, String token)async{
    await  repository.updateActivity(entity, token);
  }
}