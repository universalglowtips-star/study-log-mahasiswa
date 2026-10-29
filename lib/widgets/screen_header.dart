import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Kepala halaman bergaya majalah: label kecil huruf kapital + judul besar.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.overline,
    required this.title,
    this.trailing,
  });

  final String overline;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(overline.toUpperCase(), style: overlineStyle(context)),
                const SizedBox(height: 6),
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
