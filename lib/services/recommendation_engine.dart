import '../core/constants/app_constants.dart';
import '../models/campus_network.dart';
import '../models/campus_location.dart';
import '../models/network_metrics.dart';
import '../models/recommendation.dart';

class RecommendationEngine {
  const RecommendationEngine();

  List<Recommendation> rank({
    required List<CampusNetwork> networks,
    required CampusLocation location,
    required Map<String, NetworkMetrics> metricsBySsid,
  }) {
    final scored = networks
        .where((n) => n.servesBuilding(location.building))
        .map((n) {
      final m = metricsBySsid[n.ssid];
      return Recommendation(
        network: n,
        score: _score(m),
        reason: _reason(m),
      );
    })
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return scored;
  }

  double _score(NetworkMetrics? m) {
    if (m == null) return 0;
    final signal = ((m.rssi - AppConstants.minRssiDbm) /
        (AppConstants.maxRssiDbm - AppConstants.minRssiDbm))
        .clamp(0.0, 1.0);
    final latency = (1 - (m.latencyMs / AppConstants.maxAcceptableLatencyMs))
        .clamp(0.0, 1.0);
    final speed = (m.throughputMbps / AppConstants.maxExpectedThroughputMbps)
        .clamp(0.0, 1.0);
    return signal * 0.4 + latency * 0.3 + speed * 0.3;
  }

  String _reason(NetworkMetrics? m) {
    if (m == null) return 'No recent measurements';
    if (m.rssi < -80) return 'Weak signal in this building';
    return 'Strong signal, ${m.latencyMs}ms latency';
  }
}