import 'package:flutter/material.dart';
import 'package:android_game_2025/main.dart';
//TODO: import all games?
import 'package:android_game_2025/tictactoe.dart';
import 'package:android_game_2025/player.dart';
import 'package:android_game_2025/game_start_template.dart'; //TODO: has players, move to separate file?

class GameOver extends StatelessWidget {
  final List<Player> players;

  const GameOver({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Game Over!';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ButtonList()), // redirect back to main screen
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Leaderboard',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Leaderboard(players: players), // insert leaderboard, pass players
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //TODO: return to the correct game, use context? variable?
                        builder: (context) => TicTacToePage(players: players),
                      ),
                    );
                  },
                  child: const Text('Play again'),
                ),
              ),
            ],
          ),
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
            (player) => Padding(
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

