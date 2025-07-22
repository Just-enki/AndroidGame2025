import 'package:flutter/material.dart';

import 'game_definition.dart';
import 'game_over_template.dart';
import 'game_setup_template.dart';
import 'player.dart';

void navigateToGameOverScreen(BuildContext context, GameDefinition gameDef, List<Player> players) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => GameOverTemplate(
        gameDef: gameDef,
        players: players,
      ),
    ),
  );
}

void navigateToGameSetupScreen(BuildContext context, GameDefinition gameDef) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => GameSetupTemplate(
        gameDef: gameDef,
      ),
    ),
  );
}

class GameScreenTemplate extends StatefulWidget {
  final List<Player> players;
  final String Function() currentPlayerNameFunction;
  final GameDefinition gameDefinition;
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
    final title = 'Am Zug: ${widget.currentPlayerNameFunction()}';

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
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: widget.board,
            )
          )
        ),
      ),
    );
  }
}
