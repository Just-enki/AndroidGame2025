import 'package:android_game_2025/game_definition.dart';
import 'package:android_game_2025/game_over_template.dart';
import 'package:flutter/material.dart';

void navigateToGameOverScreen(BuildContext context, GameDefinition gameDef, List<String> playerNames, Map<String, int>? finalScores) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => GameOverTemplate(
        gameDef: gameDef,
        playerNames: playerNames,
        finalScores: finalScores,
      ),
    ),
  );
}

class GameScreenTemplate extends StatefulWidget {
  final List<String> players;
  final VoidCallback onExitConfirmed;
  final Widget board;

  const GameScreenTemplate({
    super.key,
    required this.players,
    required this.onExitConfirmed,
    required this.board,
  });

  @override
  State<GameScreenTemplate> createState() => _GameScreenTemplateState();
}

class _GameScreenTemplateState extends State<GameScreenTemplate> {
  int currentPlayerIndex = 0;

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Spiel beenden?'),
        content: const Text('Bist du sicher, dass du das laufende Spiel verlassen möchtest?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onExitConfirmed();
            },
            child: const Text('Ja, beenden'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Am Zug: ${widget.players[currentPlayerIndex]}';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmationDialog(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: widget.board,
        ),
      ),
    );
  }
}
