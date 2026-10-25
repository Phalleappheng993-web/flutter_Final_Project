import 'package:flutter/material.dart';

import '../artwork_store.dart';
import '../models/artwork.dart';
import '../theme_state.dart';
import '../widgets/sample_artwork.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Appearance')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Choose how Imagine AI looks. Use the sun or moon button on your profile to switch between Light and Dark.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: appThemeMode,
          builder: (context, selected, _) => RadioGroup<ThemeMode>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) appThemeMode.value = value;
            },
            child: Column(
              children: [
                for (final mode in [
                  ThemeMode.light,
                  ThemeMode.dark,
                  ThemeMode.system,
                ])
                  Card(
                    child: RadioListTile<ThemeMode>(
                      value: mode,
                      title: Text(_modeTitle(mode)),
                      subtitle: Text(_modeSubtitle(mode)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  String _modeTitle(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System',
  };

  String _modeSubtitle(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Always light',
    ThemeMode.dark => 'Always dark',
    ThemeMode.system => 'Match your device settings',
  };
}

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Change email')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Text(
            'We will send a confirmation link to your new address.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Current email'),
          const SizedBox(height: 6),
          const TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'New email',
              border: OutlineInputBorder(),
            ),
            validator: _validEmail,
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _showNotice(context, 'Confirmation email sent.');
              }
            },
            child: const Text('Save changes'),
          ),
        ],
      ),
    ),
  );
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Change password')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New password',
              hintText: 'At least 8 characters',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value?.length ?? 0) < 8 ? 'Use at least 8 characters.' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _confirmation,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm new password',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value != _password.text ? 'Passwords do not match.' : null,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'Signed in with Google? Your password is managed by Google.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _showNotice(context, 'Password updated.');
              }
            },
            child: const Text('Save changes'),
          ),
        ],
      ),
    ),
  );
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Help and support')),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Common questions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const ExpansionTile(
          title: Text('How does Improve with AI work?'),
          children: [
            ListTile(
              title: Text(
                'It adds style-specific detail to your prompt locally, before you generate.',
              ),
            ),
          ],
        ),
        const ExpansionTile(
          title: Text('Why did my image fail?'),
          children: [
            ListTile(
              title: Text(
                'This demo uses a local sample image and does not call an image service.',
              ),
            ),
          ],
        ),
        const ExpansionTile(
          title: Text('Where are my images saved?'),
          children: [
            ListTile(
              title: Text(
                'Images and saved status stay in memory until the app is closed.',
              ),
            ),
          ],
        ),
        const ExpansionTile(
          title: Text('How do I change the style?'),
          children: [
            ListTile(
              title: Text(
                'Choose Realistic, Anime, Watercolor or 3D on the Create page.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BusyErrorPage()),
          ),
          child: const Text('Preview the busy state'),
        ),
        const SizedBox(height: 30),
        const Text('Still need help?'),
        Text(
          'Send us a message and tell us what happened.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => _showNotice(context, 'Support message form opened.'),
          child: const Text('Contact support'),
        ),
      ],
    ),
  );
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reset password')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 20),
          Text(
            'Forgot your password?',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your email and we will send you a link to reset it.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              border: OutlineInputBorder(),
            ),
            validator: _validEmail,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _showNotice(
                  context,
                  'If your account exists, a reset link will be sent.',
                );
              }
            },
            child: const Text('Send reset link'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to log in'),
          ),
        ],
      ),
    ),
  );
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  final _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: ArtworkStore.userName.value);
    _username = TextEditingController(text: ArtworkStore.username.value);
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    final username = _username.text.trim();
    if (name.isEmpty || username.isEmpty) {
      _showNotice(context, 'Name and username are required.');
      return;
    }
    ArtworkStore.updateProfile(name: name, username: username);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Edit profile'),
      actions: [TextButton(onPressed: _save, child: const Text('Save'))],
    ),
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Center(
          child: CircleAvatar(radius: 38, child: Text(_initials(_name.text))),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Full name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _username,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _bio,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Bio',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 18),
        FilledButton(onPressed: _save, child: const Text('Save changes')),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    final firstTwo = parts.take(2).map((part) => part[0].toUpperCase());
    final initials = firstTwo.join();
    return initials.isEmpty ? 'AI' : initials;
  }
}

class GeneratingPage extends StatefulWidget {
  const GeneratingPage({
    super.key,
    required this.artwork,
    required this.onGenerated,
    required this.onEdit,
    required this.onRegenerate,
    required this.onDelete,
  });

