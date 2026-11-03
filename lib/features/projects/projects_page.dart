import 'package:flutter/material.dart';
import 'package:porto/core/data/app_data.dart';
import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/projects/models/projects_data.dart';
import 'package:porto/features/projects/views/projects_desktop.dart';
import 'package:porto/features/projects/views/projects_mobile.dart';
import 'package:porto/features/projects/views/projects_tablet.dart';

class ProjectsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProjectsData>>(
      valueListenable: AppData.instance.projects,
      builder: (BuildContext context, List<ProjectsData> items, _) {
        return ResponsiveLayout(
          compact: (_) => ProjectsMobileScreen(items: items),
          medium: (_) => ProjectsTabletScreen(items: items),
          expanded: (_) => ProjectsDesktopScreen(items: items),
        );
      },
    );
  }
}
