import 'package:flutter/material.dart';

import 'package:porto/core/data/app_data.dart';
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
    return ValueListenableBuilder<List<StudyData>>(
      valueListenable: AppData.instance.studies,
      builder: (BuildContext context, List<StudyData> items, _) {
        return ResponsiveLayout(
          compact: (_) => StudiesMobileScreen(items: items),
          medium: (_) => StudiesTabletScreen(items: items),
          expanded: (_) => StudiesDesktopScreen(items: items),
        );
      },
    );
  }
}
