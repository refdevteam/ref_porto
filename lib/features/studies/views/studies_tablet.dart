import 'package:flutter/material.dart';

import 'package:porto/features/studies/models/study_data.dart';
import 'package:porto/features/studies/widgets/study_card.dart';

class StudiesTabletScreen extends StatefulWidget {
  const StudiesTabletScreen({super.key, required this.items});

  final List<StudyData> items;

  @override
  State<StudiesTabletScreen> createState() => _StudiesTabletScreenState();
}

class _StudiesTabletScreenState extends State<StudiesTabletScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32,
        children: [
          Text(
            'Studies',
            style: Theme.of(context).textTheme.displayLarge
                ?.copyWith(fontSize: 40),
          ),
          StudyGrid(items: widget.items, columns: 2, spacing: 20),
        ],
      ),
    );
  }
}
