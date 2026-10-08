import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../data/lessons.dart';
import '../state/app_state.dart';
import 'lesson_screen.dart';
import 'paywall_screen.dart';
import '../services/auth_service.dart';
import 'placement_screen.dart';
import 'exam_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _open(BuildContext context, int i) async {
    final s = context.read<AppState>();
    final l = levels[s.level]![i];
    if (l.premium && !s.pro) {
      final ok = await Navigator.push<bool>(
          context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
      if (ok != true || !context.mounted) return;
    }
    if (l.questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pelajaran ini belum tersedia.')));
      return;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => LessonScreen(lesson: l)));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final cs = Theme.of(context).colorScheme;
    final list = levels[s.level]!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deutsch lernen'),
        actions: [
          if (AuthService.ready)
            IconButton(
              tooltip: AuthService.isLoggedIn ? 'Keluar' : 'Masuk',
              icon: Icon(AuthService.isLoggedIn ? Icons.logout : Icons.login),
              onPressed: () {
                if (AuthService.isLoggedIn) {
                  AuthService.signOut();
                } else {
                  AuthService.guest.value = false;
                }
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: Text('🔥 ${s.streak}   ⭐ ${s.xp}')),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: cs.primaryContainer,
            child: ListTile(
              title: const Text('die Freundschaft',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              subtitle: const Text('Kata hari ini: persahabatan'),
              trailing: IconButton.filled(
                icon: const Icon(Icons.volume_up),
                onPressed: () async {
                  final t = FlutterTts();
                  await t.setLanguage('de-DE');
                  await t.speak('die Freundschaft');
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              for (final k in levels.keys)
                ButtonSegment(
                    value: k,
                    label: Text('$k${k != 'A1' && !s.pro ? ' 👑' : ''}')),
            ],
            selected: {s.level},
            onSelectionChanged: (v) => context.read<AppState>().setLevel(v.first),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Text('🎯', style: TextStyle(fontSize: 28)),
              title: const Text('Tes penempatan level'),
              subtitle: Text(s.placed == null
                  ? '8 soal, sekitar 2 menit'
                  : 'Levelmu: ${s.placed}. Ulangi tes'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PlacementScreen())),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text('📝', style: TextStyle(fontSize: 28)),
              title: const Text('Simulasi ujian'),
              subtitle: Text('Level ${s.level} · 4 modul, 100 poin'
                  '${s.level != 'A1' && !s.pro ? ' · Premium' : ''}'),
              onTap: () async {
                final lv = s.level;
                if (lv != 'A1' && !s.pro) {
                  final ok = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PaywallScreen()));
                  if (ok != true || !context.mounted) return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ExamScreen(level: lv)));
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Level ${s.level} · ${levelNames[s.level]}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var i = 0; i < list.length; i++)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(list[i].emoji)),
                title: Text(list[i].title),
                subtitle: Text(list[i].subtitle),
                trailing: s.done.contains(list[i].id)
                    ? const Icon(Icons.check_circle, color: Color(0xFF1D9A69))
                    : (list[i].premium && !s.pro)
                        ? const Icon(Icons.lock_outline)
                        : const Icon(Icons.chevron_right),
                onTap: () => _open(context, i),
              ),
            ),
        ],
      ),
    );
  }
}
