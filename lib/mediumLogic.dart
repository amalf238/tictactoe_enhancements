class MediumLogic {
  bool hasMadeFirstMove = false;

  /// Simulate making a move in Medium mode.
  /// - The first move is "random" (easy logic).
  /// - Subsequent moves use advanced/hard logic.
  String makeMove() {
    if (!hasMadeFirstMove) {
      hasMadeFirstMove = true;
      // Return some random easy-mode move or indicate it was an easy-mode move
      return "RandomMove(Easy)";
    } else {
      // Return something that indicates "hard" logic
      return "CalculatedMove(Hard)";
    }
  }
}
