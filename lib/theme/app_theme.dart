import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF00E676);
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color cardBg = Color(0xFF1E1E1E);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color accentGreen = Color(0xFF00C853);
  static const Color error = Color(0xFFCF6679);
  static const Color grey = Color(0xFF2C2C2C);
}

// Theme-adaptive color helper — dark mode returns identical values to before
class AppAdaptive {
  static bool isDark(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark;

  static Color surface(BuildContext ctx) =>
      isDark(ctx) ? AppColors.surface : const Color(0xFFF0F9F2);

  static Color cardBg(BuildContext ctx) =>
      isDark(ctx) ? AppColors.cardBg : Colors.white;

  static Color textSecondary(BuildContext ctx) =>
      isDark(ctx) ? Colors.white60 : Colors.black54;

  static Color textHint(BuildContext ctx) =>
      isDark(ctx) ? Colors.white38 : Colors.black45;

  static Color textMuted(BuildContext ctx) =>
      isDark(ctx) ? Colors.white24 : Colors.black38;

  static Color textVeryMuted(BuildContext ctx) =>
      isDark(ctx) ? Colors.white12 : Colors.black12;

  static Color divider(BuildContext ctx) =>
      isDark(ctx) ? Colors.white10 : const Color(0xFFD0D7E2);

  static Color border(BuildContext ctx) =>
      isDark(ctx) ? Colors.white24 : const Color(0xFFCDD3DC);

  static Color iconMuted(BuildContext ctx) =>
      isDark(ctx) ? Colors.white70 : const Color(0xFF455A64);

  static Color overlay(BuildContext ctx) =>
      isDark(ctx) ? Colors.black54 : AppColors.primary.withAlpha(30);

  static Color navBg(BuildContext ctx) =>
      isDark(ctx) ? AppColors.background : Colors.white;

  static Color navUnselected(BuildContext ctx) =>
      isDark(ctx) ? Colors.white38 : const Color(0xFF78909C);

  static Color bannerEnd(BuildContext ctx) =>
      isDark(ctx) ? Colors.black : const Color(0xFFE8F5E9);

  static Color bannerGradientStart(BuildContext ctx) =>
      isDark(ctx) ? AppColors.primary.withAlpha(51) : const Color(0xFF1A7A3C);

  static Color bannerGradientEnd(BuildContext ctx) =>
      isDark(ctx) ? Colors.black : const Color(0xFF0D4820);

  static Color bannerBorderColor(BuildContext ctx) =>
      isDark(ctx) ? AppColors.primary.withAlpha(77) : const Color(0xFF0A2912);

  static Color bannerPillBg(BuildContext ctx) =>
      isDark(ctx) ? Colors.black54 : const Color(0xFF0A2912);

  static Color bannerPillFg(BuildContext ctx) =>
      isDark(ctx) ? AppColors.primary : Colors.white;

  static Color bannerTitleColor(BuildContext ctx) => Colors.white;

  static Color tagBg(BuildContext ctx) =>
      isDark(ctx) ? AppColors.surface : const Color(0xFFE8F5E9);

  static Color tagText(BuildContext ctx) =>
      isDark(ctx) ? Colors.white60 : const Color(0xFF1A6B35);

  static Color primaryAdaptive(BuildContext ctx) =>
      isDark(ctx) ? AppColors.primary : const Color(0xFF00C853);

  static Color viewDetailsActiveBg(BuildContext ctx) =>
      isDark(ctx) ? Colors.transparent : AppColors.primary;

  static Color viewDetailsActiveText(BuildContext ctx) =>
      isDark(ctx) ? AppColors.primary : Colors.white;

  static BorderSide viewDetailsActiveSide(BuildContext ctx) =>
      isDark(ctx) ? const BorderSide(color: AppColors.primary) : BorderSide.none;

  static Color liveMatchBg(BuildContext ctx) =>
      isDark(ctx) ? const Color(0xFF2A1515) : const Color(0xFFFFEBEE);

  static Color liveMatchBorder(BuildContext ctx) =>
      isDark(ctx) ? const Color(0x33FF0000) : const Color(0x44FF0000);

  static Color joinButtonBg(BuildContext ctx) =>
      isDark(ctx) ? const Color(0xFF3D2121) : const Color(0xFFFFCDD2);

  static Color outlinedBorder(BuildContext ctx) =>
      isDark(ctx) ? AppColors.grey : Colors.black26;

  static Color chipUnselected(BuildContext ctx) =>
      isDark(ctx) ? AppColors.surface : const Color(0xFFEEEEEE);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.cardBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        displayMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1)),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFF4F6F4),
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: Color(0xFFE8ECF1),
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        actionsIconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.2),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withAlpha(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        displayMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        headlineSmall: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        hintStyle: const TextStyle(color: Colors.black38),
        labelStyle: const TextStyle(color: Colors.black54),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE4E8EE),
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF78909C),
        elevation: 8,
      ),
      dividerColor: const Color(0xFFD0D7E2),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : Colors.white),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary.withAlpha(76) : const Color(0xFFE0E0E0)),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
