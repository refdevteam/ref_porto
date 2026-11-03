import 'package:flutter/material.dart';

/// Breakpoint tata letak, mengikuti Material 3 window size class.
abstract final class Breakpoints {
  /// Di bawah ini: ponsel.
  static const double compact = 600;

  /// Rentang 600–840: tablet. Di atas ini: layar lebar (PC / laptop).
  static const double medium = 840;

  /// Lebar minimum agar label navbar masih muat di dalam AppBar tanpa
  /// menabrak judul.
  ///
  /// Di rentang [medium]–[inlineNavbarLabels] navbar tampil ikon saja
  /// (dengan tooltip), supaya judul tetap terpusat dan tidak terdorong
  /// oleh `NavigationToolbar`.
  static const double inlineNavbarLabels = 1100;

  /// Layar sangat lebar.
  static const double expanded = 1200;
}

/// Klasifikasi lebar layar, dari yang paling sempit.
enum WindowClass { compact, medium, expanded }

/// Akses cepat ke ukuran layar dari `context`.
extension ResponsiveContext on BuildContext {
  /// Lebar layar saat ini.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Tinggi layar saat ini.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  WindowClass get windowClass {
    final double width = screenWidth;
    if (width < Breakpoints.compact) return WindowClass.compact;
    if (width < Breakpoints.medium) return WindowClass.medium;
    return WindowClass.expanded;
  }

  bool get isCompact => windowClass == WindowClass.compact;
  bool get isMedium => windowClass == WindowClass.medium;
  bool get isExpanded => windowClass == WindowClass.expanded;

  /// `true`  → navbar ditampilkan inline di dalam AppBar (layar lebar).
  /// `false` → navbar melayang di bawah layar (layar sempit).
  ///
  /// Ini satu-satunya sumber keputusan penempatan navbar, supaya
  /// `MyAppbar` dan `ResponsiveNavBar` tidak pernah berbeda pendapat.
  bool get useInlineNavbar => screenWidth >= Breakpoints.medium;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// Widget yang memilih builder berdasarkan lebar layar.
///
/// ```dart
/// ResponsiveLayout(
///   compact: (context) => const HomeMobile(),
///   medium: (context) => const HomeTablet(),
///   expanded: (context) => const HomeDesktop(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.compact,
    required this.medium,
    required this.expanded,
  });

  /// Dibangun untuk lebar < [Breakpoints.compact] (ponsel).
  final WidgetBuilder compact;

  /// Dibangun untuk rentang [Breakpoints.compact]–[Breakpoints.medium].
  final WidgetBuilder medium;

  /// Dibangun untuk lebar >= [Breakpoints.medium].
  final WidgetBuilder expanded;

  @override
  Widget build(BuildContext context) {
    final Widget layout = switch (context.windowClass) {
      WindowClass.compact => compact(context),
      WindowClass.medium => medium(context),
      WindowClass.expanded => expanded(context),
    };

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      switchInCurve: Curves.ease,
      switchOutCurve: Curves.easeInOut,
      // Layout default AnimatedSwitcher memakai Stack(alignment: center):
      // halaman yang lebih pendek dari viewport (SingleChildScrollView
      // shrink-wrap) ikut ditengahkan. Dipaksa rata ke start.
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[...previousChildren, ?currentChild],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },

      child: KeyedSubtree(key: ValueKey(context.windowClass), child: layout),
    );
  }
}
