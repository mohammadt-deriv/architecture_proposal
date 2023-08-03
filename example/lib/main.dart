import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:architecture_proposal_data/architecture_proposal_data.dart';

import 'router.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<ActiveSymbolsFetcher>(
            create: (context) => ActiveSymbolRepository(
              source: DerivApi.instance,
            ),
          ),
          Provider<TickStreamFetcher>(
            create: (context) => TickStreamRepository(
              source: DerivApi.instance,
            ),
          ),
          Provider<Authenticator>(
            create: (context) => AuthRepository(
              source: DerivApi.instance,
              storage: SPKeyValueStorage(),
            ),
          ),
          Provider<AuthManager>(
            create: (context) => AuthCubit(
              authenticator: context.read<Authenticator>(),
            ),
          ),
          Provider<TickStreamManager>(
            create: (context) => TickStreamCubit(
              fetcher: context.read<TickStreamFetcher>(),
            ),
          ),
          Provider<FeatureFlagFetcher>(
            create: (context) => FeatureFlagRepository(),
          ),
        ],
        child: MaterialApp.router(
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          routerConfig: routerConfig,
        ),
      );
}
