import 'package:flutter/material.dart';
import 'package:porto/features/home/widgets/profile_avatar.dart';
import 'package:porto/features/home/widgets/resume_card.dart';

class HomeTabletScreen extends StatefulWidget {
  const new({super.key, required this.description});

  final String description;

  @override
  State<HomeTabletScreen> createState() => _HomeTabletScreenState();
}

class _HomeTabletScreenState extends State<HomeTabletScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 800),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: ResumeCard(
              title: 'Mohammad Rifki Reza Fahlevi',
              description: widget.description,
              tabletTrailingWidget: ProfileAvatar(),
            ),
          ),
        ),
      ),
    );
  }
}
