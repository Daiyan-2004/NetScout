import 'package:flutter/material.dart';

class MyNetworksScreen extends StatelessWidget {
  const MyNetworksScreen({super.key});

  // Dummy data — replace with real saved/history data later.
  List<_SavedNetwork> get _networks => const [
    _SavedNetwork(
      ssid: 'Campus-Secure',
      region: 'Library Hall',
      lastConnected: '2 hours ago',
      isCurrentlyConnected: true,
    ),
    _SavedNetwork(
      ssid: 'CSE-Lab-Net',
      region: 'CSE Lab 1',
      lastConnected: 'Yesterday',
      isCurrentlyConnected: false,
    ),
    _SavedNetwork(
      ssid: 'Cafeteria-WiFi',
      region: 'Cafeteria',
      lastConnected: '3 days ago',
      isCurrentlyConnected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF0F2A5C)),
        title: const Text(
          'My Networks',
          style: TextStyle(
            color: Color(0xFF0F2A5C),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          itemCount: _networks.length,
          itemBuilder: (context, index) => _SavedNetworkTile(
            network: _networks[index],
          ),
        ),
      ),
    );
  }
}

class _SavedNetworkTile extends StatelessWidget {
  final _SavedNetwork network;

  const _SavedNetworkTile({required this.network});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: network.isCurrentlyConnected
            ? Border.all(color: const Color(0xFF1FA35A), width: 1.2)
            : null,
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.wifi_rounded, color: Color(0xFF1B6EA8)),
          ),
          const SizedBox(width: 12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F2A5C),
                        ),
                      ),
                    ),
                    if (network.isCurrentlyConnected) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1FA35A).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Connected',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1FA35A),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${network.region} · ${network.lastConnected}',
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.black38, size: 20),
            onPressed: () {
              // TODO: hook up forget network logic
            },
          ),
        ],
      ),
    );
  }
}

class _SavedNetwork {
  final String ssid;
  final String region;
  final String lastConnected;
  final bool isCurrentlyConnected;

  const _SavedNetwork({
    required this.ssid,
    required this.region,
    required this.lastConnected,
    required this.isCurrentlyConnected,
  });
}