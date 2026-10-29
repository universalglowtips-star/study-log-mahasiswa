import 'dart:typed_data';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/study_provider.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/screen_header.dart';
import 'profile_form_screen.dart';

enum _PhotoAction { gallery, camera, remove }

/// Batas ukuran foto yang disimpan (setelah dikecilkan oleh image_picker).
const _maxPhotoBytes = 2 * 1024 * 1024;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _openForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
    );
  }

  Future<void> _changePhoto(BuildContext context) async {
    final provider = context.read<StudyProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final hasPhoto = provider.photoBytes != null;
    final canUseCamera = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    final action = await showModalBottomSheet<_PhotoAction>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari galeri'),
              onTap: () => Navigator.pop(ctx, _PhotoAction.gallery),
            ),
            if (canUseCamera)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Ambil foto'),
                onTap: () => Navigator.pop(ctx, _PhotoAction.camera),
              ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Hapus foto'),
                onTap: () => Navigator.pop(ctx, _PhotoAction.remove),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null) return;

    if (action == _PhotoAction.remove) {
      await provider.removePhoto();
      return;
    }

    try {
      final picked = await ImagePicker().pickImage(
        source: action == _PhotoAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (bytes.length > _maxPhotoBytes) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Foto terlalu besar (maksimal 2 MB).')),
        );
        return;
      }
      await provider.setPhoto(bytes);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Foto gagal dimuat. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudyProvider>();
    final profile = provider.profile;
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final t = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            ScreenHeader(
              overline: 'Akun',
              title: 'Profil',
              trailing: profile == null
                  ? null
                  : IconButton.filledTonal(
                      tooltip: 'Edit data',
                      onPressed: () => _openForm(context),
                      icon: const Icon(Icons.edit_outlined),
                    ),
            ),
            Center(
              child: _PhotoButton(
                name: profile?.name ?? '',
                photo: provider.photoBytes,
                onTap: () => _changePhoto(context),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Ketuk foto untuk mengganti',
                style: t.bodySmall?.copyWith(color: s.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 24),
            if (profile == null) ...[
              Center(
                child: Text(
                  'Belum ada data mahasiswa.',
                  style: t.bodyMedium?.copyWith(color: s.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _openForm(context),
                child: const Text('Isi data mahasiswa'),
              ),
            ] else ...[
              _InfoRow(label: 'Nama', value: profile.name),
              _InfoRow(label: 'NIM', value: profile.nim),
              _InfoRow(label: 'Jurusan', value: profile.major),
              _InfoRow(label: 'Kampus', value: profile.campus),
              _InfoRow(label: 'Kelas', value: profile.className),
              _InfoRow(label: 'Semester', value: '${profile.semester}'),
            ],
          ],
        ),
      ),
    );
  }
}

class _PhotoButton extends StatelessWidget {
  const _PhotoButton({
    required this.name,
    required this.photo,
    required this.onTap,
  });

  final String name;
  final Uint8List? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: 'Ubah foto profil',
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ProfileAvatar(name: name, photo: photo, size: 112),
            Positioned(
              right: -6,
              bottom: -6,
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: s.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: s.surface, width: 3),
                ),
                child: Icon(
                  Icons.photo_camera_outlined,
                  size: 18,
                  color: s.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    label.toUpperCase(),
                    style: overlineStyle(context),
                  ),
                ),
              ),
              Expanded(
                child: Text(value, style: theme.textTheme.bodyLarge),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
