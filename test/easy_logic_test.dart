// test/easyLogicTest.dart
import 'package:test/test.dart';
import 'package:tic_tac_toe_amal/easyLogic.dart';

void main() {
  group('Easy Mode Tests', () {
    // Checks if a random move is chosen among the empty cells.
    test('Easy mode picks a random empty cell', () {
      List<String> board = ['X', '', 'O', 'O', '', 'X', '', '', 'X'];
      // Empty indices: 1, 4, 6, 7
      int? move = easyAIMove(board);
      expect([1, 4, 6, 7], contains(move));
    });

    // Ensures null is returned when the board has no empty cells.
    test('Easy mode returns null if board is full', () {
      List<String> board = ['X', 'O', 'X', 'O', 'X', 'O', 'X', 'O', 'X'];
      int? move = easyAIMove(board);
      expect(move, isNull);
    });

    // Ensures the AI picks the only empty spot if there's exactly one left.
    test('Easy mode picks the single empty cell', () {
      List<String> board = ['X', 'O', 'X', 'O', 'X', 'O', 'X', 'O', ''];
      // Only index 8 is empty
      int? move = easyAIMove(board);
      expect(move, 8);
    });
  });
}
