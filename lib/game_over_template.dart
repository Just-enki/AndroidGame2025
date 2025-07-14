import 'package:flutter/material.dart';
import 'game_setup_template.dart';
import 'game_definition.dart';

class GameOverTemplate extends StatelessWidget {
  final GameDefinition gameDef;
  final List<String> playerNames;
  final Map<String, int>? finalScores;
  const GameOverTemplate({
    super.key,
    required this.gameDef,
    required this.playerNames,
    this.finalScores,
  });

  void _goToSetup(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameSetupTemplate(
          gameDef: gameDef,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over!'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goToSetup(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Rangliste',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (finalScores != null)
              ...finalScores!.entries.map((e) => Text(
                    '${e.key}: ${e.value} Punkte',
                    style: const TextStyle(fontSize: 18),
                  )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _goToSetup(context),
                child: const Text('Erneut spielen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}