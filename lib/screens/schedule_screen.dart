import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/seed_data.dart';
import '../models/course_schedule.dart';
import '../providers/study_provider.dart';
import '../widgets/screen_header.dart';
import '../widgets/weekly_schedule.dart';
import 'schedule_form_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  void _openForm(BuildContext context, {CourseSchedule? course}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ScheduleFormScreen(course: course)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudyProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            const ScreenHeader(
              overline: kSemesterLabel,
              title: 'Jadwal kuliah',
            ),
            if (provider.courses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    'Belum ada jadwal.\nKetuk Tambah untuk mulai.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...buildWeeklySchedule(
                context,
                provider,
                onTapCourse: (c) => _openForm(context, course: c),
              ),
          ],
        ),
      ),
    );
  }
}
