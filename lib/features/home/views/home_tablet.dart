import 'package:flutter/material.dart';
import 'package:porto/features/home/widgets/profile_avatar.dart';
import 'package:porto/features/home/widgets/resume_card.dart';

class HomeTabletScreen extends StatefulWidget {
  const new({super.key});

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
              description: 'Mobile Developer (Flutter) and UI/UX Enthusiast based in Kediri, Indonesia, specializing in building intuitive and scalable digital products. With over two years of experience in the software industry, I have evolved from full-stack web development to focusing on high-performance mobile application engineering. I actively build, maintain, and monitor robust application ecosystems using Flutter, Firebase, and Laravel. I am deeply passionate about bridging the gap between functional product development and user-centered design to deliver seamless digital experiences.',
              tabletTrailingWidget: ProfileAvatar(),
            ),
          ),
        ),
      ),
    );
  }
}
