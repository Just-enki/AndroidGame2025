import 'package:android_game_2025/helper/utils.dart';


/// players  List<Player> get players => widget.players;
/// playerScores
///
void determineWinner(players, playerScores) {
  List<int> winners = getWinnersFromScores(playerScores);

  for (var j = 0; j < winners.length; j++) {
    players[winners[j]].incrementScore();
  }

}
int incrementScore(playerScores,currentPlayerIndex,matchedPairs){
  playerScores[currentPlayerIndex]++;
  return  matchedPairs + 1;
}

bool checkForMatch(board, row , col, firstSelectedRow, firstSelectedCol){
  if (board[row][col] == board[firstSelectedRow!][firstSelectedCol!]) {
    return true;
  }
  else {
    return false;
  }
}

bool handleMatch(board, row , col, firstSelectedRow, firstSelectedCol, matchedPairs, players, playerScores, currentPlayerIndex) {

  if (matchedPairs == 8) {
    determineWinner(players, playerScores);
    return true;
    //_endGame();
  }
  else {
    return false;
  }
}