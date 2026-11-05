import 'package:flutter/material.dart';
import 'package:porto/components/frosted_card.dart';
import 'package:porto/core/theme/app_theme.dart';
import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/experiences/models/experience_data.dart';

/// Kartu pengalaman frosted glass: headline posisi, nama office, durasi,
/// logo office di kanan, dan deskripsi yang dibuka lewat tombol dropdown.
class ExperienceCard extends StatefulWidget {
  const ExperienceCard({super.key, required this.data, this.onToggle});

  final ExperienceData data;

  /// Dilaporkan ke baris grid: `true` ketika deskripsi dibuka.
  final ValueChanged<bool>? onToggle;

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _showDescription = false;

  void _toggle() {
    final bool next = !_showDescription;
    widget.onToggle?.call(next);
    setState(() => _showDescription = next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ExperienceData data = widget.data;
    final bool compact = context.isCompact;
    final double headlineSize = switch (context.windowClass) {
      WindowClass.compact => 16,
      WindowClass.medium => 17,
      WindowClass.expanded => 20,
    };

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
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: theme.textTheme.titleLarge!.copyWith(
                            fontSize: headlineSize,
                          ),
                          child: Text(data.position),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.officeName,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (!compact) ...[
                          const SizedBox(height: 14),
                          _DurationPill(duration: data.duration),
                        ],
                      ],
                    ),
                  ),
                  _OfficeLogo(
                    logoAsset: data.logoAsset,
                    size: compact ? 50 : 80,
                  ),
                ],
              ),
              if (compact) ...[
                const SizedBox(height: 10),
                _DurationPill(duration: data.duration),
              ],
              // Fade dan tinggi kartu ikut mengecil serentak selama transisi.
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
                child: _showDescription
                    ? Padding(
                        key: const ValueKey('description'),
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          data.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : const SizedBox(key: ValueKey('description-hidden')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DescriptionButton(expanded: _showDescription, onTap: _toggle),
        ],
      ),
    );
  }
}

class _DurationPill extends StatelessWidget {
  const _DurationPill({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);
    final bool compact = context.isCompact;

    return FrostedGlass(
      radius: 999,
      fill: frost.fillStrong,
      shadow: false,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: compact ? 4 : 5,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: compact ? 11 : 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          // Row memberi lebar tak terbatas ke anaknya; teks dibatasi
          // supaya membungkus, bukan overflow, di layar sempit.
          Flexible(
            child: Text(
              duration,
              style: compact
                  ? theme.textTheme.labelSmall
                  : theme.textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionButton extends StatelessWidget {
  const _DescriptionButton({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: FrostedGlass(
        radius: 12,
        fill: frost.fillStrong,
        shadow: false,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                expanded ? 'Show less' : 'Read more',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium,
              ),
            ),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfficeLogo extends StatelessWidget {
  const _OfficeLogo({required this.logoAsset, required this.size});

  final String? logoAsset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String? asset = logoAsset;
    if (asset != null) {
      return FrostedImage(size: size, imageAsset: asset);
    }

    return FrostedGlass(
      radius: 999,
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.business_outlined,
          size: size * 0.5,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Grid kartu experience: [columns] kolom per baris. Tinggi kartu dalam 1
/// baris disamakan selama semua kartu tertutup.
class ExperienceGrid extends StatefulWidget {
  const ExperienceGrid({
    super.key,
    required this.items,
    required this.columns,
    this.spacing = 24,
  }) : assert(columns > 0);

  final List<ExperienceData> items;
  final int columns;
  final double spacing;

  @override
  State<ExperienceGrid> createState() => _ExperienceGridState();
}

class _ExperienceGridState extends State<ExperienceGrid> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];

    for (int start = 0; start < widget.items.length; start += widget.columns) {
      rows.add(
        _CardsRow(
          items: <ExperienceData?>[
            for (int offset = 0; offset < widget.columns; offset++)
              start + offset < widget.items.length
                  ? widget.items[start + offset]
                  : null,
          ],
          spacing: widget.spacing,
        ),
      );
    }

    return Column(spacing: widget.spacing, children: rows);
  }
}

/// Baris kartu: tinggi disetarakan lewat [IntrinsicHeight] selama semua
/// kartu tertutup; saat kartu dibuka, tinggi saat itu dibekukan lewat
/// `minHeight` supaya kartu saudara tidak ikut bergerak.
class _CardsRow extends StatefulWidget {
  const _CardsRow({required this.items, required this.spacing});

  final List<ExperienceData?> items;
  final double spacing;

  @override
  State<_CardsRow> createState() => _CardsRowState();
}

class _CardsRowState extends State<_CardsRow> {
  final Set<int> _opened = <int>{};
  double? _frozenHeight;
  int _closeGeneration = 0;
  final List<GlobalKey> _cardKeys = <GlobalKey>[];

  // GlobalKey: saat baris berpindah antar IntrinsicHeight/Row, kartu direhome
  // dengan State & animasinya utuh — ekspansi tidak hilang saat tap pertama.
  GlobalKey _cardKey(int index) {
    while (_cardKeys.length <= index) {
      _cardKeys.add(GlobalKey());
    }
    return _cardKeys[index];
  }

  void _onToggle(int index, bool expanded) {
    final double? currentHeight = context.size?.height;
    bool scheduleUnfreeze = false;
    setState(() {
      if (expanded) {
        _opened.add(index);
        if (_opened.length == 1 && _frozenHeight == null) {
          _frozenHeight = currentHeight;
        }
      } else {
        _opened.remove(index);
        scheduleUnfreeze = _opened.isEmpty && _frozenHeight != null;
      }
    });

    // Beku dilepas setelah animasi tutup selesai, supaya tinggi baris tidak
    // ikut mengikuti kartu yang sedang menyusut.
    if (scheduleUnfreeze) {
      final int generation = ++_closeGeneration;
      Future.delayed(const Duration(milliseconds: 320), () {
        if (!mounted || generation != _closeGeneration || _opened.isNotEmpty) {
          return;
        }
        setState(() => _frozenHeight = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double? frozenHeight = _frozenHeight;

    final Widget row = Row(
      spacing: widget.spacing,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int index = 0; index < widget.items.length; index++)
          Expanded(child: _buildChild(index, frozenHeight)),
      ],
    );

    return frozenHeight == null ? IntrinsicHeight(child: row) : row;
  }

  Widget _buildChild(int index, double? frozenHeight) {
    final ExperienceData? item = widget.items[index];
    if (item == null) {
      return const SizedBox.shrink();
    }

    final Widget card = ExperienceCard(
      key: _cardKey(index),
      data: item,
      onToggle: (bool expanded) => _onToggle(index, expanded),
    );

    if (frozenHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: frozenHeight),
        child: card,
      );
    }
    return card;
  }
}
