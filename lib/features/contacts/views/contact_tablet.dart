import 'package:flutter/material.dart';
import 'package:porto/features/contacts/models/contact_data.dart';
import 'package:porto/features/contacts/widgets/contact_card.dart';

class ContactTabletScreen extends StatefulWidget {
  const new({super.key, required this.data});

  final ContactData data;

  @override
  State<ContactTabletScreen> createState() => _ContactTabletScreenState();
}

class _ContactTabletScreenState extends State<ContactTabletScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 32,
        children: [
          Text(
            'Contact',
            style: Theme.of(context).textTheme.displayLarge
                ?.copyWith(fontSize: 40),
          ),
          ContactGrid(data: widget.data, columns: 2, spacing: 20),
        ],
      ),
    );
  }
}
