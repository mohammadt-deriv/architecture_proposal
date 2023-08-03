import 'package:architecture_proposal/helpers.dart';
import 'package:architecture_proposal/router.dart';
import 'package:architecture_proposal_data/architecture_proposal_data.dart';
import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
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
  Widget build(BuildContext context) => FeatureFlagBuilder(
        receiver: context.read<FeatureFlagRepository>(),
        builder: (context, flags) => HomeLayout(
          activeSymbolsFetcher: context.read<ActiveSymbolRepository>(),
          tickStreamManager: context.read<TickStreamManager>(),
          authManager: context.read<AuthCubit>(),
          chartFeatureEnabled: flags.contains(Feature.chartFeature),
          onShowChartTapped: () => context.goChart(),
          onLoggedOut: () => context.goAuth(),
          onError: (error) => showError(context, error),
        ),
      );
}
