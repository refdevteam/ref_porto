import 'package:flutter/material.dart';
import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/projects/models/projects_data.dart';
import 'package:porto/features/projects/widgets/project_card.dart';

class ProjectsDesktopScreen extends StatefulWidget {
  const new({super.key, required this.items});

  final List<ProjectsData> items;

  @override
  State<ProjectsDesktopScreen> createState() => _ProjectsDesktopScreenState();
}

class _ProjectsDesktopScreenState extends State<ProjectsDesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(48, 32, 48, 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 40,
        children: [
          Text('Projects', style: Theme.of(context).textTheme.displayLarge),
          ProjectGrid(
            items: widget.items,
            columns: context.screenWidth >= Breakpoints.expanded ? 3 : 2,
            spacing: 24,
          ),
        ],
      ),
    );
  }
}
