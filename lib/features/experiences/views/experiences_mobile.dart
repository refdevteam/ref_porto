import 'package:flutter/material.dart';

import 'package:porto/features/experiences/models/experience_data.dart';
import 'package:porto/features/experiences/widgets/experience_card.dart';

class ExperiencesMobileScreen extends StatefulWidget {
  const ExperiencesMobileScreen({super.key, required this.items});

  final List<ExperienceData> items;

  @override
  State<ExperiencesMobileScreen> createState() =>
      _ExperiencesMobileScreenState();
}

class _ExperiencesMobileScreenState extends State<ExperiencesMobileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experiences',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          ExperienceGrid(items: widget.items, columns: 1, spacing: 16),
        ],
      ),
    );
  }
}
