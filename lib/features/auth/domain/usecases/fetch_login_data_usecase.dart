import 'package:clockify_miniproject/features/auth/data/repositories/login_password_remote_repository_impl.dart';

class FetchLoginDataUsecase {
  LoginPasswordRemoteRepository repository;

  FetchLoginDataUsecase(this.repository);

  Future<Map<String, dynamic>> call(String email, String password)async{
    return await repository.fetchUserLogin(email, password);
  }
}