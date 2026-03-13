import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/config/app_config.dart';
import 'package:habitz/features/auth/providers/auth_provider.dart';
import 'package:habitz/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _appLinks = AppLinks();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  StreamSubscription<Uri>? _linkSubscription;
  bool _isRegister = true;
  bool _submitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _listenForAuthLinks();
  }

  Future<void> _listenForAuthLinks() async {
    final initialUri = await _appLinks.getInitialAppLink();
    if (initialUri != null) {
      await _handleIncomingUri(initialUri);
    }
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      await _handleIncomingUri(uri);
    });
  }

  Future<void> _handleIncomingUri(Uri uri) async {
    final source = uri.fragment.isEmpty ? uri.query : uri.fragment;
    if (source.isEmpty) return;
    final fragment = Uri.splitQueryString(source);
    final sessionId = fragment['session_id'];
    if (sessionId == null || sessionId.isEmpty) return;
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    await ref.read(authControllerProvider.notifier).completeGoogleSignIn(sessionId);
    final authState = ref.read(authControllerProvider);
    if (!mounted) return;
    authState.whenOrNull(
      data: (session) {
        if (session != null) {
          context.go('/onboarding');
        } else {
          setState(() {
            _submitting = false;
            _errorText = 'Google sign-in did not return a valid session.';
          });
        }
      },
      error: (error, _) {
        setState(() {
          _errorText = error.toString().replaceFirst('Exception: ', '');
          _submitting = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    authState.whenOrNull(data: (session) {
      if (session != null && !_submitting) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.go('/onboarding');
        });
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 800;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: isCompact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _heroSection(),
                          const SizedBox(height: 20),
                          _formSection(authState),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _heroSection()),
                          const SizedBox(width: 20),
                          SizedBox(width: 420, child: _formSection(authState)),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _heroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111B12), Color(0xFF08100C)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'HABITZ MOBILE SYSTEM',
              style: TextStyle(
                color: AppTheme.accent,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Train with a plan that actually matches you.',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'Habitz now personalizes your plan library, workouts, habits, and dashboard from the onboarding choices you make on mobile.',
            style: TextStyle(color: AppTheme.textSecondary, height: 1.55),
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: AspectRatio(
              aspectRatio: 1.15,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture.asset(
                    'assets/images/workout_splash_3.svg',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0x9A040706)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.46),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'MOVE • RECOVER • REPEAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt_rounded, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FeatureChip(label: 'Email + Google sign-in'),
              _FeatureChip(label: 'Personalized workout plans'),
              _FeatureChip(label: 'Habit streak tracking'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formSection(AsyncValue<dynamic> authState) {
    final busy = authState.isLoading || _submitting;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _ModeButton(
                    label: 'Create account',
                    selected: _isRegister,
                    onTap: () => setState(() => _isRegister = true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ModeButton(
                    label: 'Sign in',
                    selected: !_isRegister,
                    onTap: () => setState(() => _isRegister = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _isRegister ? 'Create your mobile account' : 'Welcome back',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _isRegister
                  ? 'Save your progress and generate your personalized Habitz system.'
                  : 'Pick up where you left off on your habits and training.',
              style: const TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 22),
            if (_isRegister) ...[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => (value == null || value.trim().length < 2)
                    ? 'Enter your name'
                    : null,
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => (value == null || !value.contains('@'))
                  ? 'Enter a valid email'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => (value == null || value.length < 8)
                  ? 'Minimum 8 characters'
                  : null,
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0x26FF6B6B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
              onPressed: busy ? null : _submit,
              child: Text(busy ? 'Please wait...' : _isRegister ? 'Create account' : 'Sign in'),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'or continue with Google',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                minimumSize: const Size.fromHeight(54),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
              onPressed: busy ? null : _continueWithGoogle,
              icon: const Icon(Icons.shield_outlined),
              label: const Text('Continue with Google'),
            ),
            const SizedBox(height: 16),
            Text(
              'Using backend: ${AppConfig.apiBaseUrl}',
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    try {
      if (_isRegister) {
        await ref.read(authControllerProvider.notifier).register(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      } else {
        await ref.read(authControllerProvider.notifier).login(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      }
      final authState = ref.read(authControllerProvider);
      final error = authState.asError?.error;
      if (error != null) {
        setState(() {
          _errorText = error.toString().replaceFirst('Exception: ', '');
        });
        return;
      }
      if (!mounted) return;
      context.go('/onboarding');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final launched = await launchUrl(
      AppConfig.googleAuthUri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      setState(() {
        _submitting = false;
        _errorText = 'Unable to open Google sign-in.';
      });
    }
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : AppTheme.cardSoft,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.black : AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
