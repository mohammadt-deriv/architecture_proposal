import 'feature_flag.dart';

abstract class FeatureFlagReceiver {
  Future<List<Feature>> fetchAvailableFeatures();
}
