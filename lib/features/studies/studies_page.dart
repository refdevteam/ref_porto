import 'package:flutter/material.dart';

import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/studies/models/study_data.dart';
import 'package:porto/features/studies/views/studies_desktop.dart';
import 'package:porto/features/studies/views/studies_mobile.dart';
import 'package:porto/features/studies/views/studies_tablet.dart';

class StudiesPage extends StatefulWidget {
  const StudiesPage({super.key});

  @override
  State<StudiesPage> createState() => _StudiesPageState();
}

class _StudiesPageState extends State<StudiesPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      compact: (_) => const StudiesMobileScreen(items: studies),
      medium: (_) => const StudiesTabletScreen(items: studies),
      expanded: (_) => const StudiesDesktopScreen(items: studies),
    );
  }
}
