import 'package:flutter_riverpod/flutter_riverpod.dart';

// final changedStartTimeProvider = StateProvider<DateTime>((ref)=>DateTime.now());
// final changedEndTimeProvider = StateProvider<DateTime>((ref)=>DateTime.now());

class DetailState{
  final DateTime changedStartTime;
  final DateTime changedEndTime;

  const DetailState._({
    required this.changedEndTime,
    required this.changedStartTime,
  });

  factory DetailState({
    DateTime? changedEndTime,
    DateTime? changedStartTime
  }){
    final now = DateTime.now();
    return DetailState._(
      changedEndTime: changedEndTime ?? now,
      changedStartTime: changedStartTime ?? now,
    );
  }

  DetailState copyWith({
    DateTime? changedStartTime,
    DateTime? changedEndTime
  }){
    return DetailState(
      changedStartTime: changedStartTime ?? this.changedStartTime,
      changedEndTime: changedEndTime ?? this.changedEndTime
    );
  }
}

class DetailNotifier extends StateNotifier<DetailState>{
  DetailNotifier() : super(DetailState());

  void changeBothTime(DateTime newStartTime, DateTime newEndTime){
    state = state.copyWith(changedStartTime: newStartTime, changedEndTime: newEndTime);
  }

  void changeStartTime(DateTime newStartTime){
    state = state.copyWith(changedStartTime: newStartTime);
  }

  void changeEndTime(DateTime newEndTime){
    state = state.copyWith(changedEndTime: newEndTime);
  }
}

final detailProvider = StateNotifierProvider<DetailNotifier, DetailState>((ref)=>DetailNotifier());