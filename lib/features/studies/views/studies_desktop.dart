import 'package:flutter/material.dart';

import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/studies/models/study_data.dart';
import 'package:porto/features/studies/widgets/study_card.dart';

class StudiesDesktopScreen extends StatefulWidget {
  const StudiesDesktopScreen({super.key, required this.items});

  final List<StudyData> items;

  @override
  State<StudiesDesktopScreen> createState() => _StudiesDesktopScreenState();
}

class _StudiesDesktopScreenState extends State<StudiesDesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(48, 32, 48, 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 40,
        children: [
          Text('Studies', style: Theme.of(context).textTheme.displayLarge),
          StudyGrid(
            items: widget.items,
            columns: context.screenWidth >= Breakpoints.expanded ? 3 : 2,
            spacing: 24,
          ),
        ],
      ),
    );
  }
}
