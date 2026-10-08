import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/exams.dart';

const _green = Color(0xFF1D9A69);
const _secNames = [
  'Lesen (membaca)',
  'Hören (mendengar)',
  'Schreiben (menulis)',
  'Sprechen (berbicara)'
];

class ExamScreen extends StatefulWidget {
  final String level;
  const ExamScreen({super.key, required this.level});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final _tts = FlutterTts();
  final _text = TextEditingController();
  final Map<String, int> _ans = {};
  late final ExLevel _d = exams[widget.level]!;
  late int _left = _d.seconds;
  Timer? _timer;
  int _sec = 0; // 0..3 = modul, 4 = hasil
  int _rate = -1;
  int _plays = 0;
  bool _timeout = false;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('de-DE');
    _tts.setSpeechRate(0.45);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_sec >= 4) return;
      setState(() {
        _left--;
        if (_left <= 0) {
          _timeout = true;
          _finish();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    _text.dispose();
    super.dispose();
  }

  void _finish() {
    _timer?.cancel();
    _tts.stop();
    _sec = 4;
  }

  String _fmt(int t) => '${t ~/ 60}:${(t % 60).toString().padLeft(2, '0')}';
  int _wc(String t) => RegExp(r'\S+').allMatches(t).length;

  Widget _opt(String label, bool sel, VoidCallback f) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            alignment: Alignment.centerLeft,
            side: BorderSide(
                width: 2,
                color: sel
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade400),
            backgroundColor: sel
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
          ),
          onPressed: f,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
      );

  List<Widget> _questions(ExPassage p, int sec) {
    final w = <Widget>[];
    if (sec == 0) {
      w.add(Card(
          child: Padding(
              padding: const EdgeInsets.all(16), child: Text(p.text))));
    } else {
      w.add(FilledButton.tonalIcon(
        icon: const Icon(Icons.play_arrow),
        label: Text('Putar audio (${2 - _plays} kali lagi)'),
        onPressed: _plays >= 2
            ? null
            : () {
                setState(() => _plays++);
                _tts.speak(p.text);
              },
      ));
      w.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text('Teks tidak ditampilkan. Dengarkan lalu jawab.')));
    }
    for (var i = 0; i < p.qs.length; i++) {
      w.add(Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text('${i + 1}. ${p.qs[i].q}',
            style: Theme.of(context).textTheme.titleMedium),
      ));
      for (var k = 0; k < p.qs[i].o.length; k++) {
        w.add(_opt(p.qs[i].o[k], _ans['$sec-$i'] == k,
            () => setState(() => _ans['$sec-$i'] = k)));
      }
    }
    return w;
  }

  List<Widget> _body() {
    switch (_sec) {
      case 0:
        return _questions(_d.reading, 0);
      case 1:
        return _questions(_d.listening, 1);
      case 2:
        return [
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${_d.writing.prompt}\nMinimal ${_d.writing.min} kata'))),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            maxLines: 8,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
                hintText: 'Tulis dalam bahasa Jerman...',
                border: OutlineInputBorder()),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${_wc(_text.text)} kata')),
        ];
      default:
        return [
          const Text('Ucapkan keras-keras, lalu nilai dirimu dengan jujur.'),
          for (final s in _d.speaking)
            Card(
                child: ListTile(
                    leading: const Text('🎤', style: TextStyle(fontSize: 24)),
                    title: Text(s))),
          const SizedBox(height: 8),
          for (var i = 0; i < 3; i++)
            _opt(['Lancar', 'Cukup', 'Perlu latihan'][i], _rate == i,
                () => setState(() => _rate = i)),
        ];
    }
  }

  int _score(int sec, ExPassage p, List<List<String>> wrong) {
    var c = 0;
    for (var i = 0; i < p.qs.length; i++) {
      if (_ans['$sec-$i'] == p.qs[i].a) {
        c++;
      } else {
        wrong.add([p.qs[i].q, p.qs[i].o[p.qs[i].a]]);
      }
    }
    return (c * 25 / 3).round();
  }

  Widget _bar(String n, int v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          SizedBox(width: 96, child: Text(n)),
          Expanded(
              child: LinearProgressIndicator(
                  value: v / 25, minHeight: 10, color: _green)),
          SizedBox(width: 52, child: Text('  $v/25')),
        ]),
      );

  Widget _result() {
    final wrong = <List<String>>[];
    final l = _score(0, _d.reading, wrong);
    final h = _score(1, _d.listening, wrong);
    final w = _wc(_text.text);
    var kp = 0;
    final hits = <Widget>[];
    for (final k in _d.writing.keys) {
      final ok = RegExp(k.pattern, caseSensitive: false).hasMatch(_text.text);
      if (ok) kp += 5;
      hits.add(Text('${ok ? '✅' : '⬜'} ${k.label}'));
    }
    final lp = (w / _d.writing.min * 10).round().clamp(0, 10);
    final wr = kp + lp;
    final sp = _rate >= 0 ? [25, 15, 5][_rate] : 0;
    final tot = l + h + wr + sp;
    final pass = tot >= 60;
    return Scaffold(
      appBar: AppBar(title: Text('Hasil simulasi ${widget.level}')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Center(child: Text(pass ? '🎉' : '💪', style: const TextStyle(fontSize: 64))),
        Center(
            child: Text(pass ? 'Lulus!' : 'Belum lulus',
                style: Theme.of(context).textTheme.headlineMedium)),
        Center(
            child: Text('$tot / 100',
                style: Theme.of(context).textTheme.headlineLarge)),
        Center(
            child: Text('${_timeout ? 'Waktu habis. ' : ''}Batas lulus 60 poin')),
        const SizedBox(height: 16),
        _bar('Lesen', l),
        _bar('Hören', h),
        _bar('Schreiben', wr),
        _bar('Sprechen', sp),
        const SizedBox(height: 16),
        Text('Menulis: $w kata (minimal ${_d.writing.min})',
            style: Theme.of(context).textTheme.titleSmall),
        ...hits,
        const SizedBox(height: 16),
        if (wrong.isEmpty)
          const Text('Semua soal Lesen dan Hören benar!',
              style: TextStyle(color: _green, fontWeight: FontWeight.bold))
        else ...[
          Text('Yang masih salah',
              style: Theme.of(context).textTheme.titleSmall),
          for (final x in wrong)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('${x[0]}\nJawaban benar: ${x[1]}'),
            ),
        ],
        const SizedBox(height: 12),
        const Text(
            'Nilai menulis hanya perkiraan kasar, dan nilai bicara berasal dari penilaianmu sendiri.',
            style: TextStyle(fontSize: 12)),
        const SizedBox(height: 16),
        FilledButton(
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => ExamScreen(level: widget.level))),
            child: const Text('Ulangi simulasi')),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali')),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sec >= 4) return _result();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level} · ${_sec + 1}/4 ${_secNames[_sec]}',
            style: const TextStyle(fontSize: 16)),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                  child: Text(_fmt(_left),
                      style: const TextStyle(fontWeight: FontWeight.bold)))),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: _body()),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () {
              if (_sec == 3) {
                setState(_finish);
              } else {
                setState(() {
                  _sec++;
                  _plays = 0;
                });
              }
            },
            child: Text(_sec == 3 ? 'Selesai dan lihat hasil' : 'Lanjut'),
          ),
        ),
      ),
    );
  }
}
