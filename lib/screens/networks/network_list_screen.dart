import 'package:flutter/material.dart';

class NetworkListScreen extends StatelessWidget {
  final String regionName;

  const NetworkListScreen({super.key, required this.regionName});

  // Dummy data — replace with real scan results from services later.
  List<_WifiNetwork> get _networks => const [
    _WifiNetwork(
      ssid: 'Campus-Secure',
      band: '5GHz',
      security: 'WPA2-Enterprise',
      signalPercent: 88,
      isRecommended: true,
    ),
    _WifiNetwork(
      ssid: 'Campus-Guest',
      band: '2.4GHz',
      security: 'Open',
      signalPercent: 65,
      isRecommended: false,
    ),
    _WifiNetwork(
      ssid: 'Library-Study-Net',
      band: '5GHz',
      security: 'WPA2-Personal',
      signalPercent: 54,
      isRecommended: false,
    ),
    _WifiNetwork(
      ssid: 'Faculty-Only',
      band: '5GHz',
      security: 'WPA3-Enterprise',
      signalPercent: 30,
      isRecommended: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final recommended = _networks.firstWhere(
          (n) => n.isRecommended,
      orElse: () => _networks.first,
    );
    final others = _networks.where((n) => n != recommended).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF0F2A5C)),
        title: Text(
          regionName,
          style: const TextStyle(
            color: Color(0xFF0F2A5C),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Text(
              '${_networks.length} networks found here',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            _RecommendedNetworkCard(network: recommended),
            const SizedBox(height: 20),
            const Text(
              'Other available networks',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F2A5C),
              ),
            ),
            const SizedBox(height: 12),
            ...others.map((n) => _NetworkTile(network: n)),
          ],
        ),
      ),
    );
  }
}

class _RecommendedNetworkCard extends StatelessWidget {
  final _WifiNetwork network;

  const _RecommendedNetworkCard({required this.network});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B6EA8), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _SignalIcon(percent: network.signalPercent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            network.ssid,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F2A5C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1FA35A).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1FA35A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${network.band} · ${network.security}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Signal ${network.signalPercent}%',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const Spacer(),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: hook up actual connect logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6EA8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Connect',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetworkTile extends StatelessWidget {
  final _WifiNetwork network;

  const _NetworkTile({required this.network});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _SignalIcon(percent: network.signalPercent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  network.ssid,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F2A5C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${network.band} · ${network.security}',
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
          Text(
            '${network.signalPercent}%',
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {
              // TODO: hook up actual connect logic
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1B6EA8),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: const Text(
              'Connect',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalIcon extends StatelessWidget {
  final int percent;
  final double size;

  const _SignalIcon({required this.percent, this.size = 24});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    if (percent >= 70) {
      icon = Icons.wifi_rounded;
      color = const Color(0xFF1FA35A);
    } else if (percent >= 40) {
      icon = Icons.wifi_2_bar_rounded;
      color = const Color(0xFFDB9B27);
    } else {
      icon = Icons.wifi_1_bar_rounded;
      color = const Color(0xFFE23E3E);
    }

    return Icon(icon, color: color, size: size);
  }
}

class _WifiNetwork {
  final String ssid;
  final String band;
  final String security;
  final int signalPercent;
  final bool isRecommended;

  const _WifiNetwork({
    required this.ssid,
    required this.band,
    required this.security,
    required this.signalPercent,
    required this.isRecommended,
  });
}