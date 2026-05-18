/// Utility functions for time and date formatting shared across widgets.
bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formatMmSs(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
}

String friendlyTime(DateTime dt, {DateTime? now}) {
  final ref = now ?? DateTime.now();
  final d0 = DateTime(ref.year, ref.month, ref.day);
  final d1 = DateTime(dt.year, dt.month, dt.day);
  final days = d0.difference(d1).inDays;
  String day = days == 0 ? '今天' : (days == 1 ? '昨天' : '$days 天前');
  String two(int n) => n.toString().padLeft(2, '0');
  return '$day · ${two(dt.hour)}:${two(dt.minute)}';
}
