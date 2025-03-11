// test/hardLogicTest.dart
// If not in a Flutter environment, you can use the normal 'package:test/test.dart' instead:
import 'package:test/test.dart';

// test/hardLogicTest.dart
import 'package:tic_tac_toe_amal/hardLogic.dart'; // <--- use your actual package name

// ^ Replace 'your_app_name' with your actual app or package name

void main() {
  group('Hard Mode Logic Tests', () {
    test('1) Two in a row for AI => AI should complete and win', () {
      // AI symbol = 'O'
      // Create a scenario where AI already has 2 in a row:
      List<String> board = [
        'O', 'O', '', // indexes 0,1,2
        '', 'X', '', // indexes 3,4,5
        '', '', '' // indexes 6,7,8
      ];

      int? move = hardAIMove(board);
      expect(move, 2); // AI should play index 2 to complete the row
    });

    test('2) Fork creation => AI picks spot that gives two ways to win', () {
      // This scenario is contrived but shows a potential fork:
      // AI can place 'O' to threaten 2 lines at once
      List<String> board = [
        'O', '', '', // indexes 0,1,2
        '', 'X', '', // indexes 3,4,5
        '', '', 'O' // indexes 6,7,8
      ];
      // Suppose placing O at index 2 or something might create a fork
      // We'll guess the AI picks index 2 (or some correct fork spot),
      // but you must set up the board so that indeed it creates a fork.

      // Adjust this board so the "fork" is truly possible:
      // For example, put an AI piece in [0], [8], so there's a diagonal threat and something else

      // Let's see if the method picks the correct index. The index you
      // expect depends on your logic & how the board is set up. We'll test for a known spot.
      int? move = hardAIMove(board);

      // Possibly we expect the AI to place a piece at index 2 or 6 or so, depending on your logic
      // Update this to your actual expected 'fork' index
      // For demonstration, let's say we expect 2:
      expect(move, 2);
    });

    test('3) Center is free => AI picks center (index 4)', () {
      // No immediate 2-in-a-row or fork
      // Just ensure the center is empty and no corners are threatened
      List<String> board = ['', '', '', '', '', '', 'X', '', 'O'];
      // The center (4) is empty. Should be chosen if there's no 2inARow or fork

      int? move = hardAIMove(board);
      expect(move, 4); // AI should pick center
    });

    test('4) Opponent in a corner => AI picks opposite corner', () {
      // If user (X) is in top-left corner, AI should pick bottom-right corner if all else fails
      List<String> board = [
        'X', '', '', // X is in corner index=0
        '', '', '',
        '', '', ''
      ];
      // No immediate 2-in-a-row or fork; center is not empty? Let's make center occupied so that we skip it
      board[4] = 'X'; // user also took center, for instance

      int? move = hardAIMove(board);
      expect(move, 8); // Opposite corner of 0 is 8
    });

    // Player symbol = 'X'
    // Create a scenario where Pplayer has already 2 in a row:
    // AI will block as long as it donen't have a chance to win
    test('5) AI blocks user if user has two in a row', () {
      List<String> board = ['X', 'X', '', '', 'O', '', '', '', 'O'];
      int? move = hardAIMove(board);
      expect(move, 2);
    });
  });
  // AI symbol = 'O'
  // Create a scenario where all 4 corners of the board are avilible
  // Checks if the AI places its move in one of the avaliable corners
  test('6) Pick a free corner if center not free and no immediate threat', () {
    List<String> board = ['', 'X', '', '', 'O', '', '', '', ''];
    int? move = hardAIMove(board);
    expect([0, 2, 6, 8], contains(move));
  });

  // Note: AI symbol is 'O' and Player symbol is 'X'
  // Checks if the AI Prioritizes winning over blocking the User
  test('7) Prioritize own win over blocking user', () {
    List<String> board = ['O', 'O', '', 'X', 'X', '', '', '', ''];
    int? move = hardAIMove(board);
    expect(move, 2);
  });
}
