import 'package:flutter_riverpod/flutter_riverpod.dart';

final changedStartTimeProvider = StateProvider<DateTime>((ref)=>DateTime.now());
final changedEndTimeProvider = StateProvider<DateTime>((ref)=>DateTime.now());