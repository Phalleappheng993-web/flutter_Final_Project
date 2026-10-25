import 'package:flutter/material.dart';
import '../models/artwork.dart';
import '../theme_state.dart';
import '../widgets/sample_artwork.dart';

const _blue = Color(0xFF315BFF);

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Appearance')), body: ListView(padding: const EdgeInsets.all(20), children: [const Text('Choose how Imagine AI looks. The quick sun and moon button on your profile switches between Light and Dark.', style: TextStyle(color: Colors.grey)), const SizedBox(height: 18), for (final mode in [ThemeMode.light, ThemeMode.dark, ThemeMode.system]) ValueListenableBuilder<ThemeMode>(valueListenable: appThemeMode, builder: (context, selected, _) => Card(child: RadioListTile<ThemeMode>(value: mode, groupValue: selected, title: Text(mode.name[0].toUpperCase() + mode.name.substring(1)), subtitle: Text(switch(mode) { ThemeMode.light => 'Always light', ThemeMode.dark => 'Always dark', _ => 'Match your device settings' }), onChanged: (value) { if (value != null) appThemeMode.value = value; }))) ]));
}

class ChangeEmailPage extends StatelessWidget {
  const ChangeEmailPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Change email')), body: ListView(padding: const EdgeInsets.all(22), children: [const Text('We will send a confirmation link to your new address. Your email changes when you verify it.', style: TextStyle(color: Colors.grey)), const SizedBox(height: 20), const Text('Current email'), const SizedBox(height: 6), const TextField(enabled: false, decoration: InputDecoration(hintText: 'alex@example.com', filled: true, border: OutlineInputBorder())), const SizedBox(height: 16), const Text('New email'), const SizedBox(height: 6), const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(hintText: 'new@example.com', border: OutlineInputBorder())), const SizedBox(height: 22), FilledButton(onPressed: () => _notice(context, 'Confirmation email sent.'), child: const Text('Save changes'))]));
}

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Change password')), body: ListView(padding: const EdgeInsets.all(22), children: [const Text('New password'), const SizedBox(height: 6), const TextField(obscureText: true, decoration: InputDecoration(hintText: 'At least 8 characters', border: OutlineInputBorder())), const SizedBox(height: 16), const Text('Confirm new password'), const SizedBox(height: 6), const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Type it again', border: OutlineInputBorder())), const SizedBox(height: 16), const Card(child: Padding(padding: EdgeInsets.all(14), child: Text('Signed in with Google? Your password is managed by Google, so it cannot be changed here.'))), const SizedBox(height: 20), FilledButton(onPressed: () => _notice(context, 'Password updated.'), child: const Text('Save changes'))]));
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Help and support')), body: ListView(padding: const EdgeInsets.all(18), children: [const Text('Common questions', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), const ExpansionTile(title: Text('How does Improve with AI work?'), children: [Padding(padding: EdgeInsets.all(14), child: Text('It rewrites your idea with more detail about the subject, setting, and mood before generation.'))]), const ExpansionTile(title: Text('Why did my image fail?'), children: [Padding(padding: EdgeInsets.all(14), child: Text('The image service may be busy or your connection may have stopped. Try again in a moment.'))]), const ExpansionTile(title: Text('Where are my images saved?'), children: [Padding(padding: EdgeInsets.all(14), child: Text('Generated images appear in Library. Connect cloud storage to sync across devices.'))]), const ExpansionTile(title: Text('How do I change the style?'), children: [Padding(padding: EdgeInsets.all(14), child: Text('Choose Realistic, Anime, Watercolor, or 3D on the Create page before generating.'))]), const SizedBox(height: 22), OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BusyErrorPage())), child: const Text('Preview image service busy screen')), const SizedBox(height: 42), const Text('Still need help?'), const Text('Send us a message and tell us what happened.', style: TextStyle(color: Colors.grey)), const SizedBox(height: 10), OutlinedButton(onPressed: () => _notice(context, 'Support message form opened.'), child: const Text('Contact support'))]));
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Reset password')), body: ListView(padding: const EdgeInsets.all(22), children: [const SizedBox(height: 26), const Text('Forgot your password?', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Enter your email and we will send you a link to reset it.', style: TextStyle(color: Colors.grey)), const SizedBox(height: 22), const Text('Email'), const SizedBox(height: 6), const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(hintText: 'you@example.com', border: OutlineInputBorder())), const SizedBox(height: 18), FilledButton(onPressed: () => _notice(context, 'If your account exists, a reset link will be sent.'), child: const Text('Send reset link'))]));
}

