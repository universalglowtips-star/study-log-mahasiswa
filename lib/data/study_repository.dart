import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/course_schedule.dart';
import '../models/student_profile.dart';

/// Satu-satunya tempat yang tahu cara menyimpan data.
/// Nanti kalau mau pindah ke SQLite / REST API, cukup ganti class ini.
class StudyRepository {
  StudyRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _profileKey = 'student_profile_v1';
  static const _photoKey = 'profile_photo_v1';
  static const _coursesKey = 'course_schedule_v2';

  StudentProfile? loadProfile() {
    final raw = _prefs.getString(_profileKey);
    if (raw == null) return null;
    try {
      return StudentProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(StudentProfile profile) =>
      _prefs.setString(_profileKey, jsonEncode(profile.toJson()));

  /// Foto profil disimpan sebagai base64 (sudah dikecilkan saat dipilih).
  /// Cara ini jalan di web, Android, dan desktop dengan kode yang sama.
  Uint8List? loadPhoto() {
    final raw = _prefs.getString(_photoKey);
    if (raw == null) return null;
    try {
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> savePhoto(Uint8List bytes) =>
      _prefs.setString(_photoKey, base64Encode(bytes));

  Future<void> clearPhoto() => _prefs.remove(_photoKey);

  /// null = belum pernah disimpan (atau data rusak), bukan "kosong".
  /// Daftar kosong hasil hapus manual tetap dikembalikan sebagai [].
  List<CourseSchedule>? loadCourses() {
    final raw = _prefs.getString(_coursesKey);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CourseSchedule.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCourses(List<CourseSchedule> courses) => _prefs.setString(
        _coursesKey,
        jsonEncode(courses.map((c) => c.toJson()).toList()),
      );
}
