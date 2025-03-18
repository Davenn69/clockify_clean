import 'package:hive/hive.dart';

class LoginPasswordDataSource{
  final CollectionBox<Map<dynamic, dynamic>> loginSessionBox;

  LoginPasswordDataSource(this.loginSessionBox);

  Future<void> saveSession(String session, String token)async {
    final expiryTime = DateTime.now().add(Duration(minutes: 1)).millisecondsSinceEpoch;
    await loginSessionBox.put("sessionData", {
      "sessionKey" : session,
      "expiryTime" : expiryTime,
      "token" : token,
    });
  }

  Future<Map<String, String>?> getSession()async{
    final sessionData = await loginSessionBox.get("sessionData");

    if (sessionData == null) {
      return null;
    }

    final typedSessionData = Map<String, dynamic>.from(sessionData);

    final expiryTime = typedSessionData["expiryTime"] as int;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (now > expiryTime) {
      await loginSessionBox.delete("sessionData");
      return null;
    }

    return {
      'sessionKey' : typedSessionData["sessionKey"],
      'token' : typedSessionData["token"]
    };
  }

}