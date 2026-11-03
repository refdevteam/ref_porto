import 'package:flutter/material.dart';
import 'package:porto/components/app_image.dart';
import 'package:porto/core/theme/app_theme.dart';
import 'package:porto/core/utils/responsive_layout.dart';

class FrostedIconCard extends StatelessWidget {
  const FrostedIconCard({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return FrostedGlass(
      radius: 40,
      child: SizedBox(
        width: size,
        height: size,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            context.isDarkMode ? AppAssets.iconOnDark : AppAssets.iconOnLight,
            fit: BoxFit.fill,
            scale: 2,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}

class FrostedImage extends StatelessWidget {
  final double size;
  final String imageAsset;
  const FrostedImage({super.key, this.size = 44, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return FrostedGlass(
      radius: 40,
      child: SizedBox(
        width: size,
        height: size,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AppImage(
            imageAsset,
            fit: BoxFit.fill,
            scale: 2,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}
