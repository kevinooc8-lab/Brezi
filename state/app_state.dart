import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  late SharedPreferences _p;
  int xp = 0;
  int streak = 0;
  String _last = '';
  Set<String> done = {};
  bool pro = false;
  String level = 'A1';
  String? placed;

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    xp = _p.getInt('xp') ?? 0;
    streak = _p.getInt('streak') ?? 0;
    _last = _p.getString('last') ?? '';
    done = (_p.getStringList('done') ?? []).toSet();
    pro = _p.getBool('pro') ?? false;
    level = _p.getString('level') ?? 'A1';
    placed = _p.getString('placed');
    _expireStreak();
    notifyListeners();
  }

  String _day(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String get _today => _day(DateTime.now());
  String get _yesterday =>
      _day(DateTime.now().subtract(const Duration(days: 1)));

  void _expireStreak() {
    if (_last.isEmpty) return;
    if (_last != _today && _last != _yesterday) streak = 0;
  }

  /// Mengembalikan XP yang didapat dari pelajaran ini.
  int completeLesson(String id, int correct, int total) {
    final gain = correct * 10 + (correct == total ? 20 : 0);
    xp += gain;
    done.add(id);
    if (_last != _today) {
      streak = (_last == _yesterday) ? streak + 1 : 1;
      _last = _today;
    }
    _p.setInt('xp', xp);
    _p.setInt('streak', streak);
    _p.setString('last', _last);
    _p.setStringList('done', done.toList());
    notifyListeners();
    return gain;
  }

  void setLevel(String v) {
    level = v;
    _p.setString('level', v);
    notifyListeners();
  }

  void setPlaced(String v) {
    placed = v;
    level = v;
    _p.setString('placed', v);
    _p.setString('level', v);
    notifyListeners();
  }

  Future<void> setPro(bool v) async {
    pro = v;
    await _p.setBool('pro', v);
    notifyListeners();
  }
}
