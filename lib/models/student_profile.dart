class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.nim,
    required this.major,
    required this.campus,
    required this.className,
    required this.semester,
  });

  final String name;
  final String nim;
  final String major;
  final String campus;
  final String className;
  final int semester;

  Map<String, dynamic> toJson() => {
        'name': name,
        'nim': nim,
        'major': major,
        'campus': campus,
        'className': className,
        'semester': semester,
      };

  factory StudentProfile.fromJson(Map<String, dynamic> json) => StudentProfile(
        name: json['name'] as String,
        nim: json['nim'] as String,
        major: json['major'] as String,
        campus: json['campus'] as String,
        className: json['className'] as String,
        semester: json['semester'] as int,
      );
}