  final Artwork artwork;
  final VoidCallback onGenerated;
  final VoidCallback onEdit;
  final VoidCallback onRegenerate;
  final VoidCallback onDelete;

  @override
  State<GeneratingPage> createState() => _GeneratingPageState();
}

class _GeneratingPageState extends State<GeneratingPage> {
  int _phase = 0;

  static const _steps = [
    'Preparing your prompt',
    'Creating a local sample preview',
    'Preview ready',
  ];

  @override
  void initState() {
    super.initState();
    _runSteps();
  }

  Future<void> _runSteps() async {
    for (var index = 0; index < _steps.length; index++) {
      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      setState(() => _phase = index + 1);
    }
    if (!mounted) return;
    widget.onGenerated();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          artwork: widget.artwork,
          onEdit: widget.onEdit,
          onRegenerate: widget.onRegenerate,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close),
      ),
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.auto_awesome, size: 58),
            ),
            const SizedBox(height: 22),
            Text(
              'Creating your image',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Please keep the app open.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            CircularProgressIndicator(value: _phase / _steps.length),
            const SizedBox(height: 14),
            for (var index = 0; index < _steps.length; index++)
              ListTile(
                dense: true,
                leading: Icon(
                  index < _phase
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: index < _phase
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
                title: Text(_steps[index]),
              ),
          ],
        ),
      ),
    ),
  );
}

class BusyErrorPage extends StatelessWidget {
  const BusyErrorPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'The image service is busy',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'This demo uses a local sample image, so a real service error cannot occur yet. This screen previews the busy state from the design.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Try again'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Edit my idea'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    super.key,
    required this.artwork,
    required this.onDelete,
  });

  final Artwork artwork;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Image')),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        SampleArtwork(seed: artwork.seed),
        const SizedBox(height: 10),
        Chip(label: Text(artwork.style)),
        Text(artwork.prompt),
        const SizedBox(height: 16),
        ArtworkActionRow(artwork: artwork),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Delete image?'),
              content: const Text('This also removes it from Saved images.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    onDelete();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          label: const Text('Delete image'),
        ),
      ],
    ),
  );
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.artwork,
    required this.onEdit,
    required this.onRegenerate,
    required this.onDelete,
  });

  final Artwork artwork;
  final VoidCallback onEdit;
  final VoidCallback onRegenerate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Your image'),
      actions: [
        IconButton(
          tooltip: 'Image details',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ImageDetailPage(artwork: artwork, onDelete: onDelete),
            ),
          ),
          icon: const Icon(Icons.open_in_full),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SampleArtwork(seed: artwork.seed, radius: 22),
        const SizedBox(height: 12),
        Row(
          children: [
            Chip(label: Text(artwork.style)),
            const Spacer(),
            Text(
              '${artwork.createdAt.month}/${artwork.createdAt.day}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          'Your idea',
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(artwork.prompt),
        const SizedBox(height: 5),
        Text(
          'Style: ${artwork.style}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        ArtworkActionRow(artwork: artwork),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ImageDetailPage(artwork: artwork, onDelete: onDelete),
            ),
          ),
          icon: const Icon(Icons.info_outline),
          label: const Text('Image details'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit prompt and style'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: onRegenerate,
          icon: const Icon(Icons.refresh),
          label: const Text('Regenerate'),
        ),
      ],
    ),
  );
}

class ArtworkActionRow extends StatelessWidget {
  const ArtworkActionRow({super.key, required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: ValueListenableBuilder<List<Artwork>>(
          valueListenable: ArtworkStore.saved,
          builder: (context, saved, _) {
            final isSaved = saved.contains(artwork);
            return OutlinedButton.icon(
              onPressed: () => ArtworkStore.toggleSaved(artwork),
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
              label: Text(isSaved ? 'Saved' : 'Save'),
            );
          },
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () {
            // TODO: Connect a platform file download when generated image bytes are available.
            _showNotice(
              context,
              'Download is a UI demo until image files are available.',
            );
          },
          icon: const Icon(Icons.download_outlined),
          label: const Text('Download'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () {
            // TODO: Connect the device share sheet when image bytes are available.
            _showNotice(
              context,
              'Share is a UI demo until image files are available.',
            );
          },
          icon: const Icon(Icons.share_outlined),
          label: const Text('Share'),
        ),
      ),
    ],
  );
}

String? _validEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email is required.';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null;
}

void _showNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
