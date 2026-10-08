import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../state/app_state.dart';
import 'result_screen.dart';

const _green = Color(0xFF1D9A69);
const _red = Color(0xFFD4433A);

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final _tts = FlutterTts();
  int _i = 0, _ok = 0;
  int? _sel;
  List<String> _ans = [], _bank = [];
  bool _checked = false, _correct = false;

  Question get _q => widget.lesson.questions[_i];
  int get _total => widget.lesson.questions.length;
  bool get _last => _i == _total - 1;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('de-DE');
    _prep();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _prep() {
    _sel = null;
    _checked = false;
    _correct = false;
    _ans = [];
    _bank = _q.type == QType.order ? (List<String>.of(_q.words)..shuffle()) : [];
    if (_q.type == QType.listen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _say(_q.speak!));
    }
  }

  Future<void> _say(String t) async {
    try {
      await _tts.stop();
      await _tts.speak(t);
    } catch (_) {}
  }

  bool get _canCheck =>
      _q.type != QType.order ? _sel != null : _ans.isNotEmpty;

  void _check() {
    final c = _q.type != QType.order
        ? _sel == _q.answerIndex
        : _ans.join(' ') == _q.answerText;
    if (c) _ok++;
    setState(() {
      _checked = true;
      _correct = c;
    });
    if (_q.type == QType.order) _say(_q.answerText);
  }

  void _next() {
    if (_last) {
      final gain = context
          .read<AppState>()
          .completeLesson(widget.lesson.id, _ok, _total);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ResultScreen(ok: _ok, total: _total, gain: gain)));
    } else {
      setState(() {
        _i++;
        _prep();
      });
    }
  }

  List<Widget> _mc() {
    return [
      for (var i = 0; i < _q.options.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              alignment: Alignment.centerLeft,
              side: BorderSide(
                width: 2,
                color: _checked
                    ? (i == _q.answerIndex
                        ? _green
                        : (i == _sel ? _red : Colors.grey.shade400))
                    : (i == _sel
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400),
              ),
            ),
            onPressed: _checked ? null : () => setState(() => _sel = i),
            child: Text(_q.options[i], style: const TextStyle(fontSize: 16)),
          ),
        ),
    ];
  }

  List<Widget> _order() {
    return [
      Container(
        constraints: const BoxConstraints(minHeight: 64),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 2))),
        child: Wrap(spacing: 8, runSpacing: 8, children: [
          for (var i = 0; i < _ans.length; i++)
            ActionChip(
              label: Text(_ans[i]),
              onPressed: _checked
                  ? null
                  : () => setState(() => _bank.add(_ans.removeAt(i))),
            ),
        ]),
      ),
      const SizedBox(height: 20),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (var i = 0; i < _bank.length; i++)
          ActionChip(
            label: Text(_bank[i]),
            onPressed: _checked
                ? null
                : () => setState(() => _ans.add(_bank.removeAt(i))),
          ),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: _i / _total, minHeight: 10),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(_q.prompt, style: Theme.of(context).textTheme.headlineSmall),
          if (_q.speak != null)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton.filledTonal(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _say(_q.speak!)),
            ),
          const SizedBox(height: 12),
          if (_q.type != QType.order) ..._mc() else ..._order(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: _checked ? (_correct ? _green : _red).withOpacity(.15) : null,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (_checked)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _correct
                      ? 'Benar! +10 XP'
                      : 'Jawaban yang benar: ${_q.type != QType.order ? _q.options[_q.answerIndex] : _q.answerText}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _correct ? _green : _red),
                ),
              ),
            FilledButton(
              onPressed: _checked ? _next : (_canCheck ? _check : null),
              child:
                  Text(_checked ? (_last ? 'Selesai' : 'Lanjut') : 'Periksa'),
            ),
          ]),
        ),
      ),
    );
  }
}
