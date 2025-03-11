import 'package:test/test.dart';
import 'package:tic_tac_toe_amal/mediumLogic.dart';

void main() {
  group('MediumLogic Extended Tests', () {
    test('First move should be random (Easy mode)', () {
      final logic = MediumLogic();

      // Before any moves, hasMadeFirstMove should be false
      expect(logic.hasMadeFirstMove, isFalse);

      // Make a move
      final firstMove = logic.makeMove();

      // Check that the first move looks like an "easy" move
      // (e.g., it returns a string indicating it's from Easy mode or is random)
      expect(firstMove.contains("Easy"), isTrue);

      // After the first move, hasMadeFirstMove should be true
      expect(logic.hasMadeFirstMove, isTrue);
    });

    test('Switches to Hard mode after the first move', () {
      final logic = MediumLogic();

      // Make the first move
      logic.makeMove(); // Should be easy/random

      // Now the second move is expected to be from "hard" logic
      final secondMove = logic.makeMove();

      // Verify that the second move indicates "hard" logic or non-random
      expect(secondMove.contains("Hard"), isTrue);
    });

    // Ensure the 3rd and subsequent moves also remain "Hard".
    test('Third and subsequent moves remain Hard', () {
      final logic = MediumLogic();
      logic.makeMove(); // first move (Easy)
      logic.makeMove(); // second move (Hard)

      final thirdMove = logic.makeMove(); // third move
      expect(thirdMove.contains("Hard"), isTrue);

      final fourthMove = logic.makeMove(); // fourth move, etc.
      expect(fourthMove.contains("Hard"), isTrue);
    });
  });
}
