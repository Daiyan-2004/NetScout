import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_text_field.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _batchController = TextEditingController();

  String? _department;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _batchController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await _auth.register(
        name: _nameController.text,
        studentId: _studentIdController.text,
        email: _emailController.text,
        password: _passwordController.text,
        department: _department!,
        batch: _batchController.text,
      );
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const EmailVerificationScreen(emailJustSent: true),
        ),
            (_) => false,
      );
    } catch (e) {
      if (mounted) showAuthSnack(context, AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
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
                      'Student Registration',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Register with your university email',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 32),

                    AuthTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    AuthTextField(
                      label: 'Student ID',
                      hint: 'Enter your student ID',
                      controller: _studentIdController,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Student ID is required'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    AuthTextField(
                      label: 'University Email',
                      hint: 'name.dept.id${AuthConstants.allowedEmailDomain}',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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

                    // ---- Password field ----
                    AuthTextField(
                      label: 'Password',
                      hint:
                      'At least ${AuthConstants.minPasswordLength} characters',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        if (v.length < AuthConstants.minPasswordLength) {
                          return 'Use at least '
                              '${AuthConstants.minPasswordLength} characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // ---- Confirm Password field ----
                    AuthTextField(
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      controller: _confirmController,
                      isPassword: true,
                      validator: (v) => v != _passwordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    const AuthFieldLabel('Department'),
                    DropdownButtonFormField<String>(
                      value: _department,
                      decoration: authInputDecoration('Select your department'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: AuthConstants.departments
                          .map((d) =>
                          DropdownMenuItem<String>(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => setState(() => _department = v),
                      validator: (v) =>
                      v == null ? 'Department is required' : null,
                    ),
                    const SizedBox(height: 18),

                    AuthTextField(
                      label: 'Batch Name',
                      optional: true,
                      hint: 'e.g. Inference 54',
                      controller: _batchController,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 28),

                    AuthPrimaryButton(
                      label: 'Register',
                      loading: _loading,
                      onPressed: _register,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already registered? ',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: _goToLogin,
                          child: const Text(
                            'Login',
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