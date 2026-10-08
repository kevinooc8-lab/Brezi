import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pw = TextEditingController();
  bool _register = false;
  bool _busy = false;
  String? _error;
  String? _info;

  @override
  void dispose() {
    _email.dispose();
    _pw.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final e = _email.text.trim();
    final p = _pw.text;
    if (e.isEmpty || p.isEmpty) {
      setState(() => _error = 'Isi email dan kata sandi.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    final err = _register
        ? await AuthService.register(e, p)
        : await AuthService.signIn(e, p);
    if (mounted) setState(() {
      _busy = false;
      _error = err;
    });
  }

  Future<void> _forgot() async {
    final e = _email.text.trim();
    if (e.isEmpty) {
      setState(() => _error = 'Isi email dulu, lalu tekan Lupa kata sandi.');
      return;
    }
    final err = await AuthService.resetPassword(e);
    if (!mounted) return;
    setState(() {
      _error = err;
      _info = err == null ? 'Tautan reset kata sandi dikirim ke $e.' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              const Center(child: Text('🥨', style: TextStyle(fontSize: 72))),
              const SizedBox(height: 8),
              Text(_register ? 'Buat akun' : 'Masuk',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              const Text('Simpan progres belajarmu di akun.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pw,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration: const InputDecoration(
                    labelText: 'Kata sandi', border: OutlineInputBorder()),
                onSubmitted: (_) => _submit(),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              if (_info != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_info!),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_register ? 'Daftar' : 'Masuk'),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() {
                          _register = !_register;
                          _error = null;
                          _info = null;
                        }),
                child: Text(_register
                    ? 'Sudah punya akun? Masuk'
                    : 'Belum punya akun? Daftar'),
              ),
              if (!_register)
                TextButton(
                    onPressed: _busy ? null : _forgot,
                    child: const Text('Lupa kata sandi?')),
              TextButton(
                  onPressed: () => AuthService.guest.value = true,
                  child: const Text('Lewati dulu')),
            ],
          ),
        ),
      ),
    );
  }
}
