import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _autoConnect = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF0F2A5C)),
        title: const Text(
          'Settings',
          style: TextStyle(
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
            _SectionLabel('Preferences'),
            _SettingsCard(
              children: [
                _SwitchRow(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  value: _notificationsEnabled,
                  onChanged: (v) =>
                      setState(() => _notificationsEnabled = v),
                ),
                _SwitchRow(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
                _SwitchRow(
                  icon: Icons.wifi_tethering_rounded,
                  label: 'Auto-connect to best network',
                  value: _autoConnect,
                  onChanged: (v) => setState(() => _autoConnect = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionLabel('Account'),
            _SettingsCard(
              children: [
                _NavRow(
                  icon: Icons.lock_outline_rounded,
                  label: 'Privacy & Security',
                  onTap: () {},
                ),
                _NavRow(
                  icon: Icons.info_outline_rounded,
                  label: 'About NetScout',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: hook up logout logic
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE23E3E),
                  side: const BorderSide(color: Color(0xFFE23E3E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black45,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1B6EA8)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F2A5C),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF1B6EA8),
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20, color: const Color(0xFF1B6EA8)),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0F2A5C),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
      onTap: onTap,
    );
  }
}