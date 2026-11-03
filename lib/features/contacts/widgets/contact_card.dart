import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:porto/core/theme/app_theme.dart';
import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/contacts/models/contact_data.dart';
import 'package:url_launcher/url_launcher.dart';

const String _workSubject = '[Work] Work Opportunity';
const String _workBody = '''
Hi Rifki,

I found your portfolio and would like to discuss a work opportunity.

- Role / Project:
- Timeline:
- Budget / Scope:

Best regards,
''';

/// Kartu kontak generik: judul + nilai, badge ikon melingkar di kanan,
/// dan action bar di dasar kartu. Kartu expandable menampilkan
/// [expandedContent] antara header dan bar.
class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
    this.icon,
    this.glyph,
    this.expanded = false,
    this.onToggle,
    this.expandedContent,
  }) : assert(icon != null || glyph != null);

  final String title;
  final String subtitle;

  /// Aksi utama action bar: membuka expand (kartu expandable) atau
  /// langsung membuka link (kartu tanpa expand).
  final String actionLabel;
  final VoidCallback onAction;

  final IconData? icon;

  /// Teks pengganti ikon di dalam badge (mis. `in` untuk LinkedIn —
  /// Material tidak menyediakan ikon LinkedIn).
  final String? glyph;

  final bool expanded;

  /// `null` → kartu tanpa expand (bar tanpa chevron).
  final VoidCallback? onToggle;

  final Widget? expandedContent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool compact = context.isCompact;
    final double headlineSize = switch (context.windowClass) {
      WindowClass.compact => 16,
      WindowClass.medium => 17,
      WindowClass.expanded => 20,
    };
    final double badgeSize = compact ? 32 : 80;
    final IconData? badgeIcon = icon;

    return FrostedGlass(
      padding: EdgeInsets.all(compact ? 14 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: compact ? 8 : 12,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontSize: headlineSize),
                        ),
                        const SizedBox(height: 4),
                        Text(subtitle, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  FrostedGlass(
                    radius: 999,
                    child: SizedBox(
                      width: badgeSize,
                      height: badgeSize,
                      child: Center(
                        child: badgeIcon != null
                            ? Icon(
                                badgeIcon,
                                size: badgeSize * 0.5,
                                color: theme.colorScheme.onSurfaceVariant,
                              )
                            : Text(
                                glyph!,
                                style: TextStyle(
                                  fontSize: badgeSize * 0.36,
                                  height: 1,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    alignment: AlignmentDirectional.topStart,
                    child: child,
                  ),
                ),
                child: expanded && expandedContent != null
                    ? Padding(
                        key: const ValueKey('contact-expanded'),
                        padding: const EdgeInsets.only(top: 14),
                        child: expandedContent,
                      )
                    : const SizedBox(key: ValueKey('contact-collapsed')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ActionBar(
            label: actionLabel,
            expanded: expanded,
            onPrimary: onAction,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}

/// Bar aksi dua zona: kiri = aksi utama (label + panah), kanan = chevron
/// toggle untuk kartu expandable. Kartu tanpa expand tampil tanpa chevron.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.label,
    required this.expanded,
    required this.onPrimary,
    this.onToggle,
  });

  final String label;
  final bool expanded;
  final VoidCallback onPrimary;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);

    final Widget primary = InkWell(
      onTap: onPrimary,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
          ),
          const Icon(Icons.arrow_outward, size: 16),
        ],
      ),
    );

    return FrostedGlass(
      radius: 12,
      fill: frost.fillStrong,
      shadow: false,
      padding: EdgeInsets.only(
        left: 14,
        right: onToggle == null ? 14 : 4,
        top: 9,
        bottom: 9,
      ),
      child: onToggle == null
          ? primary
          : Row(
              children: [
                Expanded(child: primary),
                InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(999),
                  child: AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Grid 3 kartu kontak; tinggi kartu disetarakan per baris lewat
/// [IntrinsicHeight]. State expand email & lokasi independen — beberapa
/// kartu boleh terbuka bersamaan.
class ContactGrid extends StatefulWidget {
  const ContactGrid({
    super.key,
    required this.data,
    required this.columns,
    this.spacing = 24,
  }) : assert(columns > 0);

  final ContactData data;
  final int columns;
  final double spacing;

  @override
  State<ContactGrid> createState() => _ContactGridState();
}

class _ContactGridState extends State<ContactGrid> {
  bool _emailExpanded = false;
  bool _locationExpanded = false;
  final TextEditingController _subject =
      TextEditingController(text: _workSubject);
  final TextEditingController _body = TextEditingController(text: _workBody);

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ContactData data = widget.data;

    final List<ContactCard> cards = <ContactCard>[
      ContactCard(
        title: 'Email',
        subtitle: data.email,
        icon: Icons.mail_outlined,
        actionLabel: _emailExpanded ? 'Send email' : 'Write email',
        onAction: _emailExpanded
            ? () => _sendEmail(data.email)
            : () => setState(() => _emailExpanded = true),
        expanded: _emailExpanded,
        onToggle: () => setState(() => _emailExpanded = !_emailExpanded),
        expandedContent: _emailForm(),
      ),
      ContactCard(
        title: 'LinkedIn',
        subtitle: _handleOf(data.linkedinUrl),
        glyph: 'in',
        actionLabel: 'Open profile',
        onAction: () => _openLinkedIn(data.linkedinUrl),
      ),
      ContactCard(
        title: 'Location',
        subtitle: data.location,
        icon: Icons.location_on_outlined,
        actionLabel:
            _locationExpanded ? 'Open in Google Maps' : 'View on map',
        onAction: _locationExpanded
            ? () => _openExternal(
                  'https://www.google.com/maps/search/?api=1'
                  '&query=${Uri.encodeComponent(data.location)}',
                  'Google Maps',
                )
            : () => setState(() => _locationExpanded = true),
        expanded: _locationExpanded,
        onToggle: () => setState(() => _locationExpanded = !_locationExpanded),
        expandedContent: _locationMap(data),
      ),
    ];

    final List<Widget> rows = <Widget>[];
    for (int start = 0; start < cards.length; start += widget.columns) {
      rows.add(
        _ContactRow(
          cards: <ContactCard?>[
            for (int offset = 0; offset < widget.columns; offset++)
              start + offset < cards.length
                  ? cards[start + offset]
                  : null,
          ],
          spacing: widget.spacing,
        ),
      );
    }

    return Column(spacing: widget.spacing, children: rows);
  }

  Widget _emailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _subject,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: _fieldDecoration('Subject'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _body,
          minLines: 5,
          maxLines: 8,
          keyboardType: TextInputType.multiline,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: _fieldDecoration('Message'),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration(String label) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: frost.border),
    );

    return InputDecoration(
      labelText: label,
      labelStyle: theme.textTheme.labelMedium,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: frost.fillStrong,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurfaceVariant,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _locationMap(ContactData data) {
    final ThemeData theme = Theme.of(context);
    final LatLng point = LatLng(data.latitude, data.longitude);

    return SizedBox(
      height: context.isCompact ? 200 : 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 13,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.porto',
            ),
            MarkerLayer(
              markers: <Marker>[
                Marker(
                  point: point,
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 44,
                    color: theme.colorScheme.onSurface,
                    shadows: const <Shadow>[
                      Shadow(color: Colors.black45, blurRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => _openExternal(
                    'https://www.openstreetmap.org/copyright',
                    'OpenStreetMap',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _handleOf(String url) => url
      .replaceFirst(RegExp(r'^https?://'), '')
      .replaceFirst('www.', '')
      .replaceAll(RegExp(r'/+$'), '');

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri.parse(
      'mailto:$email'
      '?subject=${Uri.encodeComponent(_subject.text.trim())}'
      '&body=${Uri.encodeComponent(_body.text)}',
    );

    bool opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      opened = false;
    }
    if (opened || !mounted) return;

    await Clipboard.setData(ClipboardData(text: email));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mail app not available — email copied to clipboard'),
        ),
      );
    }
  }

  Future<void> _openLinkedIn(String url) async {
    bool opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppBrowserView,
      );
    } on Exception {
      opened = false;
    }
    if (opened || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open LinkedIn')),
    );
  }

  Future<void> _openExternal(String url, String label) async {
    bool opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } on Exception {
      opened = false;
    }
    if (opened || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $label')),
    );
  }
}

/// Baris kartu: tinggi disetarakan lewat [IntrinsicHeight] selama semua
/// kartu tertutup; saat ada kartu terbuka, `IntrinsicHeight` dilepas dan
/// tinggi baris saat itu dibekukan lewat `minHeight` supaya kartu saudara
/// tidak ikut meregang — mekanisme yang sama dengan grid projects.
class _ContactRow extends StatefulWidget {
  const _ContactRow({required this.cards, required this.spacing});

  final List<ContactCard?> cards;
  final double spacing;

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  double? _frozenHeight;

  /// Tinggi baris terakhir saat semua kartu tertutup. Direkam pasca-frame,
  /// karena `context.size` tidak boleh dipanggil saat build.
  double? _lastClosedHeight;
  int _closeGeneration = 0;
  final List<GlobalKey> _cardKeys = <GlobalKey>[];

  // GlobalKey: saat struktur berpindah antar IntrinsicHeight/Row, kartu
  // direhome dengan animasi expand-nya utuh.
  GlobalKey _cardKey(int index) {
    while (_cardKeys.length <= index) {
      _cardKeys.add(GlobalKey());
    }
    return _cardKeys[index];
  }

  bool _anyOpen(List<ContactCard?> cards) =>
      cards.any((ContactCard? card) => card != null && card.expanded);

  @override
  void didUpdateWidget(covariant _ContactRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool wasOpen = _anyOpen(oldWidget.cards);
    final bool isOpen = _anyOpen(widget.cards);

    if (!wasOpen && isOpen && _frozenHeight == null) {
      // Tinggi kondisi semua tertutup sudah direkam pada frame sebelumnya.
      _frozenHeight = _lastClosedHeight;
    } else if (wasOpen && !isOpen && _frozenHeight != null) {
      // Beku dilepas setelah animasi tutup selesai, supaya tinggi baris
      // tidak ikut menyusut sebelum kartu selesai menutup.
      final int generation = ++_closeGeneration;
      Future.delayed(const Duration(milliseconds: 320), () {
        if (!mounted ||
            generation != _closeGeneration ||
            _anyOpen(widget.cards)) {
          return;
        }
        setState(() => _frozenHeight = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double? frozenHeight = _frozenHeight;

    if (frozenHeight == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _frozenHeight != null || _anyOpen(widget.cards)) {
          return;
        }
        final double? height = context.size?.height;
        if (height != null && height != _lastClosedHeight) {
          setState(() => _lastClosedHeight = height);
        }
      });
    }

    final Widget row = Row(
      spacing: widget.spacing,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int index = 0; index < widget.cards.length; index++)
          Expanded(child: _buildChild(index, frozenHeight)),
      ],
    );

    return frozenHeight == null ? IntrinsicHeight(child: row) : row;
  }

  Widget _buildChild(int index, double? frozenHeight) {
    final ContactCard? card = widget.cards[index];
    if (card == null) {
      return const SizedBox.shrink();
    }

    final Widget keyed = KeyedSubtree(key: _cardKey(index), child: card);

    if (frozenHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: frozenHeight),
        child: keyed,
      );
    }
    return keyed;
  }
}
