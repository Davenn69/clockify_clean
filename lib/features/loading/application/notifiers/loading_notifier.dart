import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier extends StateNotifier<AsyncValue<Map<String,String>?>>{
  final Ref ref;

  LoadingNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> checkSession()async{
    final sessionKey = await ref.read(getSessionKeyProvider.future);
    state = AsyncValue.data(sessionKey);
  }
}
