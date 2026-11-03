import 'package:flutter/material.dart';

/// Palet netral gaya Notion: hitam dan putih untuk light & dark mode.
///
/// Ini warna *mentah* yang hanya dipakai untuk membangun [ThemeData] di
/// `AppTheme`. Widget jangan membaca [AppColors] secara langsung — ambil
/// warna aktif lewat [ThemeData.colorScheme] / [ThemeData.textTheme], dan
/// token kaca lewat `FrostedTheme.of(context)`.
abstract final class AppColors {
  // ───────────────────────────── Light ─────────────────────────────

  /// Latar halaman.
  static const Color lightBackground = Color(0xFFFFFFFF);

  /// Permukaan sekunder (panel, kartu, sidebar).
  static const Color lightSurface = Color(0xFFF7F7F5);

  /// Permukaan saat hover / state terangkat.
  static const Color lightSurfaceAlt = Color(0xFFEFEFEE);

  /// Teks utama. Hitam lembut, bukan `#000000`.
  static const Color lightTextPrimary = Color(0xFF191918);

  /// Teks sekunder (paragraf pendukung, deskripsi).
  static const Color lightTextSecondary = Color(0xFF787774);

  /// Teks tersier (caption, hint, metadata).
  static const Color lightTextTertiary = Color(0xFF9B9A97);

  /// Garis pemisah tipis.
  static const Color lightBorder = Color(0xFFE3E2E0);

  /// Garis pemisah yang lebih tegas.
  static const Color lightBorderStrong = Color(0xFFD9D9D6);

  // ───────────────────────────── Dark ──────────────────────────────

  /// Latar halaman.
  static const Color darkBackground = Color(0xFF191919);

  /// Permukaan sekunder (panel, kartu, sidebar).
  static const Color darkSurface = Color(0xFF202020);

  /// Permukaan saat hover / state terangkat.
  static const Color darkSurfaceAlt = Color(0xFF2A2A2A);

  /// Teks utama. Putih hangat, bukan `#FFFFFF`.
  static const Color darkTextPrimary = Color(0xFFF1F1EF);

  /// Teks sekunder.
  static const Color darkTextSecondary = Color(0xFF9B9A97);

  /// Teks tersier.
  static const Color darkTextTertiary = Color(0xFF6E6D6A);

  /// Garis pemisah tipis.
  static const Color darkBorder = Color(0xFF373737);

  /// Garis pemisah yang lebih tegas.
  static const Color darkBorderStrong = Color(0xFF484745);
}
