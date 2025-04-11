import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterState{
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String emailTokenProvider;

  const RegisterState({this.isPasswordVisible = false, this.isConfirmPasswordVisible = false, this.emailTokenProvider = ''});

  RegisterState copyWith({
        bool? isPasswordVisible,
        bool? isConfirmPasswordVisible,
        String? emailTokenProvider
      }){
      return RegisterState(
        isPasswordVisible : isPasswordVisible ?? this.isPasswordVisible,
        isConfirmPasswordVisible : isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
        emailTokenProvider : emailTokenProvider ?? this.emailTokenProvider
      );
    }
}

class RegisterNotifier extends StateNotifier<RegisterState>{
  RegisterNotifier() : super(const RegisterState());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  void setEmailToken(String token) {
    state = state.copyWith(emailTokenProvider: token);
  }
}

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref)=> RegisterNotifier());