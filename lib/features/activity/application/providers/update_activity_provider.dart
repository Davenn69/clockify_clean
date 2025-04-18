import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:clockify_miniproject/features/activity/domain/usecases/update_activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateActivityProvider = FutureProvider<UpdateActivity>(
  (ref)async{
    final repository = await ref.watch(activityRepositoryProvider.future);
    return UpdateActivity(repository);
  }
);