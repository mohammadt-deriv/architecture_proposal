class Tick {
  Tick({
    required this.epoch,
    required this.quote,
    required this.symbol,
    required this.pipSize,
  });

  final int epoch;
  final double quote;
  final String symbol;
  final int pipSize;
}
