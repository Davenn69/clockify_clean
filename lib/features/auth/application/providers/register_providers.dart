import 'package:flutter_riverpod/flutter_riverpod.dart';

final isPasswordVisible = StateProvider<bool>((ref)=>false);
final isConfirmPasswordVisible = StateProvider<bool>((ref)=>false);
final emailTokenProvider = StateProvider((ref)=>"");