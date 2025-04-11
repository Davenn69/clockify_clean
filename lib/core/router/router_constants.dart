import 'package:flutter/cupertino.dart';

class _RouterPaths{
  final String login = 'login';
  final String register = 'register';
  final String password = 'password';
  final String loading = 'loading';
  final String loadingToContent = 'loading_content';
  final String timer = 'timer';
  final String activity = 'activity';
  final String detail = 'detail';
}

final routes = _RouterPaths();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get ctx => navigatorKey.currentContext!;