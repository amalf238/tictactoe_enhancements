// lib/main.dart

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_amal/screens/selectGameModeScreen.dart';
import 'screens/game_mainscreen.dart';
import 'package:flutter/services.dart';
import 'winner.dart';
import 'gameModes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SelectGameModeScreen(),
    );
  }
}
