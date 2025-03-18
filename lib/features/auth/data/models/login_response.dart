import 'package:clockify_miniproject/features/auth/data/models/user_data.dart';

import 'error_data.dart';

class LoginSuccess {
  final String status;
  final String message;
  final UserData user;
  final String token;

  LoginSuccess(this.status, this.message, this.user, this.token);

  Map<String, dynamic> toMap(){
    return {
      'status' : status,
      'message' : message,
      'user' : user.toMap(),
      'token' : token
    };
  }
}

class LoginFail{
  final String status;
  final ErrorData errors;

  LoginFail(this.status, this.errors);

  Map<String, dynamic> toMap(){
    return {
      'status' : status,
      'errors' : errors.toMap()
    };
  }
}
