import 'package:flutter/material.dart';
import 'package:porto/components/frosted_card.dart';

import 'package:porto/components/navbar.dart';
import 'package:porto/core/theme/app_theme.dart';
import 'package:porto/core/utils/responsive_layout.dart';

/// AppBar berisi ikon dan navbar inline — keduanya ber-efek frosted glass.
///
/// Navbar memakai slot `title` dengan `centerTitle: false`, karena slot
/// `leading` dikunci selebar 56px dan membuat Row-nya overflow.
///
/// - Layar lebar (>= [Breakpoints.medium]): [items] tampil di AppBar.
/// - Layar sempit: navbar pindah ke bawah, slot `title` diisi chip judul.
class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({
    super.key,
    this.items = const <NavItem>[],
    this.title = '',
    this.currentIndex = 0,
    this.onItemTap,
  });

  /// Menu navigasi. Hanya tampil di layar lebar.
  final List<NavItem> items;

  /// Judul section. Kosong → diambil dari [items] sesuai [currentIndex].
  final String title;

  final int currentIndex;
  final ValueChanged<int>? onItemTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool showInlineNav = context.useInlineNavbar && items.isNotEmpty;

    String label = title;
    if (label.isEmpty && currentIndex >= 0 && currentIndex < items.length) {
      label = items[currentIndex].label;
    }

    return AppBar(
      // Wajib di sini: AppBar selalu memakai Clip.hardEdge dan tidak
      // membaca AppBarTheme.clipBehavior, jadi bayangan kaca yang keluar
      // dari area 56px akan kepotong kalau tidak di-set ulang.
      clipBehavior: Clip.none,
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FrostedIconCard(),
        ),
      ),
      title: showInlineNav
          ? NavBar(
              items: items,
              currentIndex: currentIndex,
              onTap: onItemTap,
              dense: true,
              showLabels: context.screenWidth >= Breakpoints.inlineNavbarLabels,
            )
          : (label.isEmpty ? null : _FrostedSectionLabel(label: label)),
      centerTitle: false,
      actions: const <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: _ThemeModeButton(),
        ),
      ],
    );
  }
}

class _FrostedSectionLabel extends StatelessWidget {
  const _FrostedSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return FrostedGlass(
      radius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.1),
      ),
    );
  }
}

/// Tombol pemilih tema di slot `actions` [MyAppbar].
///
/// Ikonnya mengikuti mode aktif (system/dark/light) dan pilihannya
/// dipersistensikan ke SharedPreferences lewat listener di `main.dart`.
class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton();

  static const Map<ThemeMode, (IconData, String)> _modes =
      <ThemeMode, (IconData, String)>{
        ThemeMode.system: (Icons.brightness_auto_outlined, 'Same as system'),
        ThemeMode.dark: (Icons.dark_mode_outlined, 'Dark'),
        ThemeMode.light: (Icons.light_mode_outlined, 'Light'),
      };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (BuildContext context, ThemeMode current, _) {
        final (IconData icon, _) = _modes[current]!;

        return FrostedGlass(
          radius: 999,
          child: Material(
            type: MaterialType.transparency,
            child: PopupMenuButton<ThemeMode>(
              tooltip: 'Theme',
              padding: EdgeInsets.zero,
              elevation: 0,
              borderRadius: BorderRadius.circular(999),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: frost.border, width: frost.borderWidth),
              ),
              color: theme.colorScheme.surfaceContainerHigh,
              onSelected: (ThemeMode mode) => AppTheme.mode.value = mode,
              itemBuilder: (BuildContext context) =>
                  _modes.entries.map((entry) {
                    final bool active = entry.key == current;
                    return PopupMenuItem<ThemeMode>(
                      value: entry.key,
                      child: Row(
                        children: <Widget>[
                          Icon(entry.value.$1, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 112),
                              child: Text(
                                entry.value.$2,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          if (active) ...<Widget>[
                            const SizedBox(width: 12),
                            const Icon(Icons.check, size: 18),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(icon, size: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Kartu ikon ber-efek frosted glass yang dipakai di sisi kiri [MyAppbar].
///
/// Asetnya dipilih otomatis mengikuti tema: mode terang memakai ikon
/// bertinta gelap, mode gelap memakai ikon bertinta terang — supaya ikon
/// selalu kontras di atas latar masing-masing.
