import 'package:flutter/material.dart';
import 'package:porto/core/theme/app_theme.dart';
import 'package:porto/core/theme/colors.dart';
import 'package:porto/core/utils/responsive_layout.dart';

class ResumeCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget? tabletTrailingWidget;

  /// (Baru) Widget yang akan muncul di atas judul saat layar mobile
  final Widget? mobileTrailingWidget;

  const ResumeCard({
    super.key,
    required this.title,
    required this.description,
    this.tabletTrailingWidget,
    this.mobileTrailingWidget,
  });

  Widget _buildTitleBlock(BuildContext context, double labelSize) {
    Widget titleWidget = FrostedGlass(
      padding: const EdgeInsets.all(22.0),
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        textAlign: TextAlign.center,
        style: TextStyle(
          letterSpacing: 0.1,
          fontSize: labelSize,
          fontWeight: FontWeight.bold,
          color: context.isDarkMode
              ? AppColors.lightTextTertiary
              : AppColors.lightTextPrimary,
        ),
        child: Text(title),
      ),
    );

    if (context.isCompact) {
      titleWidget = SizedBox(width: double.infinity, child: titleWidget);
    }

    if (context.isMedium && tabletTrailingWidget != null) {
      return Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          titleWidget,
          Flexible(child: tabletTrailingWidget!),
        ],
      );
    }

    return titleWidget;
  }

  Widget _buildContent(BuildContext context, double labelSize) {
    return AnimatedSize(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,

      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: Column(
          key: ValueKey('content_${context.windowClass}'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8.0,
          children: [
            // Tampilkan widget ini di urutan paling atas khusus untuk layar compact/mobile
            if (context.isCompact && mobileTrailingWidget != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: mobileTrailingWidget!,
                ),
              ),

            _buildTitleBlock(context, labelSize),

            FrostedGlass(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                maxLines: null,
                style: TextStyle(
                  color: context.isDarkMode
                      ? AppColors.lightTextTertiary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      compact: (_) => _buildContent(context, 19.5),
      medium: (_) => _buildContent(context, 19),
      expanded: (_) => _buildContent(context, 32),
    );
  }
}
