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
          Provider<ActiveSymbolRepository>(
            create: (context) => ActiveSymbolRepository(
              source: DerivApi.instance,
            ),
          ),
          Provider<TickStreamRepository>(
            create: (context) => TickStreamRepository(
              source: DerivApi.instance,
            ),
          ),
          Provider<AuthRepository>(
            create: (context) => AuthRepository(
              source: DerivApi.instance,
              storage: SPKeyValueStorage(),
            ),
          ),
          Provider<AuthCubit>(
            create: (context) => AuthCubit(
              authenticator: context.read<AuthRepository>(),
            ),
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
