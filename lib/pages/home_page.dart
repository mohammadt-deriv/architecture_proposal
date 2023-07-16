import 'package:architecture_proposal/helpers.dart';
import 'package:architecture_proposal/router.dart';
import 'package:architecture_proposal_data/architecture_proposal_data.dart';
import 'package:architecture_proposal_ui/architecture_proposal_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pages are part of `App` layer(package) and they DON'T implement any UI code.
/// Pages are responsible for providing dependencies for UI layer,
/// because its the only package which has access to all data,domain,ui packages.
///
/// Here we used `Provider` to provide dependencies.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => HomeLayout(
        activeSymbolsFetcher: context.read<ActiveSymbolRepository>(),
        tickStreamFetcher: context.read<TickStreamRepository>(),
        authManager: context.read<AuthCubit>(),
        onLoggedOut: () => context.pushAuth(replacement: true),
        onError: (error) => showError(context, error),
      );
}
