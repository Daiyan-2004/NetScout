import 'campus_network.dart';

class Recommendation {
  final CampusNetwork network;
  final double score; // 0.0 - 1.0
  final String reason;

  const Recommendation({
    required this.network,
    required this.score,
    required this.reason,
  });
}