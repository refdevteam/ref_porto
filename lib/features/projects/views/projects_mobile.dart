import 'package:flutter/material.dart';
import 'package:porto/features/projects/models/projects_data.dart';
import 'package:porto/features/projects/widgets/project_card.dart';

class ProjectsMobileScreen extends StatefulWidget {
  const new({super.key, required this.items});

  final List<ProjectsData> items;

  @override
  State<ProjectsMobileScreen> createState() => _ProjectsMobileScreenState();
}

class _ProjectsMobileScreenState extends State<ProjectsMobileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 24,
        children: [
          Text('Projects', style: Theme.of(context).textTheme.headlineMedium),
          ProjectGrid(items: widget.items, columns: 1, spacing: 16),
        ],
      ),
    );
  }
}
