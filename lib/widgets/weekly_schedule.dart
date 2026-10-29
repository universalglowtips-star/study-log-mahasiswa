import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../models/course_schedule.dart';
import '../providers/study_provider.dart';
import 'course_tile.dart';

/// Jadwal satu minggu bergaya timetable: kolom kiri hari + tanggal,
/// kolom kanan daftar mata kuliah dipisah garis tipis.
/// Hari ini diberi warna aksen. Kalau [onTapCourse] null, baris tidak bisa diketuk.
List<Widget> buildWeeklySchedule(
  BuildContext context,
  StudyProvider provider, {
  void Function(CourseSchedule course)? onTapCourse,
}) {
  final theme = Theme.of(context);
  final s = theme.colorScheme;
  final now = DateTime.now();
  final widgets = <Widget>[];

  for (var day = 1; day <= 7; day++) {
    final items = provider.coursesOn(day);
    if (items.isEmpty) continue;

    final isToday = day == now.weekday;
    final date = now.add(Duration(days: day - now.weekday));
    final accent = isToday ? s.secondary : s.onSurfaceVariant;

    widgets.add(const SizedBox(height: 20));
    widgets.add(Divider(color: s.outline.withValues(alpha: 0.5)));
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 58,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortDayName(day),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isToday ? s.secondary : s.onSurface,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      '${date.day}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const Divider(),
                    CourseTile(
                      course: items[i],
                      onTap: onTapCourse == null
                          ? null
                          : () => onTapCourse(items[i]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  return widgets;
}
