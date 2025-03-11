import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colours.dart';

String? checkWinner(List<String> board) {
  List<List<int>> winningConditions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  for (var condition in winningConditions) {
    String a = board[condition[0]];
    String b = board[condition[1]];
    String c = board[condition[2]];
    if (a.isNotEmpty && a == b && b == c) {
      return a;
    }
  }
  if (!board.contains('')) {
    return 'Draw';
  }
  return null;
}

void showWinnerDialog(
  BuildContext context,
  String winner, {
  required bool isSinglePlayer,
  required VoidCallback onReset,
}) {
  String title;
  String content;

  if (winner == 'Draw') {
    title = 'Draw!';
    content = 'Nobody wins.';
  } else if (winner == 'X' || winner == 'O') {
    if (isSinglePlayer) {
      if (winner == 'X') {
        title = 'You Won!';
        content = 'Congratulations! You beat the App.';
      } else {
        title = 'You Lost!';
        content = 'Better luck next time.';
      }
    } else {
      if (winner == 'X') {
        title = 'X Wins!';
        content = 'Player X takes the game.';
      } else {
        title = 'O Wins!';
        content = 'Player O takes the game.';
      }
    }
  } else {
    title = 'Game Over';
    content = 'No result detected.';
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      return AlertDialog(
        backgroundColor: MainColor.backgroundColor.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.ubuntu(
                  fontSize: 28,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                content,
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onReset();
                },
                child: Text(
                  'Try Again',
                  style: GoogleFonts.coiny(
                    fontSize: 30,
                    color: MainColor.accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
