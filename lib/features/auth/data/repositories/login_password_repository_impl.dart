import 'dart:convert';
import 'dart:math';
import 'package:clockify_miniproject/features/auth/data/datasources/login_password_data_source.dart';

abstract class LoginPasswordRepository{
  Future<void> saveSessionKey(String token);
  Future<Map<String, String>?> getSessionKey();
}

class LoginPasswordRepositoryImpl implements LoginPasswordRepository{
  final LoginPasswordDataSource dataSource;

  LoginPasswordRepositoryImpl(this.dataSource);

  @override
  Future<void> saveSessionKey(String token)async {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    String sessionKey = base64Url.encode(values);

    await dataSource.saveSession(sessionKey, token);
  }

  @override
  Future<Map<String, String>?> getSessionKey() async{
    return await dataSource.getSession();
  }
}