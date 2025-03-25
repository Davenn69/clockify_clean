import 'package:clockify_miniproject/features/auth/data/datasources/login_password_remote_data_source.dart';
import 'package:clockify_miniproject/features/auth/data/models/error_data.dart';
import 'package:clockify_miniproject/features/auth/data/models/login_response.dart';
import 'package:dio/dio.dart';

import '../models/user_data.dart';

abstract class LoginPasswordRemoteRepository{
  Future<Map<String, dynamic>> fetchUserLogin(String email, String password);
  Future<Map<String, dynamic>> registerUserData(String email, String password, String confirmPassword);
  Future<Map<String, dynamic>> sendForgotPasswordLink(String email);
  Future<Map<String, dynamic>> verifyEmail(String emailToken);
}

class LoginPasswordRemoteRepositoryImpl implements LoginPasswordRemoteRepository{
  LoginPasswordRemoteDataSource dataSource;

  LoginPasswordRemoteRepositoryImpl(this.dataSource);

  @override
  Future<Map<String, dynamic>> fetchUserLogin(String email, String password) async {
    Response response = await dataSource.fetchUserLogin(email, password);
    if(response.statusCode == 200){
      return LoginSuccess(response.data["status"], response.data["message"], UserData(response.data['user']["uuid"], response.data['user']["email"]), response.data["token"]).toMap();
    }else if (response.statusCode == 404 || response.statusCode == 401){
      return LoginFail(response.data["status"] ?? "fail", ErrorData(response.data['errors']["message"] ?? "Unknown error occurred")).toMap();
    }

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> registerUserData(String email, String password, String confirmPassword)async{

    Response response = await dataSource.registerUserData(email, password, confirmPassword);

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> sendForgotPasswordLink(String email)async{
    Response? response = await dataSource.sendForgotPasswordLink(email);

    return response != null ? response.data : {"error" : "Unknown error occurred"};
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(String emailToken) async{
    Response? response = await dataSource.verifyEmail(emailToken);

    return response != null ? response.data : {"error" : 'Unknown error occurred'};
  }
}
