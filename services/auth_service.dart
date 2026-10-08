import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Login email dan kata sandi lewat Firebase Authentication.
/// Jika google-services.json belum dipasang, [ready] bernilai false dan
/// aplikasi tetap jalan tanpa login.
class AuthService {
  static bool ready = false;
  static final ValueNotifier<bool> guest = ValueNotifier(false);

  static Future<void> init() async {
    try {
      await Firebase.initializeApp();
      ready = true;
    } catch (_) {
      ready = false;
    }
  }

  static bool get isLoggedIn =>
      ready && FirebaseAuth.instance.currentUser != null;

  static String? get email =>
      ready ? FirebaseAuth.instance.currentUser?.email : null;

  static Stream<bool> get loggedIn =>
      FirebaseAuth.instance.authStateChanges().map((u) => u != null);

  static Future<String?> signIn(String email, String password) => _run(() =>
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password));

  static Future<String?> register(String email, String password) => _run(() =>
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password));

  static Future<String?> resetPassword(String email) =>
      _run(() => FirebaseAuth.instance.sendPasswordResetEmail(email: email));

  static Future<void> signOut() async {
    guest.value = false;
    await FirebaseAuth.instance.signOut();
  }

  static Future<String?> _run(Future<Object?> Function() f) async {
    try {
      await f();
      return null;
    } on FirebaseAuthException catch (e) {
      return _msg(e);
    } catch (_) {
      return 'Terjadi kesalahan. Coba lagi.';
    }
  }

  static String _msg(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar. Silakan masuk.';
      case 'weak-password':
        return 'Kata sandi minimal 6 karakter.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan (${e.code}).';
    }
  }
}
