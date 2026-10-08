import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AuthService.ready) return const HomeScreen();
    return ValueListenableBuilder<bool>(
      valueListenable: AuthService.guest,
      builder: (_, isGuest, __) {
        if (isGuest) return const HomeScreen();
        return StreamBuilder<bool>(
          stream: AuthService.loggedIn,
          initialData: AuthService.isLoggedIn,
          builder: (_, snap) =>
              snap.data == true ? const HomeScreen() : const LoginScreen(),
        );
      },
    );
  }
}
