import 'package:flutter/material.dart';
import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/contacts/models/contact_data.dart';
import 'package:porto/features/contacts/widgets/contact_card.dart';

class ContactDesktopScreen extends StatefulWidget {
  const new({super.key, required this.data});

  final ContactData data;

  @override
  State<ContactDesktopScreen> createState() => _ContactDesktopScreenState();
}

class _ContactDesktopScreenState extends State<ContactDesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(48, 32, 48, 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 40,
        children: [
          Text('Contact', style: Theme.of(context).textTheme.displayLarge),
          ContactGrid(
            data: widget.data,
            columns: context.screenWidth >= Breakpoints.expanded ? 3 : 2,
            spacing: 24,
          ),
        ],
      ),
    );
  }
}
