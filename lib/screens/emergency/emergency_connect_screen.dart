import 'package:flutter/material.dart';

class EmergencyConnectScreen extends StatefulWidget {
  const EmergencyConnectScreen({super.key});

  @override
  State<EmergencyConnectScreen> createState() =>
      _EmergencyConnectScreenState();
}

enum _ConnectionState { idle, connecting, connected }

class _EmergencyConnectScreenState extends State<EmergencyConnectScreen>
    with SingleTickerProviderStateMixin {
  _ConnectionState _state = _ConnectionState.idle;

  late final AnimationController _pulseController;

  // Dummy data — replace with real emergency network results later.
  final List<_EmergencyNetwork> _networks = const [
    _EmergencyNetwork(
      name: 'Campus-Emergency-Net',
      signalPercent: 92,
      isRecommended: true,
    ),
    _EmergencyNetwork(
      name: 'Security-Office-WiFi',
      signalPercent: 74,
      isRecommended: false,
    ),
    _EmergencyNetwork(
      name: 'Admin-Backup-Net',
      signalPercent: 58,
      isRecommended: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _connect() async {
    setState(() => _state = _ConnectionState.connecting);

    // TODO: replace with real connection logic
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _state = _ConnectionState.connected);
  }

  @override
  Widget build(BuildContext context) {
    final recommended = _networks.firstWhere((n) => n.isRecommended);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF0F2A5C)),
        title: const Text(
          'Emergency Connect',
          style: TextStyle(
            color: Color(0xFF0F2A5C),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    _buildStatusHeader(),
                    const SizedBox(height: 28),
                    _buildRecommendedCard(recommended),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Other available emergency networks',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.55),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._networks
                        .where((n) => !n.isRecommended)
                        .map((n) => _AlternateNetworkTile(network: n)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _buildActionButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    String title;
    String subtitle;
    Color color;

    switch (_state) {
      case _ConnectionState.idle:
        title = 'Emergency Mode';
        subtitle = 'We found the strongest network available near you';
        color = const Color(0xFFE23E3E);
        break;
      case _ConnectionState.connecting:
        title = 'Connecting...';
        subtitle = 'Please wait while we connect you securely';
        color = const Color(0xFF1B6EA8);
        break;
      case _ConnectionState.connected:
        title = 'Connected';
        subtitle = 'You are now connected to an emergency network';
        color = const Color(0xFF1FA35A);
        break;
    }

    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = _state == _ConnectionState.connecting
                ? 1.0 + (_pulseController.value * 0.12)
                : 1.0;
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _state == _ConnectionState.connected
                  ? Icons.check_rounded
                  : Icons.bolt_rounded,
              color: color,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(_EmergencyNetwork network) {
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
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1F8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.wifi_rounded, color: Color(0xFF1B6EA8)),
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
                        network.name,
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
                        'Best Match',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1FA35A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Signal strength: ${network.signalPercent}%',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final isConnecting = _state == _ConnectionState.connecting;
    final isConnected = _state == _ConnectionState.connected;

    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isConnecting || isConnected ? null : _connect,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isConnected ? const Color(0xFF1FA35A) : const Color(0xFFE23E3E),
          disabledBackgroundColor:
          isConnected ? const Color(0xFF1FA35A) : const Color(0xFFE23E3E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: isConnecting
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          isConnected ? 'Connected' : 'Connect Now',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AlternateNetworkTile extends StatelessWidget {
  final _EmergencyNetwork network;

  const _AlternateNetworkTile({required this.network});

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
          const Icon(Icons.wifi_rounded, color: Color(0xFF1B6EA8), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              network.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F2A5C),
              ),
            ),
          ),
          Text(
            '${network.signalPercent}%',
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _EmergencyNetwork {
  final String name;
  final int signalPercent;
  final bool isRecommended;

  const _EmergencyNetwork({
    required this.name,
    required this.signalPercent,
    required this.isRecommended,
  });
}