import 'package:flutter/material.dart';

/// Gambar yang menerima path asset lokal (`assets/...`) atau URL remote
/// (Supabase Storage). URL dimuat sebagai network image dengan placeholder
/// bila gagal dimuat.
class AppImage extends StatelessWidget {
  const AppImage(
    this.source, {
    super.key,
    this.fit,
    this.scale = 1.0,
    this.filterQuality,
  });

  final String source;
  final BoxFit? fit;
  final double scale;
  final FilterQuality? filterQuality;

  @override
  Widget build(BuildContext context) {
    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: fit,
        scale: scale,
        filterQuality: filterQuality ?? FilterQuality.medium,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => Icon(
          Icons.image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Image.asset(
      source,
      fit: fit,
      scale: scale,
      filterQuality: filterQuality ?? FilterQuality.medium,
    );
  }
}
