import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewNotifier extends StateNotifier<String>{
  LoginViewNotifier() : super('');

  void updateEmail(String email){
    state = email;
  }
}
