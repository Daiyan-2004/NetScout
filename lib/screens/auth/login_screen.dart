import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_text_field.dart';
import '../home/home_screen.dart';
import 'email_verification_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final verified = await _auth.signIn(
        _emailController.text,
        _passwordController.text,
      );
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>
          verified ? const HomeScreen() : const EmailVerificationScreen(),
        ),
            (_) => false,
      );
    } catch (e) {
      if (mounted) showAuthSnack(context, AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthLogo(),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Log in with your university email',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 32),

                    AuthTextField(
                      label: 'University Email',
                      hint: 'name.dept.id${AuthConstants.allowedEmailDomain}',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        final mail = v.trim().toLowerCase();
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(mail)) {
                          return 'Enter a valid email address';
                        }
                        if (!mail.endsWith(AuthConstants.allowedEmailDomain)) {
                          return 'Use your ${AuthConstants.allowedEmailDomain} email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    AuthTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) {
                        if (!_loading) _login();
                      },
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Password is required'
                          : null,
                    ),
                    const SizedBox(height: 28),

                    AuthPrimaryButton(
                      label: 'Login',
                      loading: _loading,
                      onPressed: _login,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Haven't registered yet? ",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: _goToRegister,
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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