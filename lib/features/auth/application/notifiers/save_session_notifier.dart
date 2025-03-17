import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/save_session_key_usecase.dart';
import '../providers/password_view_provider.dart';

class SaveSessionNotifier extends StateNotifier<AsyncValue<void>> {
  SaveSessionNotifier(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  Future<void> saveSession(String token) async {
    try {
      state = const AsyncValue.loading();
      final repository = await ref.read(loginPasswordRepositoryProvider.future);
      await SaveSessionKey(repository).execute(token);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}