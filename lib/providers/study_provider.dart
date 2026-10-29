import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../core/seed_data.dart';
import '../data/study_repository.dart';
import '../models/course_schedule.dart';
import '../models/student_profile.dart';

/// Kelas yang paling dekat dengan waktu sekarang.
class NextClass {
  const NextClass({
    required this.course,
    required this.dayOffset,
    required this.minutesUntil,
    required this.ongoing,
  });

  final CourseSchedule course;

  /// 0 = hari ini, 1 = besok, 7 = minggu depan (hari yang sama).
  final int dayOffset;
  final int minutesUntil;
  final bool ongoing;
}

class StudyProvider extends ChangeNotifier {
  StudyProvider(this._repo);

  final StudyRepository _repo;

  StudentProfile? _profile;
  Uint8List? _photo;
  List<CourseSchedule> _courses = [];

  StudentProfile? get profile => _profile;
  Uint8List? get photoBytes => _photo;
  List<CourseSchedule> get courses => List.unmodifiable(_courses);

  void load() {
    _profile = _repo.loadProfile();
    _photo = _repo.loadPhoto();

    final saved = _repo.loadCourses();
    if (saved == null) {
      // Pertama kali dibuka: isi dengan jadwal awal supaya langsung tampil.
      _courses = List.of(defaultSchedule);
      unawaited(_repo.saveCourses(_courses));
    } else {
      _courses = saved;
    }
    _sort();
  }

  /// Jadwal pada hari tertentu (1 = Senin ... 7 = Minggu), urut jam mulai.
  List<CourseSchedule> coursesOn(int weekday) =>
      _courses.where((c) => c.day == weekday).toList();

  /// Kelas yang sedang berlangsung, atau yang akan mulai paling dekat.
  NextClass? nextClass(DateTime now) {
    if (_courses.isEmpty) return null;
    final nowMinutes = now.hour * 60 + now.minute;

    NextClass? best;
    for (final c in _courses) {
      var offset = (c.day - now.weekday) % 7;
      var ongoing = false;

      if (offset == 0) {
        if (nowMinutes >= c.startMinutes && nowMinutes < c.endMinutes) {
          ongoing = true;
        } else if (nowMinutes >= c.endMinutes) {
          offset = 7;
        }
      }

      final minutes =
          ongoing ? 0 : offset * 1440 + c.startMinutes - nowMinutes;
      if (best == null || minutes < best.minutesUntil) {
        best = NextClass(
          course: c,
          dayOffset: offset,
          minutesUntil: minutes,
          ongoing: ongoing,
        );
      }
    }
    return best;
  }

  /// Mengembalikan jadwal lain yang bentrok, atau null kalau aman.
  CourseSchedule? findConflict(CourseSchedule candidate) {
    for (final c in _courses) {
      if (c.id != candidate.id && c.overlapsWith(candidate)) return c;
    }
    return null;
  }

  Future<void> saveProfile(StudentProfile profile) async {
    _profile = profile;
    notifyListeners();
    await _repo.saveProfile(profile);
  }

  Future<void> setPhoto(Uint8List bytes) async {
    _photo = bytes;
    notifyListeners();
    await _repo.savePhoto(bytes);
  }

  Future<void> removePhoto() async {
    _photo = null;
    notifyListeners();
    await _repo.clearPhoto();
  }

  Future<void> upsertCourse(CourseSchedule course) async {
    final i = _courses.indexWhere((c) => c.id == course.id);
    if (i >= 0) {
      _courses[i] = course;
    } else {
      _courses.add(course);
    }
    _sort();
    notifyListeners();
    await _repo.saveCourses(_courses);
  }

  Future<void> deleteCourse(String id) async {
    _courses.removeWhere((c) => c.id == id);
    notifyListeners();
    await _repo.saveCourses(_courses);
  }

  void _sort() {
    _courses.sort((a, b) {
      final byDay = a.day.compareTo(b.day);
      return byDay != 0 ? byDay : a.startMinutes.compareTo(b.startMinutes);
    });
  }
}
