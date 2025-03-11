// lib/winnerLogic.dart
//
// Pure Dart logic for determining the winner in Tic Tac Toe.
// No Flutter dependencies—can be tested with `dart test`.

/// Returns:
///   'X' if X has won,
///   'O' if O has won,
///   'Draw' if all squares are filled with no winner,
///   or null if the game is still ongoing.
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
      return a; // 'X' or 'O'
    }
  }

  // If no empty slots remain, it's a draw
  if (!board.contains('')) {
    return 'Draw';
  }

  // Otherwise, no winner yet
  return null;
}
