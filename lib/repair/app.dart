import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/account_pages.dart';
import 'theme_state.dart';

class ImagineAiApp extends StatelessWidget {
  const ImagineAiApp({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: appThemeMode,
        builder: (_, mode, __) => MaterialApp(
          title: 'Imagine AI', debugShowCheckedModeBanner: false, themeMode: mode,
          theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFFAFAFC), colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315BFF)), fontFamily: 'Roboto'),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6F89FF), brightness: Brightness.dark), fontFamily: 'Roboto'),
          home: const OnboardingScreen(),
        ),
      );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}
class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;
  final headlines = ['Describe what you imagine', 'Pick a style', 'Get your image in seconds'];
  final copy = ['Type a sentence like “a fox reading in a library”. No art skills needed.', 'Realistic, anime, watercolor or 3D. The style changes how your image looks.', 'AI can improve your words first, so the picture matches your idea.'];
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 12, 24, 24), child: Column(children: [Align(alignment: Alignment.centerRight, child: TextButton(onPressed: openAuth, child: const Text('Skip'))), const Spacer(), Container(height: 230, width: 230, decoration: BoxDecoration(color: const Color(0xFFE3EAFE), borderRadius: BorderRadius.circular(35)), child: Icon([Icons.short_text, Icons.palette_outlined, Icons.image_outlined][step], color: const Color(0xFF315BFF), size: 100)), const SizedBox(height: 22), Chip(label: Text('Step ${step + 1} of 3'), backgroundColor: const Color(0xFFFFE66D)), const SizedBox(height: 8), Text(headlines[step], textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 12), Text(copy[step], textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)), const Spacer(), Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => Container(margin: const EdgeInsets.all(3), width: i == step ? 18 : 6, height: 5, decoration: BoxDecoration(color: i == step ? const Color(0xFF315BFF) : Colors.black12, borderRadius: BorderRadius.circular(8))))), const SizedBox(height: 12), SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: step < 2 ? () => setState(() => step++) : openAuth, style: FilledButton.styleFrom(backgroundColor: const Color(0xFF315BFF)), child: Text(step < 2 ? 'Next' : 'Get started')))]))));
  void openAuth() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  bool signup = false;
  bool reset = false;
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [const SizedBox(height: 38), const Icon(Icons.auto_awesome, color: Color(0xFF315BFF), size: 42), const SizedBox(height: 20), Text(reset ? 'Forgot your password?' : 'Welcome to Imagine AI', textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(reset ? 'Enter your email and we will send you a reset link.' : 'Save your images and find them on any device.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)), const SizedBox(height: 30), if (!reset) SegmentedButton<bool>(segments: const [ButtonSegment(value: false, label: Text('Log in')), ButtonSegment(value: true, label: Text('Sign up'))], selected: {signup}, onSelectionChanged: (v) => setState(() => signup = v.first)), if (signup && !reset) const SizedBox(height: 18), if (signup && !reset) const TextField(decoration: InputDecoration(labelText: 'Full name', border: OutlineInputBorder())), if (signup && !reset) const SizedBox(height: 14), const TextField(decoration: InputDecoration(labelText: 'Email', hintText: 'you@example.com', border: OutlineInputBorder())), if (!reset) ...[const SizedBox(height: 14), const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', hintText: 'Enter your password', border: OutlineInputBorder()))], const SizedBox(height: 10), if (!signup && !reset) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())), child: const Text('Forgot password?'))), const SizedBox(height: 10), SizedBox(height: 50, child: FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF315BFF)), child: Text(reset ? 'Send reset link' : signup ? 'Create account' : 'Continue'))), if (!reset) ...[const SizedBox(height: 18), const Center(child: Text('or')), const SizedBox(height: 12), OutlinedButton.icon(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())), icon: const Icon(Icons.g_mobiledata), label: const Text('Continue with Google'))], if (reset) TextButton(onPressed: () => setState(() => reset = false), child: const Text('Back to log in'))])));
}





