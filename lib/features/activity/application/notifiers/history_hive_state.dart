import '../../data/models/activity_hive_model.dart';

class HistoryHiveState{
  late List<ActivityHive> history = [];

  HistoryHiveState({required this.history});

  HistoryHiveState getData(){
    return HistoryHiveState(
        history: [...history]
    );
  }

}