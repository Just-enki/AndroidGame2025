import 'package:flutter/material.dart';

import 'game_over_template.dart';
import 'game_setup_template.dart';

import '../helper/player.dart';
import '../helper/game_definition.dart';

/// Navigates to the "Game Over" screen and replaces the current screen.
///
/// This is typically called after a game has ended (either by win or draw).
/// It passes along the game metadata and the final player list
/// including scores.
///
/// Parameters:
/// - [context]: Current navigation context
/// - [gameDef]: The definition of the game that just ended
/// - [players]: List of players who participated in the game
void navigateToGameOverScreen(BuildContext context,
    GameDefinition gameDef,
    List<Player> players,) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) =>
          GameOverTemplate(
            gameDef: gameDef,
            players: players,
          ),
    ),
  );
}

/// Navigates to the game setup screen, replacing the current screen.
///
/// Called when a user wants to abandon a running game and return to the
/// setup phase.
///
/// Parameters:
/// - [context]: Current navigation context
/// - [gameDef]: The definition of the game to configure
void navigateToGameSetupScreen(BuildContext context,
    GameDefinition gameDef,) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) =>
          GameSetupTemplate(
            gameDef: gameDef,
          ),
    ),
  );
}

/// A reusable screen template used to structure all game UIs.
///
/// Provides a consistent layout across all games including:
/// - A top AppBar showing the current player's turn
/// - A back button with a confirmation dialog
/// - A central area where the game board widget is injected
///
/// This class improves modularity and keeps game-specific UI code minimal.
class GameScreenTemplate extends StatefulWidget {
  // List of players participating in the current game
  final List<Player> players;

  // Function that returns the display string for the current player's turn
  final String Function() currentPlayerNameFunction;

  // Definition of the current game (metadata and factory method)
  final GameDefinition gameDefinition;

  // The widget that displays the actual game board (e.g., Tic Tac Toe grid)
  final Widget board;

  const GameScreenTemplate({
    super.key,
    required this.players,
    required this.currentPlayerNameFunction,
    required this.gameDefinition,
    required this.board,
  });

  @override
  State<GameScreenTemplate> createState() => _GameScreenTemplateState();
}

/// State object for `GameScreenTemplate`, handles app bar logic and
/// displays the injected game board widget.
class _GameScreenTemplateState extends State<GameScreenTemplate> {
  // Tracks the index of the current player (if needed for extended use)
  int currentPlayerIndex = 0;

  /// Shows a confirmation dialog when the user attempts to exit the game.
  ///
  /// Prevents accidental loss of progress by asking for confirmation before
  /// navigating
  /// back to the setup screen. This dialog appears when the back arrow is
  /// tapped.
  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text('Spiel beenden?'),
            content: const Text(
              'Bist du sicher, dass du das laufende Spiel verlassen möchtest?',
            ),
            actions: [
              // Cancel button simply closes the dialog
              TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: const Text('Abbrechen'),
              ),

              // Confirm button navigates back to game setup
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  navigateToGameSetupScreen(context, widget.gameDefinition);
                },
                child: const Text('Ja, beenden'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display title includes current player's name (e.g. "Am Zug: Alice (X)")
    final title = 'Am Zug: ${widget.currentPlayerNameFunction()}';

    return Scaffold(
      // Top bar showing current player and back button
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmationDialog(context),
        ),
      ),

      // Main game content area
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,

            // Center the game board widget in the screen
            child: Center(
              child: widget.board,
            ),
          ),
        ),
      ),
    );
  }
}
