import 'package:clockify_miniproject/features/loading/application/notifiers/loading_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingNotifierProvider = StateNotifierProvider<LoadingNotifier, AsyncValue<Map<String, String>?>>((ref){
  return LoadingNotifier(ref);
});