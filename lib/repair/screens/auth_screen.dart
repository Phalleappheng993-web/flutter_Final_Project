import 'package:flutter/material.dart';

import '../artwork_store.dart';
import 'home_screen.dart';
import 'account_pages.dart';

const _brandBlue = Color(0xFF315BFF);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  static const _headlines = [
    'Describe what you imagine',
    'Pick a style',
    'Get your image in seconds',
  ];
  static const _descriptions = [
    'Type a sentence like “a fox reading in a library”. No art skills needed.',
    'Realistic, anime, watercolor or 3D. The style changes how your image looks.',
    'Improve your words first, so the picture matches your idea.',
  ];

  void _openAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _openAuth,
                      child: const Text('Skip'),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(
                      [
                        Icons.short_text,
                        Icons.palette_outlined,
                        Icons.image_outlined,
                      ][_step],
                      color: _brandBlue,
                      size: 96,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Chip(label: Text('Step ${_step + 1} of 3')),
                  const SizedBox(height: 8),
                  Text(
                    _headlines[_step],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(_descriptions[_step], textAlign: TextAlign.center),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.all(3),
                        width: index == _step ? 18 : 6,
                        height: 5,
                        decoration: BoxDecoration(
                          color: index == _step
                              ? _brandBlue
                              : Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _step < 2
                          ? () => setState(() => _step++)
                          : _openAuth,
                      child: Text(_step < 2 ? 'Next' : 'Get started'),
                    ),
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

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _signUp = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    if (_signUp) {
      final enteredName = _nameController.text.trim();
      final name = enteredName.isEmpty ? email.split('@').first : enteredName;
      ArtworkStore.updateProfile(
        name: name,
        username: name.toLowerCase().replaceAll(' ', ''),
      );
    } else if (ArtworkStore.userName.value == 'Alex Carter') {
      ArtworkStore.updateProfile(
        name: email.split('@').first,
        username: email.split('@').first,
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(onLogout: _openLoginAfterLogout),
      ),
    );
  }

  void _openLoginAfterLogout(BuildContext homeContext) {
    Navigator.of(homeContext).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Icon(Icons.auto_awesome, color: _brandBlue, size: 42),
                  const SizedBox(height: 18),
                  Text(
                    'Welcome to Imagine AI',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save your images and find them on any device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('Log in')),
                      ButtonSegment(value: true, label: Text('Sign up')),
                    ],
                    selected: {_signUp},
                    onSelectionChanged: (selection) =>
                        setState(() => _signUp = selection.first),
                  ),
                  const SizedBox(height: 18),
                  if (_signUp) ...[
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          _signUp && (value?.trim().isEmpty ?? true)
                          ? 'Full name is required.'
                          : null,
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'At least 8 characters',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value?.length ?? 0) < 8
                        ? 'Password must be at least 8 characters.'
                        : null,
                  ),
                  if (!_signUp)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        ),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: _continue,
                      child: Text(_signUp ? 'Create account' : 'Continue'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HomeScreen(onLogout: _openLoginAfterLogout),
                      ),
                    ),
                    child: const Text('Continue with Google'),
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
