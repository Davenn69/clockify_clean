import 'package:clockify_miniproject/features/auth/data/repositories/login_password_repository_impl.dart';

class SaveSessionKey{
  final LoginPasswordRepository repository;

  SaveSessionKey(this.repository);

  Future<void> execute(String token)async{
    await repository.saveSessionKey(token);
  }
}