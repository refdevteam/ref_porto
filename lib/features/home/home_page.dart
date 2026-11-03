import 'package:flutter/material.dart';

import 'package:porto/core/data/app_data.dart';
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
    return ValueListenableBuilder<String>(
      valueListenable: AppData.instance.bio,
      builder: (BuildContext context, String bio, _) {
        return ResponsiveLayout(
          compact: (_) => HomeMobileScreen(description: bio),
          medium: (_) => HomeTabletScreen(description: bio),
          expanded: (_) => HomeDesktopScreen(description: bio),
        );
      },
    );
  }
}
