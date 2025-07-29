import 'package:flutter/material.dart';

import '../main.dart';

import '../helper/game_definition.dart';
import '../helper/player.dart';

/// Navigates back to the game setup screen for the selected game type.
///
/// This method is used when returning from another screen (e.g. Game Over).
void navigateBackToGameSetupScreen(BuildContext context,
    GameDefinition gameDef,) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => GameSetupTemplate(gameDef: gameDef),
    ),
  );
}

/// A reusable setup screen where users can configure player names and
/// prepare the game before it starts.
///
/// This template adapts to the given [GameDefinition] and displays dynamic
/// input fields for each player, along mit buttons to add/remove players and
/// a “Start Game” button that validates and launches the actual game.
class GameSetupTemplate extends StatefulWidget {
  final GameDefinition gameDef;

  const GameSetupTemplate({
    super.key,
    required this.gameDef,
  });

  @override
  State<GameSetupTemplate> createState() => _GameSetupTemplateState();
}

class _GameSetupTemplateState extends State<GameSetupTemplate> {
  final List<TextEditingController> _controllers = []; // Player name fields
  final List<Player> _players = []; // Associated player objects

  @override
  void initState() {
    super.initState();

    // Initialize the minimum required players with default names
    for (int i = 0; i < widget.gameDef.minPlayers; i++) {
      final controller = TextEditingController(text: 'Spieler ${i + 1}');
      _controllers.add(controller);
      _players.add(Player(name: controller.text));

      // Keep player object in sync with text field input
      controller.addListener(() {
        _players[i].name = controller.text;
      });
    }
  }

  /// Navigates back to the main screen (game selection)
  void _goToMainPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainPage()),
    );
  }

  /// Adds another player entry if under the max player limit.
  void _addPlayer() {
    if (_players.length < widget.gameDef.maxPlayers) {
      setState(() {
        final index = _players.length;
        final controller = TextEditingController(text: 'Spieler ${index + 1}');
        _controllers.add(controller);
        _players.add(Player(name: controller.text));

        controller.addListener(() {
          _players[index].name = controller.text;
        });
      });
    }
  }

  /// Removes a player entry unless it violates the minimum player requirement.
  void _removePlayer(int index) {
    if (_players.length > widget.gameDef.minPlayers) {
      setState(() {
        _controllers[index].dispose();
        _controllers.removeAt(index);
        _players.removeAt(index);
      });
    } else {
      _showMessage(
          "Mindestens ${widget.gameDef.minPlayers} Spieler werden benötigt.");
    }
  }

  /// Starts the game if all validation rules are passed:
  /// - No empty names
  /// - No duplicate names
  /// - Player count within valid bounds
  void _startGame() {
    final playerNames = _controllers
        .map((controller) => controller.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (playerNames
        .toSet()
        .length < playerNames.length) {
      _showMessage("Spielernamen müssen eindeutig sein.");
      return;
    }

    if (playerNames.length < widget.gameDef.minPlayers) {
      _showMessage(
          "Mindestens ${widget.gameDef.minPlayers} Spieler erforderlich.");
      return;
    }

    if (playerNames.length > widget.gameDef.maxPlayers) {
      _showMessage("Maximal ${widget.gameDef.maxPlayers} Spieler erlaubt.");
      return;
    }

    // Proceed to game screen with validated player list
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => widget.gameDef.gameBuilder(_players, widget.gameDef),
      ),
    );
  }

  /// Displays a small error/info message at the bottom of the screen.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // Properly dispose controllers to avoid memory leaks
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with game name and back button to main menu
      appBar: AppBar(
        title: Text(widget.gameDef.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goToMainPage(context),
        ),
      ),

      // Main body with player configuration and start button
      body: Column(
        children: [
          // Header row with title and add-player button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Spieler:',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                if (_controllers.length < widget.gameDef.maxPlayers)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addPlayer,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // List of text fields for each player's name
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      // Name input field for each player
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Spieler ${index + 1}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Button to remove a player from the list
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _removePlayer(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Spacer(),

          // Start game button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _startGame,
                child: const Text(
                  "Spiel starten",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
