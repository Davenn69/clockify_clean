import 'package:clockify_miniproject/features/activity/data/repositories/activity_repository_impl.dart';

class DeleteActivity{
  ActivityRepository repository;

  DeleteActivity(this.repository);

  Future<void> call(String uuid, String token) async{
    await repository.deleteActivity(uuid, token);
  }
}