/// Determines whether the player with the given [symbol] has won the game
/// based on the current state of the 3x3 [board].
///
/// This function is called after every valid move to check if the game
/// has reached a winning condition. It checks all possible win scenarios:
/// - All cells in any single row contain the same symbol
/// - All cells in any single column contain the same symbol
/// - All cells in either of the two diagonals contain the same symbol
///
/// A win is declared if any of these conditions is true.
///
/// Parameters:
/// - [board]: A 3x3 matrix representing the current state of the game grid,
///            where each cell contains '', 'X', or 'O'.
/// - [symbol]: The symbol of the current player to check for a win
/// ('X' or 'O').
///
/// Returns:
/// - `true` if the symbol has a winning combination on the board.
/// - `false` otherwise.
bool checkWinner(List<List<String>> board, String symbol) {
  // Check all rows for a winning condition
  // A win is detected if all cells in a row contain the player's symbol
  for (var row in board) {
    if (row.every((cell) => cell == symbol)) return true;
  }

  // Check all columns for a winning condition
  // Loop through each column index and check if all rows have the symbol at
  // that column
  for (int col = 0; col < board.length; col++) {
    if (board.every((row) => row[col] == symbol)) return true;
  }

  // Check the first diagonal (top-left to bottom-right)
  if (board[0][0] == symbol &&
      board[1][1] == symbol &&
      board[2][2] == symbol) {
    return true;
  }

  // Check the second diagonal (top-right to bottom-left)
  if (board[0][2] == symbol &&
      board[1][1] == symbol &&
      board[2][0] == symbol) {
    return true;
  }

  // No win found in rows, columns or diagonals
  return false;
}