class GeneratingPage extends StatefulWidget {
  const GeneratingPage({super.key, required this.artwork});
  final Artwork artwork;
  @override
  State<GeneratingPage> createState() => _GeneratingPageState();
}
class _GeneratingPageState extends State<GeneratingPage> {
  int phase = 0;
  @override
  void initState() { super.initState(); _run(); }
  Future<void> _run() async { for (var i = 0; i < 3; i++) { await Future<void>.delayed(const Duration(milliseconds: 600)); if (!mounted) return; setState(() => phase = i + 1); } if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(artwork: widget.artwork))); }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))), body: Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 150, height: 150, decoration: BoxDecoration(color: const Color(0xFFE3EAFE), borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.auto_awesome, size: 58, color: _blue)), const SizedBox(height: 22), const Text('Creating your image', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const Text('Please keep the app open.', style: TextStyle(color: Colors.grey)), const SizedBox(height: 20), for (var i = 0; i < 3; i++) ListTile(dense: true, leading: Icon(i < phase ? Icons.check_circle : Icons.radio_button_unchecked, color: i < phase ? _blue : Colors.grey), title: Text(['Improving your prompt', 'Generating the image', 'Saving to your library'][i]))]))));
}

class BusyErrorPage extends StatelessWidget {
  const BusyErrorPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(26), child: Column(mainAxisSize: MainAxisSize.min, children: [const CircleAvatar(radius: 34, backgroundColor: Color(0xFFFFE1DC), child: Icon(Icons.warning_amber_rounded, color: Color(0xFFC04A3B))), const SizedBox(height: 18), const Text('The image service is busy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Many people are creating images right now. Wait a minute, then try again. Your idea is still saved.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)), const SizedBox(height: 20), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Try again')), const SizedBox(height: 8), OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Edit my idea'))])))));
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({super.key, required this.artwork});
  final Artwork artwork;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Image')), body: ListView(padding: const EdgeInsets.all(18), children: [SampleArtwork(seed: artwork.seed), const SizedBox(height: 10), Chip(label: Text(artwork.style)), Text(artwork.prompt), const SizedBox(height: 16), Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () => _notice(context, 'Saved to your library.'), icon: const Icon(Icons.bookmark_border), label: const Text('Save'))), const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: () => _notice(context, 'Download started.'), icon: const Icon(Icons.download_outlined), label: const Text('Download'))), const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: () => _notice(context, 'Ready to share.'), icon: const Icon(Icons.share_outlined), label: const Text('Share')))]), const SizedBox(height: 14), OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.delete_outline, color: Colors.red), label: const Text('Delete image'))]));
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.artwork});
  final Artwork artwork;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Your image'), actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ImageDetailPage(artwork: artwork))), icon: const Icon(Icons.open_in_full))]), body: ListView(padding: const EdgeInsets.all(20), children: [SampleArtwork(seed: artwork.seed, radius: 22), const SizedBox(height: 12), Row(children: [Chip(label: Text(artwork.style)), const Spacer(), Text('${artwork.createdAt.month}/${artwork.createdAt.day}')]), const Text('Your idea', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(artwork.prompt), const SizedBox(height: 5), Text('Style: ${artwork.style}', style: const TextStyle(color: Colors.grey)), const SizedBox(height: 18), Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to your library.'))), icon: const Icon(Icons.bookmark_outline), label: const Text('Save'))), const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download started.'))), icon: const Icon(Icons.download_outlined), label: const Text('Download'))), const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ready to share.'))), icon: const Icon(Icons.share_outlined), label: const Text('Share')))]), const SizedBox(height: 12), OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ImageDetailPage(artwork: artwork))), icon: const Icon(Icons.info_outline), label: const Text('Image details')), const SizedBox(height: 8), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.refresh), label: const Text('Edit and regenerate')))]));
}

void _notice(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));


