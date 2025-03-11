// lib/easyLogic.dart
import 'dart:math';

/// Returns a random empty cell index from [board].
/// If no empty cells remain, returns null.
int? easyAIMove(List<String> board) {
  List<int> emptyIndices = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i].isEmpty) {
      emptyIndices.add(i);
    }
  }
  if (emptyIndices.isEmpty) return null;

  Random rnd = Random();
  return emptyIndices[rnd.nextInt(emptyIndices.length)];
}
