import 'feature_flag.dart';

abstract class FeatureFlagFetcher {
  Future<List<Feature>> fetchAvailableFeatures();
}
