import 'package:flutter/material.dart';

import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/contacts/models/contact_data.dart';
import 'package:porto/features/contacts/views/contact_desktop.dart';
import 'package:porto/features/contacts/views/contact_mobile.dart';
import 'package:porto/features/contacts/views/contact_tablet.dart';

class ContactsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      compact: (_) => const ContactMobileScreen(data: contact),
      medium: (_) => const ContactTabletScreen(data: contact),
      expanded: (_) => const ContactDesktopScreen(data: contact),
    );
  }
}
