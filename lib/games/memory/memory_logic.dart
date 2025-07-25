import 'package:android_game_2025/helper/utils.dart';

/// Determines the winner(s) based on final player scores.
/// Increments the total game win count for each winning player.
///
/// [players] - List of Player objects
/// [playerScores] - List of integer scores (index corresponds to player)
void determineWinner(players, playerScores) {
  // Identify the index/indices of players with the highest score
  List<int> winners = getWinnersFromScores(playerScores);

  // Increment win count for each winner
  for (var j = 0; j < winners.length; j++) {
    players[winners[j]].incrementScore();
  }
}

/// Increments the current player's score and updates matched pair count.
///
/// [playerScores] - List of current scores
/// [currentPlayerIndex] - Index of the player whose score should be incremented
/// [matchedPairs] - Current number of matched pairs found in the game
///
/// Returns the new matchedPairs count after the successful match.
int incrementScore(playerScores, currentPlayerIndex, matchedPairs) {
  playerScores[currentPlayerIndex]++;
  return matchedPairs + 1;
}

/// Checks whether the two selected cards form a matching pair.
///
/// [board] - 2D list of image strings representing the game board
/// [row], [col] - Coordinates of the second card
/// [firstSelectedRow], [firstSelectedCol] - Coordinates of the first selected card
///
/// Returns true if both selected cards match; false otherwise.
bool checkForMatch(board, row, col, firstSelectedRow, firstSelectedCol) {
  if (board[row][col] == board[firstSelectedRow!][firstSelectedCol!]) {
    return true;
  } else {
    return false;
  }
}

/// Handles the game state after a successful match is found.
/// If all pairs are matched, it determines the winner.
///
/// [board] - Game board with image paths
/// [row], [col] - Second selected card coordinates
/// [firstSelectedRow], [firstSelectedCol] - First selected card coordinates
/// [matchedPairs] - Number of matched pairs found so far
/// [players] - List of Player objects
/// [playerScores] - List of player scores
/// [currentPlayerIndex] - Index of the current player
///
/// Returns true if the game has ended (all pairs matched), otherwise false.
bool handleMatch(
    board,
    row,
    col,
    firstSelectedRow,
    firstSelectedCol,
    matchedPairs,
    players,
    playerScores,
    currentPlayerIndex,
    ) {
  // If all 8 pairs have been matched, the game ends and the winner is determined
  if (matchedPairs == 8) {
    determineWinner(players, playerScores);
    return true;
  } else {
    return false;
  }
}
