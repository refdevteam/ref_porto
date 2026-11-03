import 'package:flutter/material.dart';
import 'package:porto/core/routes/app_router.dart';

import 'package:porto/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeModeKey = 'themeMode';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? saved = prefs.getString(_themeModeKey);
  AppTheme.mode.value = ThemeMode.values.firstWhere(
    (ThemeMode mode) => mode.name == saved,
    orElse: () => ThemeMode.system,
  );

  AppTheme.mode.addListener(() {
    prefs.setString(_themeModeKey, AppTheme.mode.value.name);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (BuildContext context, ThemeMode themeMode, _) {
        return MaterialApp.router(
          title: 'Ref Porto',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
