// lib/hardLogic.dart

import 'dart:math';

/// Symbols used by human (X) and AI (O).
const String userSymbol = 'X';
const String aiSymbol = 'O';

/// Returns a move index for the AI based on the Hard-mode strategy:
///  1) If AI or opponent has two in a row, play on the remaining square
///  2) If there's a move that creates two lines of two in a row (fork), play that move
///  3) If the centre (index 4) is free, play there
///  4) If the opponent is in a corner, play the opposite corner
///  5) If there is a free corner, play there
///  6) Otherwise, pick any random empty square
int? hardAIMove(List<String> board) {
  // 1) Check two in a row
  int? twoInARowIndex = _checkTwoInARow(board, aiSymbol, userSymbol);
  if (twoInARowIndex != null) {
    return twoInARowIndex;
  }

  // 2) Check fork
  int? forkIndex = _checkForkCreation(board, aiSymbol);
  if (forkIndex != null) {
    return forkIndex;
  }

  // 3) If centre free, pick index 4
  if (board[4].isEmpty) {
    return 4;
  }

  // 4) Opposite corner if user is in a corner
  int? oppositeCornerIndex = _checkOppositeCorner(board, userSymbol);
  if (oppositeCornerIndex != null) {
    return oppositeCornerIndex;
  }

  // 5) If there is a free corner, pick that
  int? freeCornerIndex = _checkFreeCorner(board);
  if (freeCornerIndex != null) {
    return freeCornerIndex;
  }

  // 6) Otherwise fallback to a random empty cell
  return _pickRandomEmpty(board);
}

/// Checks if there's a winning move for AI or a blocking move vs. user.
/// Returns the move index if found, otherwise null.
int? _checkTwoInARow(List<String> board, String aiSym, String userSym) {
  List<List<int>> lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  // Try to win first
  for (var line in lines) {
    String a = board[line[0]];
    String b = board[line[1]];
    String c = board[line[2]];
    if (a == aiSym && b == aiSym && c.isEmpty) return line[2];
    if (a == aiSym && c == aiSym && b.isEmpty) return line[1];
    if (b == aiSym && c == aiSym && a.isEmpty) return line[0];
  }

  // Block user
  for (var line in lines) {
    String a = board[line[0]];
    String b = board[line[1]];
    String c = board[line[2]];
    if (a == userSym && b == userSym && c.isEmpty) return line[2];
    if (a == userSym && c == userSym && b.isEmpty) return line[1];
    if (b == userSym && c == userSym && a.isEmpty) return line[0];
  }

  return null;
}

/// Checks if placing AI symbol leads to "two ways to win" next turn (fork).
int? _checkForkCreation(List<String> board, String aiSym) {
  List<int> emptyIndices = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i].isEmpty) emptyIndices.add(i);
  }

  for (int idx in emptyIndices) {
    board[idx] = aiSym;
    int potentialWins = _countPotentialWins(board, aiSym);
    board[idx] = ''; // revert
    if (potentialWins >= 2) {
      return idx;
    }
  }
  return null;
}

/// Count how many lines are one move away from winning for 'symbol'.
int _countPotentialWins(List<String> board, String symbol) {
  List<List<int>> lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  int count = 0;
  for (var line in lines) {
    String a = board[line[0]];
    String b = board[line[1]];
    String c = board[line[2]];

    // If all are either symbol or empty, and exactly 2 are symbol
    if ((a == symbol || a.isEmpty) &&
        (b == symbol || b.isEmpty) &&
        (c == symbol || c.isEmpty)) {
      int howManySymbols = [a, b, c].where((cell) => cell == symbol).length;
      if (howManySymbols == 2) {
        count++;
      }
    }
  }
  return count;
}

/// If user is in a corner, pick the opposite corner if empty.
int? _checkOppositeCorner(List<String> board, String userSym) {
  List<int> corners = [0, 2, 6, 8];
  for (var corner in corners) {
    if (board[corner] == userSym) {
      int opposite = _getOppositeCorner(corner);
      if (opposite != -1 && board[opposite].isEmpty) {
        return opposite;
      }
    }
  }
  return null;
}

/// Returns opposite corner index for 0->8, 2->6, 6->2, 8->0
int _getOppositeCorner(int corner) {
  switch (corner) {
    case 0:
      return 8;
    case 2:
      return 6;
    case 6:
      return 2;
    case 8:
      return 0;
  }
  return -1;
}

/// Checks if there's a free corner; returns the first free one if found.
int? _checkFreeCorner(List<String> board) {
  List<int> corners = [0, 2, 6, 8];
  for (var c in corners) {
    if (board[c].isEmpty) return c;
  }
  return null;
}

/// Fallback to a random empty cell.
int? _pickRandomEmpty(List<String> board) {
  List<int> emptyIndices = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i].isEmpty) emptyIndices.add(i);
  }
  if (emptyIndices.isEmpty) return null; // no moves possible

  Random rnd = Random();
  return emptyIndices[rnd.nextInt(emptyIndices.length)];
}
