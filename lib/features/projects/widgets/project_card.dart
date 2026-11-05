import 'package:flutter/material.dart';
import 'package:porto/components/app_image.dart';
import 'package:porto/components/frosted_card.dart';
import 'package:porto/core/theme/app_theme.dart';
import 'package:porto/core/utils/responsive_layout.dart';
import 'package:porto/features/projects/models/projects_data.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.data, this.onToggle});

  final ProjectsData data;

  /// Dilaporkan ke baris grid: `true` ketika deskripsi dibuka.
  final ValueChanged<bool>? onToggle;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _showDescription = false;

  void _toggle() {
    final bool next = !_showDescription;
    widget.onToggle?.call(next);
    setState(() => _showDescription = next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ProjectsData data = widget.data;
    final bool compact = context.isCompact;
    final double headlineSize = switch (context.windowClass) {
      WindowClass.compact => 16,
      WindowClass.medium => 17,
      WindowClass.expanded => 20,
    };

    final Widget pills = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (data.stack.isNotEmpty)
          _InfoPill(
            icon: Icons.system_update_alt_outlined,
            label: 'Stack: ${data.stack}',
          ),
        _InfoPill(icon: Icons.schedule_rounded, label: data.durationWork),
      ],
    );

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
                          child: Text(data.projectName),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.projectType,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (!compact) ...[const SizedBox(height: 14), pills],
                      ],
                    ),
                  ),
                  _ProjectLogo(
                    logoAsset: data.logoAsset,
                    size: compact ? 50 : 80,
                  ),
                ],
              ),
              if (compact) ...[const SizedBox(height: 10), pills],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.description,
                              style: theme.textTheme.bodyMedium,
                            ),
                            if (data.photos.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              _PhotoGrid(
                                photos: data.photos,
                                heroPrefix: identityHashCode(data).toString(),
                              ),
                            ],
                          ],
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

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
            icon,
            size: compact ? 11 : 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          // Row memberi lebar tak terbatas ke anaknya; teks dibatasi
          // supaya membungkus, bukan overflow, di layar sempit.
          Flexible(
            child: Text(
              label,
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

class _ProjectLogo extends StatelessWidget {
  const _ProjectLogo({required this.logoAsset, required this.size});

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
          Icons.laptop_outlined,
          size: size * 0.5,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.photos, required this.heroPrefix});

  final List<String> photos;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    final int perRow = context.isCompact ? 2 : 3;
    final double spacing = context.isCompact ? 8 : 12;
    final List<Widget> rows = <Widget>[];

    for (int start = 0; start < photos.length; start += perRow) {
      rows.add(
        Row(
          spacing: spacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int offset = 0; offset < perRow; offset++)
              Expanded(
                child: start + offset < photos.length
                    ? AspectRatio(
                        aspectRatio: 1,
                        child: _PhotoTile(
                          asset: photos[start + offset],
                          heroTag: '$heroPrefix-${start + offset}',
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
          ],
        ),
      );
    }

    return Column(spacing: spacing, children: rows);
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.asset, required this.heroTag});

  final String asset;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);

    return InkWell(
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => _ZoomDialog(asset: asset, heroTag: heroTag),
      ),
      borderRadius: BorderRadius.circular(12),
      child: FrostedGlass(
        radius: 12,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child: AppImage(
                asset,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FrostedGlass(
                  radius: 999,
                  fill: frost.fillStrong,
                  shadow: false,
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.zoom_in_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomDialog extends StatelessWidget {
  const _ZoomDialog({required this.asset, required this.heroTag});

  final String asset;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FrostedTheme frost = FrostedTheme.of(context);
    final double areaHeight = MediaQuery.sizeOf(context).height * 0.6;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 720),
      child: FrostedGlass(
        radius: 20,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: areaHeight,
              child: InteractiveViewer(
                maxScale: 5,
                child: Hero(
                  tag: heroTag,
                  child: AppImage(asset, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(999),
                  child: FrostedGlass(
                    radius: 999,
                    fill: frost.fillStrong,
                    shadow: false,
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// disamakan selama semua kartu tertutup.
class ProjectGrid extends StatefulWidget {
  const ProjectGrid({
    super.key,
    required this.items,
    required this.columns,
    this.spacing = 24,
  }) : assert(columns > 0);

  final List<ProjectsData> items;
  final int columns;
  final double spacing;

  @override
  State<ProjectGrid> createState() => _ProjectGridState();
}

class _ProjectGridState extends State<ProjectGrid> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];

    for (int start = 0; start < widget.items.length; start += widget.columns) {
      rows.add(
        _CardsRow(
          items: <ProjectsData?>[
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

  final List<ProjectsData?> items;
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
    final ProjectsData? item = widget.items[index];
    if (item == null) {
      return const SizedBox.shrink();
    }

    final Widget card = ProjectCard(
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
