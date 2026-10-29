import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../core/seed_data.dart';
import '../providers/study_provider.dart';
import '../widgets/next_class_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/student_id_card.dart';
import '../widgets/weekly_schedule.dart';
import 'profile_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudyProvider>();
    final profile = provider.profile;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final next = provider.nextClass(now);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            ScreenHeader(overline: formatDateLong(now), title: 'Study LOG'),
            if (profile == null)
              const _WelcomeCard()
            else
              StudentIdCard(profile: profile, photo: provider.photoBytes),
            if (next != null) ...[
              const SizedBox(height: 14),
              NextClassCard(next: next),
            ],
            const SizedBox(height: 32),
            Text('Jadwal minggu ini', style: theme.textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(
              kSemesterLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (provider.courses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('Belum ada jadwal. Tambahkan di tab Jadwal.'),
                ),
              )
            else
              ...buildWeeklySchedule(context, provider),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mulai dari kartu mahasiswamu', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Isi nama, NIM, jurusan, kampus, dan kelas. Datanya tampil di '
            'sini sebagai kartu.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
            ),
            child: const Text('Isi data diri'),
          ),
        ],
      ),
    );
  }
}
