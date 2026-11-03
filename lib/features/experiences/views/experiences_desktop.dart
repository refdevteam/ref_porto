import 'package:flutter/material.dart';

import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/experiences/models/experience_data.dart';
import 'package:porto/features/experiences/widgets/experience_card.dart';

class ExperiencesDesktopScreen extends StatefulWidget {
  const ExperiencesDesktopScreen({super.key, required this.items});

  final List<ExperienceData> items;

  @override
  State<ExperiencesDesktopScreen> createState() =>
      _ExperiencesDesktopScreenState();
}

class _ExperiencesDesktopScreenState extends State<ExperiencesDesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(48, 32, 48, 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experiences',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 40),
          ExperienceGrid(
            items: widget.items,
            columns: context.screenWidth >= Breakpoints.expanded ? 3 : 2,
            spacing: 24,
          ),
        ],
      ),
    );
  }
}
