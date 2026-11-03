import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:porto/core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  // Animation Controller
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 800),
    reverseDuration: Duration(milliseconds: 500),
  );

  // Ikon: fade in duluan (0% – 60% dari progress).
  late final Animation<double> _iconOpacity = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
  );

  // Teks: nyusul (40% – 100% dari progress).
  late final Animation<double> _textOpacity = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
  );

  // Ikon: scale up biar terasa "pop".
  late final Animation<double> _iconScale = Tween<double>(begin: 0.7, end: 0.6)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 0.6, curve: Curves.easeOutBack),
        ),
      );

  /// Durasi splash screen
  static const Duration _splashDuration = Duration(seconds: 3);
  static const Duration _outDuration = Duration(milliseconds: 500);

  Future<void> nextToHome() async {
    await Future.delayed(_splashDuration);

    // Safety stop
    if (!mounted) return;
    _controller.reverse();

    await Future.delayed(_outDuration);

    if (!mounted) return;
    context.go('/');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      nextToHome();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _iconOpacity,
                child: ScaleTransition(
                  scale: _iconScale,
                  child: Image.asset(
                    // Mode terang → ikon bertinta gelap, mode gelap →
                    // ikon bertinta terang, biar tetap kontras.
                    Theme.of(context).brightness == Brightness.dark
                        ? AppAssets.iconOnDark
                        : AppAssets.iconOnLight,
                    scale: 2,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _textOpacity,
                child: Text(
                  "Welcome to Rifki's Portofolio",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
