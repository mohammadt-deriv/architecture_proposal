class Tick {
  Tick({
    required this.id,
    required this.epoch,
    required this.quote,
    required this.symbol,
    required this.pipSize,
  });

  final String id;
  final int epoch;
  final num quote;
  final String symbol;
  final int pipSize;
}
