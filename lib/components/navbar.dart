import 'package:flutter/material.dart';

import 'package:porto/core/theme/app_theme.dart';
import 'package:porto/core/utils/responsive_layout.dart';

/// Satu entri menu navigasi.
@immutable
class NavItem {
  const NavItem({required this.label, required this.icon});

  /// Label yang tampil di samping ikon.
  final String label;

  /// Ikon yang tampil sebelum label.
  final IconData icon;
}

/// Navbar berbentuk satu panel kaca berisi deretan item.
///
/// [expanded] menentukan cara item tersebar:
/// - `false` → panel mengikuti lebar isinya (dipakai di dalam AppBar),
/// - `true`  → panel melebar penuh dan item tersebar rata (navbar melayang).
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.expanded = false,
    this.dense = false,
    this.showLabels = true,
  });

  final List<NavItem> items;

  /// Index item yang sedang aktif.
  final int currentIndex;

  /// Dipanggil dengan index item yang ditekan.
  final ValueChanged<int>? onTap;

  /// Lepaskan panel selebar kontainer (untuk navbar melayang).
  final bool expanded;

  /// Versi lebih ramping, dipakai di dalam AppBar yang tingginya cuma 56px.
  final bool dense;

  /// Sembunyikan label, tampilkan ikon saja.
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < items.length; i += 1) {
      // Saat expanded, jarak antar item diatur oleh MainAxisAlignment.
      if (i > 0 && !expanded) {
        children.add(SizedBox(width: dense ? 4 : 6));
      }
      children.add(
        _NavBarPill(
          item: items[i],
          active: i == currentIndex,
          dense: dense,
          showLabels: showLabels,
          onTap: onTap == null ? null : () => onTap!(i),
        ),
      );
    }

    // Satu BackdropFilter untuk seluruh navbar — bukan satu per item,
    // supaya jumlah blur yang harus dirender tetap sedikit.
    return FrostedGlass(
      radius: 999,
      padding: EdgeInsets.symmetric(
        horizontal: expanded ? 6 : (dense ? 5 : 6),
        vertical: dense ? 5 : 6,
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}

/// Satu item navbar berbentuk pil.
///
/// Tidak punya backdrop blur sendiri karena sudah berada di dalam panel
/// kaca milik [NavBar] — blur bertumpuk hanya membuang performa.
class _NavBarPill extends StatelessWidget {
  const _NavBarPill({
    required this.item,
    required this.active,
    required this.dense,
    required this.showLabels,
    this.onTap,
  });

  final NavItem item;
  final bool active;
  final bool dense;
  final bool showLabels;
  final VoidCallback? onTap;

  static final BorderRadius _shape = BorderRadius.circular(999);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);

    final Color foreground = active
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurfaceVariant;

    final Widget pill = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: _shape,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 10 : 14,
            vertical: dense ? 7 : 9,
          ),
          decoration: BoxDecoration(
            color: active ? frost.fillStrong : null,
            borderRadius: _shape,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(item.icon, size: dense ? 17 : 18, color: foreground),
              if (showLabels) ...<Widget>[
                SizedBox(width: dense ? 6 : 8),
                Text(
                  item.label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    // Label disembunyikan kalau ruang sempit, jadi nama menu tetap
    // bisa dibaca saat di-hover.
    if (showLabels) return pill;
    return Tooltip(message: item.label, child: pill);
  }
}

/// Navbar yang melayang di atas konten, dekat sudut bawah layar.
///
/// Dipakai untuk layar sempit; untuk layar lebar pakai [MyAppbar] yang
/// menaruh [NavBar] di dalam app bar.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  /// Lebar maksimum navbar melayang supaya tidak melebar tidak beraturan
  /// di tablet / desktop.
  static const double _maxWidth = 560;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: NavBar(
              items: items,
              currentIndex: currentIndex,
              onTap: onTap,
              expanded: true,
              showLabels: !context.isCompact,
            ),
          ),
        ),
      ),
    );
  }
}

/// Penempatan navbar yang mengikuti lebar layar.
///
/// - Layar lebar (>= [Breakpoints.medium]): tidak menggambar apa pun,
///   karena navbar sudah tampil inline di dalam `MyAppbar`.
/// - Layar sempit: [FloatingNavBar] yang melayang di atas konten.
///
/// Pakai bersama `Scaffold(extendBody: true)` supaya konten ikut menembus
/// ke bawah dan navbar benar-benar terlihat melayang di atasnya.
class ResponsiveNavBar extends StatelessWidget {
  const ResponsiveNavBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    if (context.useInlineNavbar) {
      return const SizedBox.shrink();
    }
    return FloatingNavBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
