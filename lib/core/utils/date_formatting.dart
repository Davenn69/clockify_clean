import 'package:intl/intl.dart';

String formatTime(DateTime? time) {
  return time != null ? DateFormat('hh:mm:ss').format(time) : "-";
}

String formatDate(DateTime? time){
  return time != null ? DateFormat("dd MMM yyyy").format(time) : "-";
}

String formatDuration(Duration duration){
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));

  return "$hours : $minutes : $seconds";
}