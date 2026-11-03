import 'package:flutter/material.dart';
import 'package:porto/features/home/widgets/profile_avatar.dart';
import 'package:porto/features/home/widgets/resume_card.dart';

class HomeDesktopScreen extends StatefulWidget {
  const new({super.key, required this.description});

  final String description;

  @override
  State<HomeDesktopScreen> createState() => _HomeDesktopScreenState();
}

class _HomeDesktopScreenState extends State<HomeDesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 800),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8.0,
            children: [
              Flexible(child: ProfileAvatar()),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 480),
                child: ResumeCard(
                  title: 'Mohammad Rifki Reza Fahlevi',
                  description: widget.description,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
