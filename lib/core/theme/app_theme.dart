import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:porto/core/theme/colors.dart';

/// Lokasi aset yang isinya bergantung pada tema aktif.
///
/// Ikon porto dibuat dua versi karena tint-nya berbeda: versi gelap untuk
/// latar terang, versi putih untuk latar gelap. Ditaruh di satu tempat
/// supaya nama file tidak tersebar di beberapa widget.
abstract final class AppAssets {
  /// Ikon bertinta gelap — dipakai saat mode terang.
  static const String iconOnLight = 'assets/icon-porto-dark.png';

  /// Ikon bertinta terang — dipakai saat mode gelap.
  static const String iconOnDark = 'assets/icon-porto-white.png';
}

@immutable
class FrostedTheme extends ThemeExtension<FrostedTheme> {
  const FrostedTheme({
    required this.fill,
    required this.fillStrong,
    required this.border,
    required this.shadowColor,
    required this.radius,
    required this.sigma,
    required this.borderWidth,
    this.shadowBlur = 14,
    this.shadowOffset = const Offset(0, 4),
  });

  /// Warna dasar kaca (translucent).
  final Color fill;

  /// Warna kaca untuk state aktif / terangkat.
  final Color fillStrong;

  /// Warna border, berfungsi sebagai pantulan cahaya tepi kaca.
  final Color border;

  /// Warna bayangan di bawah kaca.
  final Color shadowColor;

  /// Radius sudut bawaan.
  final double radius;

  /// Kekuatan blur backdrop.
  final double sigma;

  /// Ketebalan border.
  final double borderWidth;

  /// Kekuatan blur bayangan.
  final double shadowBlur;

  /// Pergeseran bayangan.
  final Offset shadowOffset;

  // Light: kaca putih di atas halaman putih, jadi edge-nya harus gelap
  // sedikit supaya tetap terlihat.
  static const FrostedTheme light = FrostedTheme(
    fill: Color(0xA6FFFFFF), // putih 65%
    fillStrong: Color(0x14191918), // #191918 8%  → abu muda khas Notion
    border: Color(0x33191918), // #191918 20%
    shadowColor: Color(0x1F000000), // hitam 12%
    radius: 16,
    sigma: 16,
    borderWidth: 1,
  );

  // Dark: kaca gelap di atas halaman gelap, jadi edge-nya harus terang.
  static const FrostedTheme dark = FrostedTheme(
    fill: Color(0x14FFFFFF), // putih 8%
    fillStrong: Color(0x24FFFFFF), // putih 14%
    border: Color(0x26FFFFFF), // putih 15%
    shadowColor: Color(0x73000000), // hitam 45%
    radius: 16,
    sigma: 16,
    borderWidth: 1,
  );

  /// Ambil token kaca untuk tema yang sedang aktif.
  ///
  /// Jatuh ke [FrostedTheme.light] kalau [ThemeData] belum memasang
  /// extension ini (misalnya widget dites tanpa `AppTheme`).
  static FrostedTheme of(BuildContext context) {
    return Theme.of(context).extension<FrostedTheme>() ?? light;
  }

  @override
  FrostedTheme copyWith({
    Color? fill,
    Color? fillStrong,
    Color? border,
    Color? shadowColor,
    double? radius,
    double? sigma,
    double? borderWidth,
    double? shadowBlur,
    Offset? shadowOffset,
  }) {
    return FrostedTheme(
      fill: fill ?? this.fill,
      fillStrong: fillStrong ?? this.fillStrong,
      border: border ?? this.border,
      shadowColor: shadowColor ?? this.shadowColor,
      radius: radius ?? this.radius,
      sigma: sigma ?? this.sigma,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffset: shadowOffset ?? this.shadowOffset,
    );
  }

