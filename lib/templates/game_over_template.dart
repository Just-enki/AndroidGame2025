import 'package:flutter/material.dart';

import 'game_setup_template.dart';

import '../helper/game_definition.dart';
import '../helper/player.dart';

/// A UI template that is shown after a game has ended.
///
/// Displays a title bar, a leaderboard with scores, and buttons
/// to either go back to setup or replay the same game.
/// This screen provides a visual closure to a game round and allows
/// the user to choose what to do next.
class GameOverTemplate extends StatelessWidget {
  // Metadata about the game (e.g. name, player limits, and how to rebuild it)
  final GameDefinition gameDef;

  // List of players who participated in the game, including their scores
  final List<Player> players;

  const GameOverTemplate({
    super.key,
    required this.gameDef,
    required this.players,
  });

  /// Navigates to the game setup screen to allow the user to change game
  /// settings or pick a different game type.
  void _goToSetup(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GameSetupTemplate(
              gameDef: gameDef,
            ),
      ),
    );
  }

  /// Restarts the same game with the same players and game definition.
  /// Useful for quick rematches without returning to setup.
  void _goToGame(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => gameDef.gameBuilder(players, gameDef),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title and back navigation to setup
      appBar: AppBar(
        title: const Text('Game Over!'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goToSetup(context),
        ),
      ),

      // Body content includes a leaderboard and "Replay" button
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title text for the ranking section
            const Text(
              'Rangliste',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Display a list of players with their final scores
            Leaderboard(players: players),

            // Button to play the same game again
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _goToGame(context),
                child: const Text('Erneut spielen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays the final ranking of players based on their scores.
///
/// Typically used after a game ends to show how each player performed.
/// Each player's name and score is shown in a list format.
class Leaderboard extends StatelessWidget {
  // The list of players to display (including their current score)
  final List<Player> players;

  const Leaderboard({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: players.map(
            (player) =>
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '${player.name}:   ${player.score} Punkte',
                style: const TextStyle(fontSize: 18),
              ),
            ),
      ).toList(),
    );
  }
}