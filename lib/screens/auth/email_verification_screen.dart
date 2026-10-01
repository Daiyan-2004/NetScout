import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_text_field.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  /// Registration থেকে এলে true (email এইমাত্র গেছে, তাই Resend-এ cooldown থাকবে)
  final bool emailJustSent;

  const EmailVerificationScreen({super.key, this.emailJustSent = false});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _auth = AuthService();

  Timer? _pollTimer;
  Timer? _cooldownTimer;
  int _cooldown = 0;
  bool _checking = false;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(
      const Duration(seconds: AuthConstants.verifyCheckIntervalSeconds),
          (_) => _check(silent: true),
    );
    if (widget.emailJustSent) {
      _cooldown = AuthConstants.resendCooldownSeconds;
      _runCooldown();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _runCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_cooldown <= 1) {
        t.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  Future<void> _check({bool silent = false}) async {
    if (_checking) return;
    if (silent) {
      _checking = true;
    } else {
      setState(() => _checking = true);
    }

    try {
      final verified = await _auth.refreshVerified();
      if (!mounted) return;

      if (verified) {
        _pollTimer?.cancel();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
              (_) => false,
        );
        return;
      }
      if (!silent) {
        showAuthSnack(
          context,
          'Email is not verified yet. Check your inbox and spam folder.',
        );
      }
    } catch (e) {
      if (!silent && mounted) {
        showAuthSnack(context, AuthService.messageFor(e));
      }
    } finally {
      if (mounted && !silent) {
        setState(() => _checking = false);
      } else {
        _checking = false;
      }
    }
  }

  Future<void> _resend() async {
    if (_cooldown > 0 || _resending) return;
    setState(() => _resending = true);
    try {
      await _auth.resendVerificationEmail();
      if (!mounted) return;
      showAuthSnack(context, 'Verification email sent again.', error: false);
      setState(() => _cooldown = AuthConstants.resendCooldownSeconds);
      _runCooldown();
    } catch (e) {
      if (mounted) showAuthSnack(context, AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _backToLogin() async {
    _pollTimer?.cancel();
    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _auth.currentUser?.email ?? '';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _backToLogin();
      },
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          backgroundColor: kBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: kNavy),
            onPressed: _backToLogin,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 80,
                      color: kBlue,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Verify your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We sent a verification link to\n$email\n\n'
                          'Open the link, then come back here. '
                          'Also check your spam folder.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 32),
                    AuthPrimaryButton(
                      label: "I've verified my email",
                      loading: _checking,
                      onPressed: () => _check(),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: (_cooldown > 0 || _resending) ? null : _resend,
                      child: Text(
                        _cooldown > 0
                            ? 'Resend email (${_cooldown}s)'
                            : 'Resend email',
                      ),
                    ),
                    TextButton(
                      onPressed: _backToLogin,
                      child: const Text('Back to login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}