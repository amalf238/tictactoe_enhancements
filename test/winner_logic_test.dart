// test/winnerLogicTest.dart
import 'package:test/test.dart';
import 'package:tic_tac_toe_amal/winnerLogic.dart';

void main() {
  group('Winner Logic Tests', () {
    // X wins via the top row
    test('1) X wins on top row', () {
      List<String> board = ['X', 'X', 'X', '', 'O', '', 'O', '', ''];
      String? winner = checkWinner(board);
      expect(winner, 'X');
    });

    // O wins via left column
    test('2) O wins on left column', () {
      List<String> board = ['O', 'X', 'X', 'O', 'X', '', 'O', '', ''];
      String? winner = checkWinner(board);
      expect(winner, 'O');
    });

    // X wins via diagonal
    test('3) X wins on diagonal', () {
      List<String> board = ['X', 'O', '', '', 'X', 'O', '', '', 'X'];
      String? winner = checkWinner(board);
      expect(winner, 'X');
    });

    // Board is not yet finished, so null
    test('4) No winner yet - null', () {
      List<String> board = ['X', 'O', 'X', '', 'O', '', 'X', '', ''];
      String? winner = checkWinner(board);
      expect(winner, isNull);
    });

    // Draw: board is full, no winners
    test('5) Draw if board is filled with no winner', () {
      List<String> board = ['X', 'O', 'X', 'X', 'O', 'O', 'O', 'X', 'X'];
      String? winner = checkWinner(board);
      expect(winner, 'Draw');
    });

    // NEW TEST #6: O wins on the bottom row (6,7,8)
    test('6) O wins on bottom row', () {
      List<String> board = ['X', 'X', '', '', 'X', '', 'O', 'O', 'O'];
      String? winner = checkWinner(board);
      expect(winner, 'O');
    });

    // NEW TEST #7: X wins on middle column (1,4,7)
    test('7) X wins on middle column', () {
      List<String> board = ['', 'X', 'O', '', 'X', 'O', '', 'X', ''];
      String? winner = checkWinner(board);
      expect(winner, 'X');
    });
  });
}
