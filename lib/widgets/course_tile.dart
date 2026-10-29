import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../models/course_schedule.dart';

/// Satu baris mata kuliah: jam di kiri, detail di kanan, tanpa kotak kartu.
class CourseTile extends StatelessWidget {
  const CourseTile({super.key, required this.course, this.onTap});

  final CourseSchedule course;
  final VoidCallback? onTap;

  Color _tagColor(ColorScheme s) {
    final seed = course.code.isNotEmpty ? course.code : course.name;
    final sum = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    final palette = [s.secondary, s.primary, s.tertiary, s.onSurfaceVariant];
    return palette[sum % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final t = theme.textTheme;
    final muted = t.bodyMedium?.copyWith(color: s.onSurfaceVariant);

    final meta = [
      if (course.code.isNotEmpty) course.code,
      if (course.sks > 0) '${course.sks} SKS',
      if (course.className.isNotEmpty) course.className,
    ].join(' · ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: _tagColor(s),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 46,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatMinutes(course.startMinutes),
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      formatMinutes(course.endMinutes),
                      style: t.bodySmall?.copyWith(
                        color: s.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name, style: t.titleMedium),
                    if (course.room.isNotEmpty || course.lecturer.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              if (course.room.isNotEmpty)
                                TextSpan(
                                  text: course.room,
                                  style: TextStyle(
                                    color: s.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (course.room.isNotEmpty &&
                                  course.lecturer.isNotEmpty)
                                const TextSpan(text: '  ·  '),
                              if (course.lecturer.isNotEmpty)
                                TextSpan(text: course.lecturer),
                            ],
                          ),
                          style: muted,
                        ),
                      ),
                    if (meta.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          meta,
                          style: t.labelMedium?.copyWith(
                            color: s.onSurfaceVariant,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
