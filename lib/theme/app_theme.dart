import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ── CenturyPly Brand ──────────────────────────────────────────
  static const Color gradientLeft   = Color(0xFFB71C1C); // deep red
  static const Color gradientRight  = Color(0xFFE53935); // bright red
  static const Color companyRed     = Color(0xFFD32F2F); // logo red
  static const Color white          = Color(0xFFFFFFFF);

  // ── Action buttons (match web app) ───────────────────────────
  static const Color btnGreen       = Color(0xFF3D9B3D); // Submit
  static const Color btnBlue        = Color(0xFF1565C0); // View List
  static const Color btnPurple      = Color(0xFF6A1B9A); // Summary
  static const Color btnNavy        = Color(0xFF1A237E); // Pending
  static const Color btnOrange      = Color(0xFFE65100); // User/Admin

  // ── Status chips ─────────────────────────────────────────────
  static const Color statusPending  = Color(0xFFF57C00);
  static const Color statusApproved = Color(0xFF2E7D32);
  static const Color statusRejected = Color(0xFFC62828);

  // ── Neutrals ─────────────────────────────────────────────────
  static const Color cardBg         = Color(0xFFFFFFFF);
  static const Color inputFill      = Color(0xFFF5F5F5);
  static const Color textDark       = Color(0xFF1A1A1A);
  static const Color textGrey       = Color(0xFF757575);
  static const Color divider        = Color(0xFFE0E0E0);
  static const Color pageBg         = Color(0xFFFFF5F5); // very light red tint
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.companyRed,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: AppColors.pageBg,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.companyRed, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.statusRejected, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.statusRejected, width: 1.8),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.companyRed,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      iconTheme: const IconThemeData(color: AppColors.textDark),
    ),
  );
}