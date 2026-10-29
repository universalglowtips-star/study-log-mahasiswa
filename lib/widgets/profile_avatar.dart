import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/formatters.dart';

/// Foto profil berbentuk kotak membulat. Tanpa foto, tampil inisial nama.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    this.photo,
    this.size = 72,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String name;
  final Uint8List? photo;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fg = foregroundColor ?? theme.colorScheme.onSurface;

    final Widget content;
    if (photo != null) {
      content = Image.memory(
        photo!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        width: size,
        height: size,
      );
    } else {
      content = ColoredBox(
        color: bg,
        child: Center(
          child: name.trim().isEmpty
              ? Icon(Icons.person_outline, size: size * 0.45, color: fg)
              : Text(
                  initialsOf(name),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: fg,
                    fontSize: size * 0.34,
                  ),
                ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.3),
      child: SizedBox(width: size, height: size, child: content),
    );
  }
}
