import 'package:clockify_miniproject/features/auth/data/repositories/login_password_remote_repository_impl.dart';

class VerifyUserUseCase{
  final LoginPasswordRemoteRepository repository;

  VerifyUserUseCase(this.repository);

  Future<Map<String, dynamic>> execute(String emailToken)async{
    return await repository.verifyEmail(emailToken);
  }
}