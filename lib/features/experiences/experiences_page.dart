import 'package:flutter/material.dart';

import 'package:porto/core/data/app_data.dart';
import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/experiences/models/experience_data.dart';
import 'package:porto/features/experiences/views/experiences_desktop.dart';
import 'package:porto/features/experiences/views/experiences_mobile.dart';
import 'package:porto/features/experiences/views/experiences_tablet.dart';

class ExperiencesPage extends StatefulWidget {
  const ExperiencesPage({super.key});

  @override
  State<ExperiencesPage> createState() => _ExperiencesPageState();
}

class _ExperiencesPageState extends State<ExperiencesPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ExperienceData>>(
      valueListenable: AppData.instance.experiences,
      builder: (BuildContext context, List<ExperienceData> items, _) {
        return ResponsiveLayout(
          compact: (_) => ExperiencesMobileScreen(items: items),
          medium: (_) => ExperiencesTabletScreen(items: items),
          expanded: (_) => ExperiencesDesktopScreen(items: items),
        );
      },
    );
  }
}
