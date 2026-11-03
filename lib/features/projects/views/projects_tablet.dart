import 'package:flutter/material.dart';
import 'package:porto/features/projects/models/projects_data.dart';
import 'package:porto/features/projects/widgets/project_card.dart';

class ProjectsTabletScreen extends StatefulWidget {
  const new({super.key, required this.items});

  final List<ProjectsData> items;

  @override
  State<ProjectsTabletScreen> createState() => _ProjectsTabletScreenState();
}

class _ProjectsTabletScreenState extends State<ProjectsTabletScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 32,
        children: [
          Text(
            'Projects',
            style: Theme.of(context).textTheme.displayLarge
                ?.copyWith(fontSize: 40),
          ),
          ProjectGrid(items: widget.items, columns: 2, spacing: 20),
        ],
      ),
    );
  }
}
