import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../providers/study_provider.dart';

/// Menyorot kelas yang sedang berlangsung atau paling dekat.
class NextClassCard extends StatelessWidget {
  const NextClassCard({super.key, required this.next});

  final NextClass next;

  String _label() {
    final c = next.course;
    final start = formatMinutes(c.startMinutes);
    if (next.ongoing) return 'Sedang berlangsung';
    if (next.dayOffset == 0) {
      final m = next.minutesUntil;
      return m < 60 ? 'Mulai $m menit lagi' : 'Hari ini · $start';
    }
    if (next.dayOffset == 1) return 'Besok · $start';
    return '${dayName(c.day)} · $start';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final c = next.course;
    final place = [c.room, c.lecturer].where((e) => e.isNotEmpty).join(' · ');

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: s.surfaceContainer,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: s.secondary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELANJUTNYA · ${_label()}'.toUpperCase(),
                        style: overlineStyle(context, color: s.secondary),
                      ),
                      const SizedBox(height: 8),
                      Text(c.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(
                        '${formatMinutes(c.startMinutes)}–'
                        '${formatMinutes(c.endMinutes)}'
                        '${place.isEmpty ? '' : '  ·  $place'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: s.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
