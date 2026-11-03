import 'package:flutter/material.dart';

import 'package:porto/features/experiences/models/experience_data.dart';
import 'package:porto/features/experiences/widgets/experience_card.dart';

class ExperiencesTabletScreen extends StatefulWidget {
  const ExperiencesTabletScreen({super.key, required this.items});

  final List<ExperienceData> items;

  @override
  State<ExperiencesTabletScreen> createState() =>
      _ExperiencesTabletScreenState();
}

class _ExperiencesTabletScreenState extends State<ExperiencesTabletScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experiences',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 32),
          ExperienceGrid(items: widget.items, columns: 2, spacing: 20),
        ],
      ),
    );
  }
}
