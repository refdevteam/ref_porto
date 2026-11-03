import 'package:flutter/material.dart';
import 'package:porto/components/frosted_card.dart';
import 'package:porto/core/utils/responsive_layout.dart';

class ProfileAvatar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      compact: (_) => FrostedIconCard(size: 100),
      medium: (_) => FrostedIconCard(size: 76),
      expanded: (_) => FrostedIconCard(size: 360),
    );
  }
}
