import 'package:clockify_miniproject/features/auth/application/notifiers/login_view_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewProvider = StateNotifierProvider<LoginViewNotifier, String>(
    (ref){return LoginViewNotifier();}
);
