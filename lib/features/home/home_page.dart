import 'package:flutter/material.dart';

import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/home/views/home_desktop.dart';
import 'package:porto/features/home/views/home_mobile.dart';
import 'package:porto/features/home/views/home_tablet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      compact: (_) => const HomeMobileScreen(),
      medium: (_) => const HomeTabletScreen(),
      expanded: (_) => const HomeDesktopScreen(),
    );
  }
}
