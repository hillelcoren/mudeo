String formatDuration(Duration duration, {bool showSeconds = true}) {
  final time = duration.toString().split('.')[0];

  if (showSeconds) {
    return time;
  } else {
    final parts = time.split(':');
    return '${parts[0]}:${parts[1]}';
  }
}
