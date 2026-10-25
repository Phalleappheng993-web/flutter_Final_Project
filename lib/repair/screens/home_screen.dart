import 'package:flutter/material.dart';
import '../theme_state.dart';
import '../models/artwork.dart';
import '../widgets/sample_artwork.dart';
import 'account_pages.dart';

const blue = Color(0xFF315BFF);
const muted = Color(0xFF85899B);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  String style = 'Realistic';
  final prompt = TextEditingController();
  final history = <Artwork>[];
  Artwork? selected;
  bool enhance = false;
  bool busy = false;
  final styles = const ['Realistic', 'Anime', 'Watercolor', '3D'];

  void generate() {
    if (prompt.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe your idea first.')));
      return;
    }
    setState(() {
      busy = true;
      final idea = prompt.text.trim();
      selected = Artwork(prompt: enhance ? '$idea, detailed composition, vivid lighting' : idea, style: style, createdAt: DateTime.now(), seed: DateTime.now().millisecondsSinceEpoch);
      history.insert(0, selected!);
      tab = 0;
    });
    Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratingPage(artwork: selected!))).then((_) { if (mounted) setState(() => busy = false); });
  }

  @override
  void dispose() { prompt.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: IndexedStack(index: tab, children: [createPage(), explorePage(), libraryPage(), profilePage()])),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: const Color(0xFFE8EDFF),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Create'),
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
            NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Library'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );

  Widget createPage() => ListView(padding: const EdgeInsets.fromLTRB(22, 20, 22, 24), children: [
    Row(children: [const Icon(Icons.auto_awesome, color: blue), const SizedBox(width: 8), Text('Imagine AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Theme.of(context).colorScheme.onSurface)), const Spacer(), CircleAvatar(radius: 19, backgroundColor: const Color(0xFFFFE66D), child: Text('AC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))]),
    const SizedBox(height: 25), Text('What do you want\nto see?', style: TextStyle(fontSize: 31, height: 1.12, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
    const SizedBox(height: 22), sectionLabel('1', 'Describe your idea'), const SizedBox(height: 10),
    TextField(controller: prompt, maxLines: 4, decoration: InputDecoration(hintText: 'A fox reading a book in a cozy library', filled: true, fillColor: Theme.of(context).colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFFE7E8ED))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFFE7E8ED))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: blue)), contentPadding: const EdgeInsets.all(16))),
    const SizedBox(height: 10), Align(alignment: Alignment.centerLeft, child: OutlinedButton.icon(onPressed: () => setState(() => enhance = !enhance), icon: Icon(enhance ? Icons.auto_awesome : Icons.auto_awesome_outlined, size: 16), label: Text(enhance ? 'AI enhancement on' : 'Improve with AI'), style: OutlinedButton.styleFrom(foregroundColor: blue, side: const BorderSide(color: Color(0xFFCAD4FF)), shape: const StadiumBorder()))),
    Text('Add subject, setting, lighting, and mood for more control.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
    const SizedBox(height: 24), sectionLabel('2', 'Pick a style'), const SizedBox(height: 12),
    Wrap(spacing: 9, runSpacing: 9, children: styles.map((s) => ChoiceChip(label: Text(s), selected: style == s, onSelected: (_) => setState(() => style = s), selectedColor: const Color(0xFFE7EDFF), side: BorderSide(color: style == s ? blue : const Color(0xFFE7E8ED)), labelStyle: TextStyle(color: style == s ? blue : Colors.black87, fontWeight: FontWeight.w600))).toList()),
    const SizedBox(height: 22), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF9DF), borderRadius: BorderRadius.circular(16)), child: Text('Prompt tip  •  “watercolor” creates soft edges; “cinematic lighting” adds dramatic contrast.', style: TextStyle(fontSize: 12, color: Color(0xFF685D32)))),
    const SizedBox(height: 18), FilledButton.icon(onPressed: busy ? null : generate, icon: const Icon(Icons.auto_awesome), label: Text(busy ? 'Creating your image…' : 'Generate image'), style: FilledButton.styleFrom(backgroundColor: blue, minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
    if (selected != null) ...[const SizedBox(height: 24), Text('Your latest image', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)), const SizedBox(height: 10), GestureDetector(onTap: () => showResult(selected!), child: SampleArtwork(seed: selected!.seed)), const SizedBox(height: 8), Text(selected!.prompt, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))],
  ]);

  Widget explorePage() => ListView(padding: const EdgeInsets.all(22), children: [title('Explore', 'See what people are creating. Tap a card to try its prompt.'), const SizedBox(height: 18), GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .72, children: List.generate(4, (i) { final names = ['Misty mountain lake', 'Neon city, anime', 'Cozy house by the sea', 'Spring flower bouquet']; final desc = ['Realistic', 'Anime', 'Watercolor', '3D']; return InkWell(onTap: () { prompt.text = names[i]; setState(() { style = desc[i]; tab = 0; }); }, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: SampleArtwork(seed: i, radius: 18)), const SizedBox(height: 6), Text(names[i], style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)), Text(desc[i], style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant))])); }))]);

  Widget libraryPage() => ListView(padding: const EdgeInsets.all(22), children: [title('Library', 'Every image you make, in one place.'), const SizedBox(height: 18), if (history.isEmpty) emptyState('Your gallery is waiting', 'Create an image and it will appear here.') else GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12), itemCount: history.length, itemBuilder: (_, i) => GestureDetector(onTap: () => showResult(history[i]), child: SampleArtwork(seed: history[i].seed)))]);

  Widget profilePage() => ListView(padding: const EdgeInsets.all(22), children: [title('Profile', 'Your creative space.'), const SizedBox(height: 25), const Center(child: CircleAvatar(radius: 42, backgroundColor: Color(0xFFFFE66D), child: Text('AC', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))), const SizedBox(height: 12), Center(child: Text('Alex Carter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))), Center(child: Text('@alexcarter', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))), Center(child: OutlinedButton(onPressed: editProfile, child: const Text('Edit profile'))), const SizedBox(height: 16), cardRow(Icons.image_outlined, 'My creations', '${history.length} images'), cardRow(Icons.bookmark_outline, 'Saved images', '0'), const SizedBox(height: 14), cardRow(Icons.palette_outlined, 'Appearance', appThemeMode.value.name, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppearancePage()))), cardRow(Icons.alternate_email, 'Change email', '›', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangeEmailPage()))), cardRow(Icons.lock_outline, 'Change password', '›', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage()))), cardRow(Icons.help_outline, 'Help and support', '›', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportPage()))), cardRow(Icons.logout, 'Log out', '›', onTap: () => showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Log out?'), content: const Text('Your images stay saved in your account.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), FilledButton(onPressed: () { Navigator.pop(ctx); Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false); }, child: const Text('Log out'))])))]);

  void editProfile() { final name = TextEditingController(text: 'Alex Carter'); final username = TextEditingController(text: '@alexcarter'); showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => Padding(padding: EdgeInsets.fromLTRB(22, 18, 22, MediaQuery.of(ctx).viewInsets.bottom + 20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Edit profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 18), TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder())), const SizedBox(height: 12), TextField(controller: username, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder())), const SizedBox(height: 12), const TextField(maxLines: 3, decoration: InputDecoration(labelText: 'Bio', border: OutlineInputBorder())), const SizedBox(height: 16), SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Save changes')))]))); }
  Widget sectionLabel(String n, String text) => Row(children: [CircleAvatar(radius: 11, backgroundColor: const Color(0xFFFFE66D), child: Text(n, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))), const SizedBox(width: 8), Text(text, style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface))]);
  Widget title(String a, String b) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(a, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)), Text(b, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))]);
  Widget emptyState(String a, String b) => Padding(padding: const EdgeInsets.only(top: 80), child: Column(children: [const Icon(Icons.image_outlined, color: blue, size: 52), const SizedBox(height: 10), Text(a, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(b, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))]));
  Widget cardRow(IconData icon, String text, String trailing, {VoidCallback? onTap}) => Card(elevation: 0, child: ListTile(onTap: onTap, leading: Icon(icon, color: blue), title: Text(text), trailing: Text(trailing, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))));


void showResult(Artwork image) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ResultScreen(artwork: image),
    ),
  );
}
}


