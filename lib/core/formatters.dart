const List<String> _dayNames = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const List<String> _shortDayNames = [
  'SEN',
  'SEL',
  'RAB',
  'KAM',
  'JUM',
  'SAB',
  'MIN',
];

const List<String> _monthNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// [weekday] mengikuti DateTime.weekday (1 = Senin ... 7 = Minggu).
String dayName(int weekday) => _dayNames[weekday - 1];

String shortDayName(int weekday) => _shortDayNames[weekday - 1];

/// Contoh: "Kamis, 29 Oktober 2026".
String formatDateLong(DateTime d) =>
    '${dayName(d.weekday)}, ${d.day} ${_monthNames[d.month - 1]} ${d.year}';

/// Mengubah menit sejak 00:00 menjadi "HH:mm".
String formatMinutes(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

String initialsOf(String name) {
  final parts =
      name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  final second = parts.length > 1 ? parts[1][0] : '';
  return (parts.first[0] + second).toUpperCase();
}
