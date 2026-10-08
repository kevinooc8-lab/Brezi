import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class _PQ {
  final String level, prompt, say;
  final List<String> options;
  final int answer;
  const _PQ(this.level, this.prompt, this.say, this.options, this.answer);
}

const _questions = [
  _PQ('A1', 'Apa arti “Guten Abend”?', 'Guten Abend',
      ['Selamat pagi', 'Selamat malam', 'Terima kasih', 'Tidak tahu'], 1),
  _PQ('A1', 'Apa arti “Danke”?', 'Danke',
      ['Maaf', 'Terima kasih', 'Tolong', 'Tidak tahu'], 1),
  _PQ('A1', 'Apa arti “Ich komme aus Indonesien”?', 'Ich komme aus Indonesien',
      ['Saya tinggal di Jerman', 'Saya berasal dari Indonesia', 'Saya belajar Indonesia', 'Tidak tahu'], 1),
  _PQ('A2', 'Apa arti “Was kostet das?”', 'Was kostet das?',
      ['Berapa harganya?', 'Apa ini?', 'Di mana tokonya?', 'Tidak tahu'], 0),
  _PQ('A2', 'Apa arti “die Fahrkarte”?', 'die Fahrkarte',
      ['Peta', 'Tiket', 'Bagasi', 'Tidak tahu'], 1),
  _PQ('A2', 'Apa arti “Ich stehe um sieben Uhr auf”?', 'Ich stehe um sieben Uhr auf',
      ['Saya tidur jam tujuh', 'Saya makan jam tujuh', 'Saya bangun jam tujuh', 'Tidak tahu'], 2),
  _PQ('B1', 'Apa arti “Meiner Meinung nach”?', 'Meiner Meinung nach',
      ['Setelah rapat', 'Menurut pendapat saya', 'Tanpa pendapat saya', 'Tidak tahu'], 1),
  _PQ('B1', 'Apa arti “Ich habe Deutsch gelernt”?', 'Ich habe Deutsch gelernt',
      ['Saya sudah belajar bahasa Jerman', 'Saya akan mengajar Jerman', 'Saya suka Jerman', 'Tidak tahu'], 0),
];

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  State<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  final _tts = FlutterTts();
  int _i = 0;
  final Map<String, int> _sc = {'A1': 0, 'A2': 0, 'B1': 0};

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('de-DE');
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  String get _result {
    final a1 = _sc['A1']!, a2 = _sc['A2']!, b1 = _sc['B1']!;
    if (b1 >= 2 && a2 >= 2 && a1 >= 2) return 'B1';
    if (a2 >= 2 && a1 >= 2) return 'A2';
    return 'A1';
  }

  void _pick(int k) {
    final q = _questions[_i];
    if (k == q.answer) _sc[q.level] = _sc[q.level]! + 1;
    setState(() => _i++);
  }

  @override
  Widget build(BuildContext context) {
    if (_i >= _questions.length) {
      final r = _result;
      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Levelmu: $r',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text('A1 ${_sc['A1']}/3, A2 ${_sc['A2']}/3, B1 ${_sc['B1']}/2',
                  textAlign: TextAlign.center),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  context.read<AppState>().setPlaced(r);
                  Navigator.pop(context);
                },
                child: Text('Mulai di level $r'),
              ),
            ],
          ),
        ),
      );
    }
    final q = _questions[_i];
    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
              value: _i / _questions.length, minHeight: 10),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Tes penempatan ${_i + 1}/${_questions.length}'),
          const SizedBox(height: 8),
          Text(q.prompt, style: Theme.of(context).textTheme.headlineSmall),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton.filledTonal(
                icon: const Icon(Icons.volume_up),
                onPressed: () => _tts.speak(q.say)),
          ),
          const SizedBox(height: 8),
          for (var k = 0; k < q.options.length; k++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    alignment: Alignment.centerLeft),
                onPressed: () => _pick(k),
                child: Text(q.options[k], style: const TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
}
