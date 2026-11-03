import 'package:flutter/material.dart';

import 'package:porto/features/studies/models/study_data.dart';
import 'package:porto/features/studies/widgets/study_card.dart';

class StudiesMobileScreen extends StatefulWidget {
  const StudiesMobileScreen({super.key, required this.items});

  final List<StudyData> items;

  @override
  State<StudiesMobileScreen> createState() => _StudiesMobileScreenState();
}

class _StudiesMobileScreenState extends State<StudiesMobileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Text('Studies', style: Theme.of(context).textTheme.headlineMedium),
          StudyGrid(items: widget.items, columns: 2, spacing: 16),
        ],
      ),
    );
  }
}
