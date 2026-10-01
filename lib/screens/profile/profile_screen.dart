import 'package:flutter/material.dart';

import '../../models/student.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_text_field.dart'; // kNavy, kBlue, kBg, showAuthSnack
import '../../widgets/profile_info_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();

  Student? _student;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool showSpinner = true}) async {
    if (showSpinner) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final student = await _auth.getCurrentStudent();
      if (!mounted) return;
      setState(() {
        _student = student;
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final message = AuthService.messageFor(e);
      if (_student != null && !showSpinner) {
        // Refresh ব্যর্থ হলে আগের তথ্য রেখে শুধু বার্তা দেখাই
        showAuthSnack(context, message);
      } else {
        setState(() {
          _error = message;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: kNavy),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: kNavy,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _Message(
        icon: Icons.error_outline_rounded,
        text: _error!,
        onRetry: _load,
      );
    }
    final student = _student;
    if (student == null) {
      return _Message(
        icon: Icons.person_off_outlined,
        text: 'Profile not found.',
        onRetry: _load,
      );
    }
    return RefreshIndicator(
      onRefresh: () => _load(showSpinner: false),
      child: _ProfileBody(student: student),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final Student student;

  const _ProfileBody({required this.student});

  String get _initials {
    final parts = student.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }

  String _orDash(String value) => value.trim().isEmpty ? '—' : value;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final d = date.toLocal();
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final batch = student.batch;
    final created = student.createdAt;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      children: [
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: kBlue,
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _orDash(student.name),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kNavy,
          ),
        ),
        const SizedBox(height: 8),
        Center(child: _VerifiedBadge(verified: student.isVerified)),
        const SizedBox(height: 28),
        ProfileInfoTile(
          icon: Icons.badge_outlined,
          label: 'Student ID',
          value: _orDash(student.studentId),
        ),
        const SizedBox(height: 12),
        ProfileInfoTile(
          icon: Icons.mail_outline_rounded,
          label: 'University Email',
          value: _orDash(student.email),
        ),
        const SizedBox(height: 12),
        ProfileInfoTile(
          icon: Icons.school_outlined,
          label: 'Department',
          value: _orDash(student.department),
        ),
        if (batch != null && batch.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          ProfileInfoTile(
            icon: Icons.groups_outlined,
            label: 'Batch',
            value: batch,
          ),
        ],
        if (created != null) ...[
          const SizedBox(height: 12),
          ProfileInfoTile(
            icon: Icons.calendar_today_outlined,
            label: 'Member since',
            value: _formatDate(created),
          ),
        ],
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final bool verified;

  const _VerifiedBadge({required this.verified});

  @override
  Widget build(BuildContext context) {
    final color = verified ? const Color(0xFF1E9E5A) : const Color(0xFFE08A00);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.verified_rounded : Icons.error_outline_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            verified ? 'Verified student' : 'Email not verified',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onRetry;

  const _Message({
    required this.icon,
    required this.text,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.black38),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}