  @override
  FrostedTheme lerp(covariant FrostedTheme? other, double t) {
    if (other == null || identical(other, this)) return this;
    return FrostedTheme(
      fill: Color.lerp(fill, other.fill, t)!,
      fillStrong: Color.lerp(fillStrong, other.fillStrong, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      radius: radius + (other.radius - radius) * t,
      sigma: sigma + (other.sigma - sigma) * t,
      borderWidth: borderWidth + (other.borderWidth - borderWidth) * t,
      shadowBlur: shadowBlur + (other.shadowBlur - shadowBlur) * t,
      shadowOffset: Offset.lerp(shadowOffset, other.shadowOffset, t)!,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Permukaan kaca
// ─────────────────────────────────────────────────────────────────────

/// Efek frosted glass (kaca buram): backdrop blur + warna translucent +
/// border tipis sebagai pantulan cahaya tepi.
///
/// Semua warna & blur diambil dari [FrostedTheme] supaya otomatis ikut
/// tema light / dark. Override lewat [radius], [sigma], [fill] atau
/// [border] kalau satu kasus butuh tampilan berbeda.
///
/// Bungkus widget apa pun dengan [child] untuk memberi efek ini: ikon,
/// teks, tombol, kartu, navbar, dan seterusnya.
class FrostedGlass extends StatelessWidget {
  const FrostedGlass({
    super.key,
    required this.child,
    this.radius,
    this.sigma,
    this.padding = EdgeInsets.zero,
    this.fill,
    this.border,
    this.shadow = true,
  });

  /// Isi di dalam kaca.
  final Widget child;

  /// Sudut membulat. `null` = pakai nilai dari [FrostedTheme].
  final double? radius;

  /// Kekuatan blur. `null` = pakai nilai dari [FrostedTheme].
  final double? sigma;

  /// Jarak isi ke tepi kaca.
  final EdgeInsetsGeometry padding;

  /// Warna kaca. `null` = pakai nilai dari [FrostedTheme].
  final Color? fill;

  /// Warna border. `null` = pakai nilai dari [FrostedTheme].
  final Color? border;

  /// Tampilkan bayangan di bawah kaca.
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final FrostedTheme frost = FrostedTheme.of(context);
    final double r = radius ?? frost.radius;
    final double s = sigma ?? frost.sigma;

    return DecoratedBox(
      // Bayangan ditaruh di luar ClipRRect supaya tidak ikut terpotong.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        boxShadow: shadow
            ? <BoxShadow>[
                BoxShadow(
                  color: frost.shadowColor,
                  blurRadius: frost.shadowBlur,
                  offset: frost.shadowOffset,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: s, sigmaY: s),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fill ?? frost.fill,
              borderRadius: BorderRadius.circular(r),
              border: Border.all(
                color: border ?? frost.border,
                width: frost.borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Theme
// ─────────────────────────────────────────────────────────────────────

/// Tema aplikasi: netral hitam-putih gaya Notion dengan seluruh komponen
/// yang siap tampil frosted glass.
abstract final class AppTheme {
  /// Mode tema aktif; diubah oleh tombol di AppBar dan dipersistensikan
  /// ke SharedPreferences lewat listener di `main.dart`.
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final Color background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final Color surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final Color textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final Color textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final Color textTertiary = isDark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
    final Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final FrostedTheme frost = isDark ? FrostedTheme.dark : FrostedTheme.light;

    // Seed netral (bukan biru) supaya seluruh palette tetap abu-abu.
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(
          seedColor: textPrimary,
          brightness: brightness,
        ).copyWith(
          primary: textPrimary,
          onPrimary: background,
          secondary: textSecondary,
          onSecondary: background,
          surface: background,
          onSurface: textPrimary,
          onSurfaceVariant: textSecondary,
          outline: border,
          outlineVariant: border,
          surfaceContainerHighest: surface,
          surfaceContainerHigh: surface,
          surfaceContainerLow: surface,
        );

    final TextTheme textTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        height: 1.1,
        letterSpacing: -1.4,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        height: 1.2,
        letterSpacing: -0.6,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.3,
        letterSpacing: -0.2,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.7, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, height: 1.7, color: textSecondary),
      bodySmall: TextStyle(fontSize: 12, height: 1.6, color: textTertiary),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: textTertiary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[frost],
      // AppBar transparan supaya konten di belakangnya ter-blur oleh
      // BackdropFilter. clipBehavior tidak bisa diatur dari sini (lihat
      // catatan di MyAppbar), jadi tetap diset per-widget.
      appBarTheme: AppBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium,
        iconTheme: IconThemeData(color: textPrimary, size: 20),
        // Ikon status bar harus kontras dengan latar.
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      // Kartu sudah berwajah kaca: isi transparan + border, tinggal
      // dibungkus FrostedGlass kalau blur-nya ikut dibutuhkan.
      cardTheme: CardThemeData(
        color: frost.fill,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(frost.radius),
          side: BorderSide(color: frost.border, width: frost.borderWidth),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: frost.fill,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: frost.border, width: frost.borderWidth),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: frost.fill,
          foregroundColor: textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          // Seragam dengan seluruh permukaan kaca lain.
          side: BorderSide(color: frost.border, width: frost.borderWidth),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: frost.fillStrong,
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      // Untuk komponen yang butuh garis tapi tidak memakai Divider.
      listTileTheme: ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
