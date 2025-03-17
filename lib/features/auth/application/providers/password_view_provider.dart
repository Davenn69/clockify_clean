import 'package:clockify_miniproject/features/auth/data/datasources/login_password_data_source.dart';
import 'package:clockify_miniproject/features/auth/data/repositories/login_password_remote_repository_impl.dart';
import 'package:clockify_miniproject/features/auth/data/repositories/login_password_repository_impl.dart';
import 'package:clockify_miniproject/features/auth/domain/usecases/fetch_login_data_usecase.dart';
import 'package:clockify_miniproject/features/auth/domain/usecases/get_session_key_usecase.dart';
import 'package:clockify_miniproject/features/auth/domain/usecases/register_user_data_usecase.dart';
import 'package:clockify_miniproject/features/auth/domain/usecases/save_session_key_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/login_password_remote_data_source.dart';
import '../notifiers/save_session_notifier.dart';

final loginPasswordDataSourceProvider = FutureProvider((ref)async{
  final collection = await BoxCollection.open("MyAppCollection", {"sessionBox"});

  final CollectionBox<Map<dynamic, dynamic>> box = await collection.openBox("sessionBox");

  return LoginPasswordDataSource(box);
});

final loginPasswordRepositoryProvider = FutureProvider((ref)async{
  final dataSource = await ref.watch(loginPasswordDataSourceProvider.future);

  return LoginPasswordRepositoryImpl(dataSource);
});

// final saveSessionKeyProvider = FutureProvider.family((ref, String token)async{
//   final repository = await ref.watch(loginPasswordRepositoryProvider.future);
//   return SaveSessionKey(repository).execute(token);
// });

final saveSessionKeyProvider = StateNotifierProvider<SaveSessionNotifier, AsyncValue<void>>(
      (ref) => SaveSessionNotifier(ref),
);

final getSessionKeyProvider = FutureProvider<Map<String, String>?>((ref)async{
  final repository = await ref.watch(loginPasswordRepositoryProvider.future);
  return GetSessionKey(repository).call();
});

final loginPasswordRemoteDataSourceProvider = FutureProvider((ref)async{
  return LoginPasswordRemoteDataSource();
});

final loginPasswordRemoteRepositoryProvider = FutureProvider((ref)async{
  final dataSource = await ref.watch(loginPasswordRemoteDataSourceProvider.future);
  return LoginPasswordRemoteRepositoryImpl(dataSource);
});

final fetchLoginDataProvider = FutureProvider.family((ref, Map<String, String> credentials)async{
  final repository = await ref.watch(loginPasswordRemoteRepositoryProvider.future);
  return FetchLoginDataUsecase(repository).call(credentials['email']!, credentials['password']!);
});

final registerUserDataProvider = FutureProvider.family((ref, Map<String, String> credentials)async{
  final repository = await ref.watch(loginPasswordRemoteRepositoryProvider.future);
  return RegisterUserDataUsecase(repository).execute(credentials['email']!, credentials['password']!);
});