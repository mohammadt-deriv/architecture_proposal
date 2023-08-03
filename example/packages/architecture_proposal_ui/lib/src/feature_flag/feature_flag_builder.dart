import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:flutter/material.dart';

class FeatureFlagBuilder extends StatelessWidget {
  const FeatureFlagBuilder({
    required this.receiver,
    required this.builder,
    super.key,
  });

  final FeatureFlagFetcher receiver;
  final Widget Function(BuildContext, List<Feature>) builder;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Feature>>(
        future: receiver.fetchAvailableFeatures(),
        builder: (context, snapshot) {
          final flags = snapshot.hasData ? snapshot.data! : <Feature>[];

          return builder(context, flags);
        },
      );
}
