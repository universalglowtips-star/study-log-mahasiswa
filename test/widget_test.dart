import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_log/app.dart';
import 'package:study_log/data/study_repository.dart';
import 'package:study_log/models/course_schedule.dart';
import 'package:study_log/providers/study_provider.dart';

Future<StudyProvider> _makeProvider() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return StudyProvider(StudyRepository(prefs))..load();
}

void main() {
  // Di test tidak ada internet; cegah google_fonts mencoba mengunduh font.
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('beranda menampilkan ajakan isi data diri saat profil kosong',
      (tester) async {
    final provider = await _makeProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: provider, child: const StudyLogApp()),
    );

    expect(find.text('Study LOG'), findsOneWidget);
    expect(find.text('Isi data diri'), findsOneWidget);
  });

  test('jadwal awal terisi saat app pertama kali dibuka', () async {
    final provider = await _makeProvider();

    expect(provider.courses, isNotEmpty);
    expect(provider.coursesOn(DateTime.monday).first.code, '111500');
  });

  test('nextClass memilih kelas yang sedang berlangsung dan yang berikutnya',
      () async {
    final provider = await _makeProvider();

    // Senin 2026-10-26 pukul 19:30 -> SMBD (19:00-20:30) sedang berlangsung.
    final during = provider.nextClass(DateTime(2026, 10, 26, 19, 30))!;
    expect(during.course.code, '111500');
    expect(during.ongoing, isTrue);

    // Senin 10:00 -> SMBD dimulai hari ini.
    final before = provider.nextClass(DateTime(2026, 10, 26, 10, 0))!;
    expect(before.course.code, '111500');
    expect(before.dayOffset, 0);
    expect(before.ongoing, isFalse);

    // Senin 21:00 -> kelas berikutnya Selasa 19:00 (Penalaran Komputer).
    final after = provider.nextClass(DateTime(2026, 10, 26, 21, 0))!;
    expect(after.course.code, '111100');
    expect(after.dayOffset, 1);
  });

  test('foto profil bisa disimpan dan dihapus', () async {
    final provider = await _makeProvider();
    expect(provider.photoBytes, isNull);

    await provider.setPhoto(Uint8List.fromList([1, 2, 3]));
    expect(provider.photoBytes, isNotNull);

    // Provider baru dengan prefs yang sama harus memuat foto yang tersimpan.
    final prefs = await SharedPreferences.getInstance();
    final reloaded = StudyProvider(StudyRepository(prefs))..load();
    expect(reloaded.photoBytes, [1, 2, 3]);

    await provider.removePhoto();
    expect(provider.photoBytes, isNull);
  });

  test('findConflict mendeteksi jadwal yang bertabrakan', () async {
    final provider = await _makeProvider();
    const a = CourseSchedule(
      id: 'a',
      name: 'Pemrograman Mobile',
      lecturer: '',
      room: '',
      day: 1,
      startMinutes: 480,
      endMinutes: 580,
    );
    await provider.upsertCourse(a);

    const overlap = CourseSchedule(
      id: 'b',
      name: 'Basis Data',
      lecturer: '',
      room: '',
      day: 1,
      startMinutes: 540,
      endMinutes: 640,
    );
    const otherDay = CourseSchedule(
      id: 'c',
      name: 'Basis Data',
      lecturer: '',
      room: '',
      day: 3,
      startMinutes: 540,
      endMinutes: 640,
    );

    expect(provider.findConflict(overlap)?.id, 'a');
    expect(provider.findConflict(otherDay), isNull);
  });
}
