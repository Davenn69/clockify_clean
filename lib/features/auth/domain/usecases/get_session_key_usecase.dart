import 'package:clockify_miniproject/features/auth/data/repositories/login_password_repository_impl.dart';

class GetSessionKey{
  LoginPasswordRepository repository;

  GetSessionKey(this.repository);

  Future<Map<String, String>?> call(){
    return repository.getSessionKey();
  }
}