/// Checks if the given [symbol] has won the game on the [board].
bool checkWinner(List<List<String>> board, String symbol) {
  // Check rows
  for (var row in board) {
    if (row.every((cell) => cell == symbol)) return true;
  }
  // Check columns
  for (int col = 0; col < board.length; col++) {
    if (board.every((row) => row[col] == symbol)) return true;
  }
  // Check diagonals
  if (board[0][0] == symbol && board[1][1] == symbol && board[2][2] == symbol) {
    return true;
  }
  if (board[0][2] == symbol && board[1][1] == symbol && board[2][0] == symbol) {
    return true;
  }

  return false;
}

/// Returns true if all cells on the board are filled.
bool isBoardFull(List<List<String>> board) {
  for (var row in board) {
    if (row.contains('')) return false;
  }
  return true;
}
