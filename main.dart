import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_gate.dart';
import 'services/auth_service.dart';
import 'services/purchase_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PurchaseService.init();
  await AuthService.init();
  final state = AppState();
  await state.load();
  if (PurchaseService.live) {
    await state.setPro(await PurchaseService.checkPro());
  }
  runApp(ChangeNotifierProvider.value(value: state, child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  ThemeData _theme(Brightness b) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF14262B), brightness: b),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14))),
        ),
      );

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Deutsch lernen',
        debugShowCheckedModeBanner: false,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        home: const AuthGate(),
      );
}
