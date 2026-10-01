class Formatters {
  Formatters._();

  static String throughput(double mbps) => '${mbps.toStringAsFixed(1)} Mbps';
  static String latency(int ms) => '${ms}ms';
  static String signal(int rssiDbm) => '$rssiDbm dBm';
}