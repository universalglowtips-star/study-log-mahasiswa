import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/student_profile.dart';
import 'profile_avatar.dart';

/// Kartu mahasiswa: foto, nama, NIM, jurusan, kampus, kelas, semester.
class StudentIdCard extends StatelessWidget {
  const StudentIdCard({super.key, required this.profile, this.photo});

  final StudentProfile profile;
  final Uint8List? photo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final t = theme.textTheme;
    final fg = s.onPrimary;
    final dim = fg.withValues(alpha: 0.62);

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        color: s.primary,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _ArcsPainter(fg.withValues(alpha: 0.08)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'KARTU MAHASISWA',
                        style: overlineStyle(context, color: dim),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: s.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'SMT ${profile.semester}',
                          style: overlineStyle(context, color: s.onSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ProfileAvatar(
                        name: profile.name,
                        photo: photo,
                        size: 84,
                        backgroundColor: fg.withValues(alpha: 0.14),
                        foregroundColor: fg,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: t.titleLarge?.copyWith(
                                color: fg,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              profile.nim,
                              style: t.bodyLarge?.copyWith(
                                color: dim,
                                letterSpacing: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: fg.withValues(alpha: 0.18)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 28,
                    runSpacing: 14,
                    children: [
                      _Field(label: 'Jurusan', value: profile.major),
                      _Field(label: 'Kampus', value: profile.campus),
                      _Field(label: 'Kelas', value: profile.className),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: overlineStyle(context, color: fg.withValues(alpha: 0.55)),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ArcsPainter extends CustomPainter {
  _ArcsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width, 0);
    for (var r = 60.0; r <= 220; r += 40) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArcsPainter oldDelegate) =>
      oldDelegate.color != color;
}
