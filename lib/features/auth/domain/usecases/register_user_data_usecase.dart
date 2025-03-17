import '../../data/repositories/login_password_remote_repository_impl.dart';

class RegisterUserDataUsecase {
  LoginPasswordRemoteRepository repository;

  RegisterUserDataUsecase(this.repository);

  Future<Map<String, dynamic>> execute(String email, String password)async{
    print("register works");
    print(email);
    return await repository.registerUserData(email, password);
  }
}