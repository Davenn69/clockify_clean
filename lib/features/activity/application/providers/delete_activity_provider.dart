import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/delete_activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteActivityProvider = FutureProvider((ref)async{
  final repository = await ref.watch(activityRepositoryProvider.future);

  return DeleteActivity(repository);
});