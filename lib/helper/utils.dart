import 'dart:math';

import 'package:android_game_2025/helper/player.dart';

/// Returns a random player index between 0 and [playerCount - 1].
///
/// This function is typically used to determine which player starts the game.
/// It is useful in game setup screens or when a new round begins.
int getRandomStartPlayerIndex(int playerCount) {
  return Random().nextInt(playerCount);
}

/// Returns a random player index based on the size of the player list.
///
/// This is a variant of [getRandomStartPlayerIndex] that works directly
/// with a list of [Player] objects instead of just a count.
/// Used in dynamic player setups.
int getRandomStartPlayerIndexFromListOfPlayer(List<Player> player) {
  return Random().nextInt(player.length);
}

/// Selects a random player from the list and returns the [Player] object.
///
/// This is useful when the game logic needs the player instance directly
/// (e.g. for display or manipulation), rather than just their index.
Player getRandomStartPlayer(List<Player> player) {
  return player[Random().nextInt(player.length)];
}

/// Determines the next player index in a circular turn sequence.
///
/// If the current index is the last player, it wraps around to 0.
/// For example, in a 3-player game: 0 → 1 → 2 → 0.
///
/// This logic is used after each turn to switch the active player.
int getNextPlayerIndex(int currentIndex, int totalPlayers) {
  return (currentIndex + 1) % totalPlayers;
}

/// Variant of [getNextPlayerIndex] that uses a [List<Player>] for total count.
///
/// Used in games where player objects are passed instead of a simple number.
/// Ensures turn management is compatible with the actual player list.
int getNextPlayerIndexFromListOfPlayer(int currentIndex, List<Player> player) {
  return (currentIndex + 1) % player.length;
}

/// Identifies the indices of players who have the highest score.
///
/// Useful in score-based games where multiple players may tie.
/// This method returns a list of indices that match the highest score.
///
/// The returned list can be used to highlight the winner(s) in the UI
/// or to trigger special logic for tie-breakers or multi-winner games.
List<int> getWinnersFromScores(List<int> scores) {
  if (scores.isEmpty) return [];

  int maxScore = scores.reduce(max);
  List<int> winners = [];

  for (int i = 0; i < scores.length; i++) {
    if (scores[i] == maxScore) {
      winners.add(i);
    }
  }

  return winners;
}

/// Checks whether a 2D game board (e.g. Tic Tac Toe or Connect Four)
/// is completely filled with no empty cells left.
///
/// This function is used to detect draw conditions (i.e. no winner
/// and no available moves). If any cell is still empty (''), the
/// function returns false.
///
/// Can be used to disable interaction or trigger a game-over screen.
bool isTwoDimensionalArrayFull(List<List<String>> array) {
  for (var row in array) {
    if (row.contains('')) return false;
  }
  return true;
}
