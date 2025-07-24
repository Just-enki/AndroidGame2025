import 'dart:math';

import 'package:android_game_2025/helper/player.dart';

/// Returns a random player index between 0 and [playerCount - 1].
int getRandomStartPlayerIndex(int playerCount) {
  return Random().nextInt(playerCount);
}

/// Returns a random player index between 0 and [player.length - 1].
int getRandomStartPlayerIndexFromListOfPlayer(List<Player> player) {
  return Random().nextInt(player.length);
}

/// Returns a random player between 0 and [player.length - 1].
Player getRandomStartPlayer(List<Player> player) {
  return player[Random().nextInt(player.length)];
}

/// Returns the next player's index in a circular fashion.
/// For example, from 0 → 1 → 2 → 0 (if [totalPlayers] = 3).
int getNextPlayerIndex(int currentIndex, int totalPlayers) {
  return (currentIndex + 1) % totalPlayers;
}

/// Returns the next player's index in a circular fashion.
/// For example, from 0 → 1 → 2 → 0 (if [player.length] = 3).
int getNextPlayerIndexFromListOfPlayer(int currentIndex, List<Player> player) {
  return (currentIndex + 1) % player.length;
}

/// Returns a list of player indices with the highest score.
/// Useful for determining winners in point-based games.
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
