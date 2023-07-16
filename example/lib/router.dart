import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:architecture_proposal/pages/auth_page.dart';
import 'package:architecture_proposal/pages/home_page.dart';
import 'package:architecture_proposal/pages/splash_page.dart';

const splashRoute = '/splash';
const homeRoute = '/home';
const authRoute = '/auth';

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
    ),
    GoRoute(
      path: authRoute,
      builder: (context, state) => const AuthPage(),
    ),
  ],
);

extension RouterExtensions on BuildContext {
  void pushHome({bool replacement = false}) =>
      replacement ? pushReplacement(homeRoute) : push(homeRoute);
  void pushAuth({bool replacement = false}) =>
      replacement ? pushReplacement(authRoute) : push(authRoute);
}
