// lib/gameModes.dart

import 'dart:math';

/// Easy-mode AI: picks a random empty cell.
int? easyAIMove(List<String> board) {
  List<int> emptyIndices = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i].isEmpty) {
      emptyIndices.add(i);
    }
  }
  if (emptyIndices.isEmpty) return null;
  final randomGenerator = Random();
  return emptyIndices[randomGenerator.nextInt(emptyIndices.length)];
}

/// Hard-mode AI: more advanced strategy (forks, center, corners, etc.).
int? hardAIMove(List<String> board) {
  const String userSymbol = 'X';
  const String aiSymbol = 'O';

  // 1) Check two-in-a-row (to win or block)
  int? twoInARowIndex = _checkTwoInARow(board, aiSymbol, userSymbol);
  if (twoInARowIndex != null) {
    return twoInARowIndex;
  }

  // 2) Check if we can create a fork
  int? forkIndex = _checkForkCreation(board, aiSymbol);
  if (forkIndex != null) {
    return forkIndex;
  }

  // 3) If center is available, pick it
  if (board[4].isEmpty) {
    return 4;
  }

  // 4) Opposite corner if user is in a corner
  int? oppositeCornerIndex = _checkOppositeCorner(board, userSymbol);
  if (oppositeCornerIndex != null) {
    return oppositeCornerIndex;
  }

  // 5) Pick any free corner
  int? freeCornerIndex = _checkFreeCorner(board);
  if (freeCornerIndex != null) {
    return freeCornerIndex;
  }

  // 6) Otherwise, random empty (fallback to Easy)
  return easyAIMove(board);
}

/// Medium-mode AI:
///  - First AI move is random (Easy)
///  - Subsequent moves follow Hard logic.
int? mediumAIMove(List<String> board) {
  // If the AI has not yet played any move ('O'), go random.
  bool hasAIMoved = board.contains('O');
  if (!hasAIMoved) {
    return easyAIMove(board);
  } else {
    return hardAIMove(board);
  }
}

// -----------------------------------------------------
//  Below are private helper functions for Hard logic
// -----------------------------------------------------

/// Attempts to find a line of two 'aiSymbol' or 'userSymbol' to either win or block.
int? _checkTwoInARow(List<String> board, String aiSymbol, String userSymbol) {
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

  // Win first
  for (var line in lines) {
    String a = board[line[0]];
    String b = board[line[1]];
    String c = board[line[2]];
    if (a == aiSymbol && b == aiSymbol && c.isEmpty) return line[2];
    if (a == aiSymbol && c == aiSymbol && b.isEmpty) return line[1];
    if (b == aiSymbol && c == aiSymbol && a.isEmpty) return line[0];
  }

  // Block the user
  for (var line in lines) {
    String a = board[line[0]];
    String b = board[line[1]];
    String c = board[line[2]];
    if (a == userSymbol && b == userSymbol && c.isEmpty) return line[2];
    if (a == userSymbol && c == userSymbol && b.isEmpty) return line[1];
    if (b == userSymbol && c == userSymbol && a.isEmpty) return line[0];
  }
  return null;
}

/// Checks if placing 'aiSymbol' in any empty cell leads to 2 possible wins (fork).
int? _checkForkCreation(List<String> board, String aiSymbol) {
  List<int> emptyIndices = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i].isEmpty) emptyIndices.add(i);
  }

  for (int idx in emptyIndices) {
    board[idx] = aiSymbol;
    int potentialWins = _countPotentialWins(board, aiSymbol);
    board[idx] = '';
    if (potentialWins >= 2) {
      return idx;
    }
  }
  return null;
}

/// Counts how many lines can be turned into a win with one more move for [symbol].
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

/// Checks if user is in a corner, and if so, returns the opposite corner if it's empty.
int? _checkOppositeCorner(List<String> board, String userSymbol) {
  List<int> corners = [0, 2, 6, 8];
  for (int corner in corners) {
    if (board[corner] == userSymbol) {
      int opposite = _getOppositeCorner(corner);
      if (opposite != -1 && board[opposite].isEmpty) {
        return opposite;
      }
    }
  }
  return null;
}

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

/// Returns the first free corner if any are available.
int? _checkFreeCorner(List<String> board) {
  List<int> corners = [0, 2, 6, 8];
  for (int c in corners) {
    if (board[c].isEmpty) {
      return c;
    }
  }
  return null;
}
