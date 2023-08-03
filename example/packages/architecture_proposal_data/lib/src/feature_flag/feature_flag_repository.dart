import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';

class FeatureFlagRepository implements FeatureFlagReceiver {
  @override
  Future<List<Feature>> fetchAvailableFeatures() async {
    // Mock API Call
    await Future.delayed(Duration(seconds: 1));
    //return [Feature.featureA];
    //return [Feature.featureB];
    return [Feature.chartFeature];
  }
}
