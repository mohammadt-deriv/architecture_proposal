import 'package:architecture_proposal/pages/chart_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:architecture_proposal/pages/auth_page.dart';
import 'package:architecture_proposal/pages/home_page.dart';
import 'package:architecture_proposal/pages/splash_page.dart';

const splashRoute = '/splash';
const homeRoute = '/home';
const authRoute = '/auth';
const chartRouteName = 'chart';
const chartFullRoute = '$homeRoute/$chartRouteName';

final routerConfig = GoRouter(
  initialLocation: splashRoute,
  routes: [
    GoRoute(
      path: splashRoute,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: homeRoute,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: chartRouteName,
          builder: (context, state) => const ChartPage(),
        ),
      ],
    ),
    GoRoute(
      path: authRoute,
      builder: (context, state) => const AuthPage(),
    ),
  ],
);

extension RouterExtensions on BuildContext {
  void goHome() => go(homeRoute);
  void goAuth() => go(authRoute);
  void goChart() => go(chartFullRoute);
}
