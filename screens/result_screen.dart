import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int ok, total, gain;
  const ResultScreen(
      {super.key, required this.ok, required this.total, required this.gain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 12),
              Text('Pelajaran selesai',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('$ok dari $total jawaban benar · +$gain XP'),
              const Spacer(),
              FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Lanjut')),
            ],
          ),
        ),
      ),
    );
  }
}
