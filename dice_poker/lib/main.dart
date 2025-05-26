import 'package:dice_poker/screen/dice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: DicePokerApp()));
}

class DicePokerApp extends StatelessWidget {
  const DicePokerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Dice Poker",
      theme: ThemeData.dark(),
      home: const DiceScreen(),
    );
  }
}
