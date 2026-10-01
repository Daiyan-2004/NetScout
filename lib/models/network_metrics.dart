class NetworkMetrics {
  final int rssi;           // dBm, e.g. -65
  final int latencyMs;
  final double throughputMbps;

  const NetworkMetrics({
    required this.rssi,
    required this.latencyMs,
    required this.throughputMbps,

  });
}