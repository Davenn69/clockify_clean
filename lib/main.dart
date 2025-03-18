import 'package:clockify_miniproject/features/activity/application/providers/delete_activity_provider.dart';
import 'package:clockify_miniproject/features/activity/application/providers/update_activity_provider.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/delete_activity.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/activity/application/providers/get_activities_provider.dart';
import 'features/activity/application/providers/save_activities_provider.dart';
import 'features/activity/data/models/activity_hive_model.dart';
import 'features/activity/domain/usecases/get_activities.dart';
import 'features/activity/domain/usecases/save_activity.dart';
import 'features/activity/domain/usecases/update_activity.dart';
import 'features/activity/presentation/screen/history_screen.dart';
import 'features/activity/presentation/screen/timer_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/password_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/detail/presentation/screen/detail_screen.dart';
import 'features/loading/presentation/loading_screen.dart';
import 'features/loading/presentation/loading_to_content_screen.dart';

final getActivitiesSyncProvider = Provider<GetActivities>((ref) {
  throw Exception("getActivitiesSyncProvider is not initialized");
});

final saveActivitiesSyncProvider = Provider<SaveActivities>((ref) {
  throw Exception("saveActivitiesSyncProvider is not initialized");
});

final deleteActivitySyncProvider = Provider<DeleteActivity>((ref) {
  throw Exception("deleteActivitiesSyncProvider is not initialized");
});

final updateActivitySyncProvider = Provider<UpdateActivity>((ref) {
  throw Exception("deleteActivitiesSyncProvider is not initialized");
});

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);
  Hive.registerAdapter(ActivityHiveAdapter());

  final collection = await BoxCollection.open(
      'MyAppCollection',
      {'activityBox', 'sessionBox'},
      path: appDir.path
  );

  final activityBox = await collection.openBox<Map>('activityBox');

  final container = ProviderContainer();
  final getActivities = await container.read(getActivitiesProvider.future);
  final saveActivities = await container.read(saveActivitiesProvider.future);
  final deleteActivity = await container.read(deleteActivityProvider.future);
  final updateActivity = await container.read(updateActivityProvider.future);
  container.dispose();

  runApp(ProviderScope(
    overrides: [
      getActivitiesSyncProvider.overrideWithValue(getActivities),
      saveActivitiesSyncProvider.overrideWithValue(saveActivities),
      deleteActivitySyncProvider.overrideWithValue(deleteActivity),
      updateActivitySyncProvider.overrideWithValue(updateActivity)
    ],
    child: MaterialApp(
      initialRoute: "/",
      routes: {
        '/' : (context) => LoadingScreen(),
        '/login' : (context) => LoginScreen(),
        '/password' : (context) => PasswordScreen(email: '',),
        '/register' : (context) => RegisterScreen(),
        '/loading_content' : (context) => LoadingContentScreen(),
        '/content' : (context) => ContentScreen(),
        '/activity' : (context) => ActivityScreen(),
        '/detail' : (context) => DetailScreen(activity: ActivityHive(uuid: '', description: '', startTime: DateTime.now(), endTime: DateTime.now()
            , locationLat: 0, locationLng: 0, createdAt: DateTime.now(), updatedAt: DateTime.now(), userUuid: ""),),
        // '/verify-email' : (context) => MyApp(),
      },
    ),
  ));
}