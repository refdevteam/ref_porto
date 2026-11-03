import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:porto/features/contacts/contacts_page.dart';
import 'package:porto/features/experiences/experiences_page.dart';
import 'package:porto/features/home/home_page.dart';
import 'package:porto/features/intro/splash_page.dart';
import 'package:porto/features/projects/projects_page.dart';
import 'package:porto/features/studies/studies_page.dart';
import 'package:porto/main_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainPage(navigationShell: navigationShell);
      },
      branches: [
        // Index 0
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomePage()),
          ],
        ),
        // Index 1
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/studies',
              builder: (context, state) => const StudiesPage(),
            ),
          ],
        ),
        // Index 2
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/experiences',
              builder: (context, state) => const ExperiencesPage(),
            ),
          ],
        ),
        // Index 3
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects',
              builder: (context, state) => const ProjectsPage(),
            ),
          ],
        ),
        // Index 4
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/contacts',
              builder: (context, state) => const ContactsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
