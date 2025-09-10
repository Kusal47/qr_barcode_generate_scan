
double? parseToDouble(dynamic value) {
  if (value is String) {
    return double.tryParse(value);
  } else if (value is num) {
    return value.toDouble();
  }
  return null;
}

String formatDistance(double meters) {
  double km = meters / 1000;
  return "${km.toStringAsFixed(2)} km";
}

String formatDuration(double seconds) {
  int hours = (seconds ~/ 3600);
  int minutes = ((seconds % 3600) ~/ 60);

  if (hours > 0) {
    return "$hours : $minutes min";
  } else {
    return "$minutes min";
  }
}

String formatPercentage(String percentage) {
  final value = double.tryParse(percentage) ?? 0;
  return value % 1 == 0 ? value.toStringAsFixed(0) : value.toString();
}

String formatTime(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

Stream<String> countdownTimer(Duration duration) async* {
  var remainingTime = duration;

  while (remainingTime > Duration.zero) {
    await Future.delayed(const Duration(seconds: 1));
    remainingTime -= const Duration(seconds: 1);
    yield formatTime(remainingTime);
  }
  yield "00:00"; // Timer ends
}
