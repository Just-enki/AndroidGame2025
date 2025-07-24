import 'package:flutter/material.dart';
import 'game_setup_template.dart';
import '../helper/game_definition.dart';
import '../helper/player.dart';

class GameOverTemplate extends StatelessWidget {
  final GameDefinition gameDef;
  final List<Player> players;

  const GameOverTemplate({
    super.key,
    required this.gameDef,
    required this.players,
  });

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
            Leaderboard(players: players),
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

class Leaderboard extends StatelessWidget {
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
                '${player.name}:   ${player.score} points',
                style: const TextStyle(fontSize: 18),
              ),
            ),
      ).toList(),
    );
  }
}