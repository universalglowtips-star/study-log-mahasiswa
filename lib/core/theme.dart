import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Palet: kertas hangat + tinta + hijau hutan, dengan SATU aksen vermilion
// yang dipakai hemat (hari ini, jadwal berikutnya, tombol utama FAB).
const _light = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1F4D3A),
  onPrimary: Color(0xFFF5F0E6),
  primaryContainer: Color(0xFFD5E3D8),
  onPrimaryContainer: Color(0xFF12301F),
  secondary: Color(0xFFC73D17),
  onSecondary: Color(0xFFFFF7F0),
  secondaryContainer: Color(0xFFF6D9CC),
  onSecondaryContainer: Color(0xFF5A1A08),
  tertiary: Color(0xFFA9741A),
  onTertiary: Color(0xFFFFF8EA),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFFF5F0E6),
  onSurface: Color(0xFF1C1B17),
  surfaceContainerLowest: Color(0xFFFBF8F2),
  surfaceContainerLow: Color(0xFFF1EBDF),
  surfaceContainer: Color(0xFFECE5D6),
  surfaceContainerHigh: Color(0xFFE5DDCB),
  surfaceContainerHighest: Color(0xFFDDD4C0),
  onSurfaceVariant: Color(0xFF6B665A),
  outline: Color(0xFF9A9484),
  outlineVariant: Color(0xFFD6CEBD),
);

const _dark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF9CCFB3),
  onPrimary: Color(0xFF0F2A1E),
  primaryContainer: Color(0xFF24493A),
  onPrimaryContainer: Color(0xFFD5E3D8),
  secondary: Color(0xFFFF7A52),
  onSecondary: Color(0xFF3A0E02),
  secondaryContainer: Color(0xFF5A1A08),
  onSecondaryContainer: Color(0xFFF6D9CC),
  tertiary: Color(0xFFE8B04A),
  onTertiary: Color(0xFF2E1F00),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  surface: Color(0xFF14130F),
  onSurface: Color(0xFFEDE7DA),
  surfaceContainerLowest: Color(0xFF0F0E0B),
  surfaceContainerLow: Color(0xFF191813),
  surfaceContainer: Color(0xFF1F1E18),
  surfaceContainerHigh: Color(0xFF282720),
  surfaceContainerHighest: Color(0xFF32302A),
  onSurfaceVariant: Color(0xFF9E988A),
  outline: Color(0xFF6B665A),
  outlineVariant: Color(0xFF3A382F),
);

/// Bricolage Grotesque untuk judul (karakter, tidak generik),
/// Instrument Sans untuk teks biasa (rapi dan mudah dibaca di layar kecil).
TextTheme _buildTextTheme(ColorScheme s) {
  final base = ThemeData(brightness: s.brightness).textTheme;
  final body = GoogleFonts.instrumentSansTextTheme(base).apply(
    bodyColor: s.onSurface,
    displayColor: s.onSurface,
  );

  TextStyle head(
    TextStyle? style, {
    FontWeight weight = FontWeight.w700,
    double spacing = -0.4,
  }) {
    return GoogleFonts.bricolageGrotesque(
      textStyle: style,
      fontWeight: weight,
      letterSpacing: spacing,
    );
  }

  return body.copyWith(
    headlineLarge: head(body.headlineLarge, spacing: -1.2),
    headlineMedium: head(body.headlineMedium, spacing: -0.9),
    headlineSmall: head(body.headlineSmall, spacing: -0.5),
    titleLarge: head(body.titleLarge, spacing: -0.4),
    titleMedium: head(body.titleMedium, weight: FontWeight.w600, spacing: -0.2),
  );
}

/// Gaya label kecil huruf kapital berjarak, dipakai untuk "overline".
TextStyle overlineStyle(BuildContext context, {Color? color}) {
  final theme = Theme.of(context);
  return theme.textTheme.labelSmall!.copyWith(
    color: color ?? theme.colorScheme.onSurfaceVariant,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.3,
  );
}

ThemeData buildTheme(Brightness brightness) {
  final s = brightness == Brightness.light ? _light : _dark;
  final text = _buildTextTheme(s);

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: s,
    scaffoldBackgroundColor: s.surface,
    textTheme: text,
    splashFactory: InkRipple.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: s.surface,
      foregroundColor: s.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge,
    ),
    dividerTheme: DividerThemeData(
      color: s.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: s.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: s.primary, width: 1.6),
      ),
      errorBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: s.error, width: 1.2),
      ),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: s.error, width: 1.6),
      ),
      labelStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: s.primary,
        foregroundColor: s.onPrimary,
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: s.onSurface,
        minimumSize: const Size(64, 52),
        side: BorderSide(color: s.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: s.onSurface),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: s.secondary,
      foregroundColor: s.onSecondary,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: s.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 68,
      indicatorColor: s.secondary.withValues(alpha: 0.16),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return text.labelMedium?.copyWith(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? s.onSurface : s.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? s.onSurface : s.onSurfaceVariant,
        );
      }),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: s.onSurface,
      contentTextStyle: text.bodyMedium?.copyWith(color: s.surface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
