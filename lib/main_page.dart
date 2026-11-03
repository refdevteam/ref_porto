import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:porto/components/my_appbar.dart';
import 'package:porto/components/navbar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<NavItem> _items = <NavItem>[
    NavItem(label: 'Home', icon: Icons.home_outlined),
    NavItem(label: 'Studies', icon: Icons.school_outlined),
    NavItem(label: 'Experience', icon: Icons.work_history_outlined),
    NavItem(label: 'Projects', icon: Icons.widgets_outlined),
    NavItem(label: 'Contact', icon: Icons.mail_outline),
  ];

  void _onTap(int index) {
    // Navigasi ke branch yang sesuai (akan mengubah URL otomatis)
    navigationShell.goBranch(
      index,
      // initialLocation true: mengembalikan halaman ke root branch jika sudah ada di tab tersebut
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: MyAppbar(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onItemTap: _onTap,
      ),
      // navigationShell sudah berisi halaman yang sesuai dengan URL saat ini
      body: navigationShell,
      bottomNavigationBar: ResponsiveNavBar(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
