import 'package:flutter/material.dart';

import '../artwork_store.dart';
import '../models/artwork.dart';
import '../theme_state.dart';
import '../widgets/sample_artwork.dart';
import 'account_pages.dart';

const _blue = Color(0xFF315BFF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onLogout});

  final void Function(BuildContext context)? onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _promptController = TextEditingController();
  final _styles = const ['Realistic', 'Anime', 'Watercolor', '3D'];
  int _tab = 0;
  String _style = 'Realistic';
  bool _isGenerating = false;
  bool _showSaved = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Artwork _makeArtwork(String prompt, String style) => Artwork(
    prompt: prompt,
    style: style,
    createdAt: DateTime.now(),
    seed: DateTime.now().microsecondsSinceEpoch,
  );

  void _generate() {
    final idea = _promptController.text.trim();
    if (idea.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your idea first.')),
      );
      return;
    }
    _openGenerating(_makeArtwork(idea, _style));
  }

  void _openGenerating(Artwork artwork) {
    FocusScope.of(context).unfocus();
    setState(() => _isGenerating = true);
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => GeneratingPage(
          artwork: artwork,
          onGenerated: () => ArtworkStore.addHistory(artwork),
          onEdit: () => _editArtwork(artwork),
          onRegenerate: () => _regenerateArtwork(artwork),
          onDelete: () => _deleteArtwork(artwork),
        ),
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _isGenerating = false);
    });
  }

  void _openResult(Artwork artwork) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          artwork: artwork,
          onEdit: () => _editArtwork(artwork),
          onRegenerate: () => _regenerateArtwork(artwork),
          onDelete: () => _deleteArtwork(artwork),
        ),
      ),
    );
  }

  void _editArtwork(Artwork artwork) {
    Navigator.popUntil(context, (route) => route.isFirst);
    if (!mounted) return;
    setState(() {
      _promptController.text = artwork.prompt;
      _style = artwork.style;
      _tab = 0;
    });
  }

  void _regenerateArtwork(Artwork artwork) {
    Navigator.popUntil(context, (route) => route.isFirst);
    if (!mounted) return;
    setState(() {
      _promptController.text = artwork.prompt;
      _style = artwork.style;
      _tab = 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openGenerating(_makeArtwork(artwork.prompt, artwork.style));
    });
  }

  void _deleteArtwork(Artwork artwork) {
    ArtworkStore.remove(artwork);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _improvePrompt() {
    final original = _promptController.text.trim();
    if (original.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write your idea before improving it.')),
      );
      return;
    }
    final styleDetail = switch (_style) {
      'Anime' => 'expressive anime illustration, clean line art',
      'Watercolor' => 'soft watercolor washes, delicate paper texture',
      '3D' => 'polished 3D render, dimensional lighting',
      _ => 'realistic details, natural lighting',
    };
    final improved =
        '$original, thoughtfully composed scene, $styleDetail, warm mood';
    // TODO: Replace this local prompt rule with the future prompt-improvement API.
    _promptController.value = TextEditingValue(
      text: improved,
      selection: TextSelection.collapsed(offset: improved.length),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Improved prompt added. Review and edit it below.'),
      ),
    );
  }

  void _toggleTheme() {
    appThemeMode.value = appThemeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IndexedStack(
        index: _tab,
        children: [
          _createPage(),
          _explorePage(),
          _libraryPage(),
          _profilePage(),
        ],
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (index) => setState(() => _tab = index),
      backgroundColor: Theme.of(context).colorScheme.surface,
      indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(Icons.add_circle),
          label: 'Create',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: 'Library',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );

  Widget _createPage() => ListView(
    padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    children: [
      Row(
        children: [
          const Icon(Icons.auto_awesome, color: _blue),
          const SizedBox(width: 8),
          Text(
            'Imagine AI',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          CircleAvatar(
            radius: 19,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            child: ValueListenableBuilder<String>(
              valueListenable: ArtworkStore.userName,
              builder: (context, name, _) => Text(_initials(name)),
            ),
          ),
        ],
      ),
      const SizedBox(height: 25),
      Text(
        'What do you want\nto see?',
        style: Theme.of(context).textTheme.headlineMedium
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 22),
      _sectionLabel('1', 'Describe your idea'),
      const SizedBox(height: 10),
      TextField(
        controller: _promptController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'A fox reading a book in a cozy library',
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          contentPadding: EdgeInsets.all(16),
        ),
      ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: _improvePrompt,
          icon: const Icon(Icons.auto_awesome, size: 16),
          label: const Text('Improve with AI'),
        ),
      ),
      Text(
        'The improved wording appears in the prompt box so you can edit it.',
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 22),
      _sectionLabel('2', 'Pick a style'),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children: _styles
            .map(
              (style) => ChoiceChip(
                label: Text(style),
                selected: _style == style,
                onSelected: (_) => setState(() => _style = style),
                selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Prompt tip • Add subject, setting, lighting and mood. Style words like “watercolor” change the image finish.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
      ),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: _isGenerating ? null : _generate,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate image'),
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
      ),
      ValueListenableBuilder<List<Artwork>>(
        valueListenable: ArtworkStore.history,
        builder: (context, history, _) {
          if (history.isEmpty) return const SizedBox.shrink();
          final latest = history.first;
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: InkWell(
              onTap: () => _openResult(latest),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your latest image',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SampleArtwork(seed: latest.seed),
                  const SizedBox(height: 8),
                  Text(
                    latest.prompt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );

  Widget _explorePage() => ListView(
    padding: const EdgeInsets.all(22),
    children: [
      _pageTitle('Explore', 'Try a sample idea and style.'),
      const SizedBox(height: 18),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: .72,
        children: List.generate(4, (index) {
          const ideas = [
            'Misty mountain lake',
            'Neon city at night',
            'Cozy house by the sea',
            'Spring flower bouquet',
          ];
          return InkWell(
            onTap: () => setState(() {
              _promptController.text = ideas[index];
              _style = _styles[index];
              _tab = 0;
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SampleArtwork(seed: index, radius: 18)),
                const SizedBox(height: 6),
                Text(
                  ideas[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  _styles[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    ],
  );

  Widget _libraryPage() => ValueListenableBuilder<List<Artwork>>(
    valueListenable: _showSaved ? ArtworkStore.saved : ArtworkStore.history,
    builder: (context, artworks, _) => ListView(
      padding: const EdgeInsets.all(22),
      children: [
        _pageTitle('Library', 'Your images, all in one place.'),
        const SizedBox(height: 14),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('All')),
            ButtonSegment(value: true, label: Text('Saved')),
          ],
          selected: {_showSaved},
          onSelectionChanged: (value) =>
              setState(() => _showSaved = value.first),
        ),
        const SizedBox(height: 16),
        if (artworks.isEmpty)
          _emptyState(
            _showSaved ? 'No saved images yet' : 'Your gallery is waiting',
            _showSaved
                ? 'Save an image from its result page.'
                : 'Create an image and it will appear here.',
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: artworks.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () => _openResult(artworks[index]),
              child: SampleArtwork(seed: artworks[index].seed),
            ),
          ),
      ],
    ),
  );

  Widget _profilePage() => ListView(
    padding: const EdgeInsets.all(22),
    children: [
      Row(
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Toggle light and dark mode',
            onPressed: _toggleTheme,
            icon: Icon(
              appThemeMode.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Center(
        child: CircleAvatar(
          radius: 42,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: ValueListenableBuilder<String>(
            valueListenable: ArtworkStore.userName,
            builder: (context, name, _) => Text(
              _initials(name),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      ValueListenableBuilder<String>(
        valueListenable: ArtworkStore.userName,
        builder: (context, name, _) => Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      ValueListenableBuilder<String>(
        valueListenable: ArtworkStore.username,
        builder: (context, username, _) => Center(
          child: Text(
            username,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      Center(
        child: OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          ),
          child: const Text('Edit profile'),
        ),
      ),
      const SizedBox(height: 12),
      ValueListenableBuilder<List<Artwork>>(
        valueListenable: ArtworkStore.history,
        builder: (context, history, _) => _profileRow(
          Icons.image_outlined,
          'My creations',
          '${history.length}',
          () => setState(() {
            _tab = 2;
            _showSaved = false;
          }),
        ),
      ),
      ValueListenableBuilder<List<Artwork>>(
        valueListenable: ArtworkStore.saved,
        builder: (context, saved, _) => _profileRow(
          Icons.bookmark_outline,
          'Saved images',
          '${saved.length}',
          () => setState(() {
            _tab = 2;
            _showSaved = true;
          }),
        ),
      ),
      const SizedBox(height: 12),
      _profileRow(
        Icons.palette_outlined,
        'Appearance',
        '›',
        () => _push(const AppearancePage()),
      ),
      _profileRow(
        Icons.alternate_email,
        'Change email',
        '›',
        () => _push(const ChangeEmailPage()),
      ),
      _profileRow(
        Icons.lock_outline,
        'Change password',
        '›',
        () => _push(const ChangePasswordPage()),
      ),
      _profileRow(
        Icons.help_outline,
        'Help and support',
        '›',
        () => _push(const HelpSupportPage()),
      ),
      _profileRow(Icons.logout, 'Log out', '›', _logOut),
    ],
  );

  void _push(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _logOut() {
    ArtworkStore.reset();
    widget.onLogout?.call(context);
  }

  Widget _sectionLabel(String number, String label) => Row(
    children: [
      CircleAvatar(
        radius: 11,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: Text(number, style: Theme.of(context).textTheme.labelSmall),
      ),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ],
  );

  Widget _pageTitle(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
      Text(
        subtitle,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ],
  );

  Widget _emptyState(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(top: 70),
    child: Column(
      children: [
        Icon(
          Icons.image_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 52,
        ),
        const SizedBox(height: 10),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );

  Widget _profileRow(
    IconData icon,
    String title,
    String trailing,
    VoidCallback onTap,
  ) => Card(
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: Text(
        trailing,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ),
  );

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'AI';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }
}
