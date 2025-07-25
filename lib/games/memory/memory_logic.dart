import 'package:android_game_2025/helper/utils.dart';
/// players  List<Player> get players => widget.players;
/// playerScores
///

void determineWinner(players, playerScores) {
  List<int> winners = getWinnersFromScores(playerScores);

  for (var j = 0; j < winners.length; j++) {
    players[winners[j]].incrementScore();
  }
//TODO: fix me
void checkMatch(board, row, col, firstSelectedRow, firstSelectedCol, currentPlayerIndex, matchedPairs ){
  if (board[row][col] == board[firstSelectedRow!][firstSelectedCol!]) {
    playerScores[currentPlayerIndex]++;
    matchedPairs++;
  }
}

}