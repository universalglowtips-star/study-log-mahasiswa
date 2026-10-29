class CourseSchedule {
  const CourseSchedule({
    required this.id,
    required this.name,
    required this.lecturer,
    required this.room,
    required this.day,
    required this.startMinutes,
    required this.endMinutes,
    this.code = '',
    this.sks = 0,
    this.className = '',
  });

  final String id;
  final String name;
  final String lecturer;
  final String room;

  /// Kode mata kuliah, contoh "111500".
  final String code;

  /// Jumlah SKS. 0 = belum diisi.
  final int sks;

  /// Kelas, contoh "IFB5J".
  final String className;

  /// 1 = Senin ... 7 = Minggu (sama dengan DateTime.weekday).
  final int day;

  /// Menit sejak 00:00, contoh 08:00 = 480.
  final int startMinutes;
  final int endMinutes;

  bool overlapsWith(CourseSchedule other) =>
      day == other.day &&
      startMinutes < other.endMinutes &&
      other.startMinutes < endMinutes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lecturer': lecturer,
        'room': room,
        'code': code,
        'sks': sks,
        'className': className,
        'day': day,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
      };

  factory CourseSchedule.fromJson(Map<String, dynamic> json) => CourseSchedule(
        id: json['id'] as String,
        name: json['name'] as String,
        lecturer: json['lecturer'] as String? ?? '',
        room: json['room'] as String? ?? '',
        code: json['code'] as String? ?? '',
        sks: json['sks'] as int? ?? 0,
        className: json['className'] as String? ?? '',
        day: json['day'] as int,
        startMinutes: json['startMinutes'] as int,
        endMinutes: json['endMinutes'] as int,
      );
}
