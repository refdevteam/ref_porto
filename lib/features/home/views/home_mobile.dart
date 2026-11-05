import 'package:flutter/material.dart';
import 'package:porto/features/home/widgets/profile_avatar.dart';
import 'package:porto/features/home/widgets/resume_card.dart';

class HomeMobileScreen extends StatefulWidget {
  const new({super.key, required this.description});

  final String description;

  @override
  State<HomeMobileScreen> createState() => _HomeMobileScreenState();
}

class _HomeMobileScreenState extends State<HomeMobileScreen> {
  @override
  Widget build(BuildContext context) {
    // Overlay navbar melayang: panel 48px + jarak bawah 16px.
    final double navOverlay = 64 + MediaQuery.of(context).viewPadding.bottom;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: 24.0 + navOverlay,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Center(
                  child: ResumeCard(
                    title: 'Mohammad Rifki Reza Fahlevi',
                    description: widget.description,
                    mobileTrailingWidget: ProfileAvatar(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
