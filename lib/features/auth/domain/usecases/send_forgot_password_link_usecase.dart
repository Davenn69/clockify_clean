import 'package:clockify_miniproject/features/auth/data/repositories/login_password_remote_repository_impl.dart';

class SendForgotPasswordLinkUseCase{
  final LoginPasswordRemoteRepository repository;

  SendForgotPasswordLinkUseCase(this.repository);

  Future<Map<String, dynamic>?> call(String email)async{
    return await repository.sendForgotPasswordLink(email);
  }
}