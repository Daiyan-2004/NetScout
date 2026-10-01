import '../models/network_metrics.dart';

class MeasurementService {
  Future<NetworkMetrics> measure(String ssid) async {
    // TODO: read RSSI via network_info_plus, ping for latency, sample throughput
    return const NetworkMetrics(rssi: -65, latencyMs: 40, throughputMbps: 55);
  }
}