import 'package:flutter/material.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

enum _TestState { idle, testing, done }

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  _TestState _state = _TestState.idle;

  // Dummy results — replace with real measurement_service output later.
  double _downloadMbps = 0;
  double _uploadMbps = 0;
  int _pingMs = 0;

  Future<void> _runTest() async {
    setState(() => _state = _TestState.testing);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _downloadMbps = 76.4;
      _uploadMbps = 24.8;
      _pingMs = 18;
      _state = _TestState.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF0F2A5C)),
        title: const Text(
          'Speed Test',
          style: TextStyle(
            color: Color(0xFF0F2A5C),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildGauge(),
              const SizedBox(height: 40),
              if (_state == _TestState.done) _buildResultsRow(),
              const Spacer(),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                  _state == _TestState.testing ? null : _runTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6EA8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _state == _TestState.testing
                        ? 'Testing...'
                        : _state == _TestState.done
                        ? 'Test Again'
                        : 'Start Test',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGauge() {
    final isTesting = _state == _TestState.testing;

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: isTesting ? null : (_state == _TestState.done ? 1 : 0),
              strokeWidth: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1B6EA8),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _state == _TestState.done
                    ? _downloadMbps.toStringAsFixed(1)
                    : '--',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F2A5C),
                ),
              ),
              const Text(
                'Mbps Download',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ResultStat(
          label: 'Upload',
          value: '${_uploadMbps.toStringAsFixed(1)} Mbps',
          icon: Icons.upload_rounded,
        ),
        _ResultStat(
          label: 'Ping',
          value: '$_pingMs ms',
          icon: Icons.speed_rounded,
        ),
      ],
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B6EA8)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F2A5C),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black45),
        ),
      ],
    );
  }
}