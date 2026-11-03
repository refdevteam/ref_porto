import 'package:flutter/material.dart';
import 'package:porto/features/contacts/models/contact_data.dart';
import 'package:porto/features/contacts/widgets/contact_card.dart';

class ContactMobileScreen extends StatefulWidget {
  const new({super.key, required this.data});

  final ContactData data;

  @override
  State<ContactMobileScreen> createState() => _ContactMobileScreenState();
}

class _ContactMobileScreenState extends State<ContactMobileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 24,
        children: [
          Text(
            'Contact',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ContactGrid(data: widget.data, columns: 1, spacing: 16),
        ],
      ),
    );
  }
}
