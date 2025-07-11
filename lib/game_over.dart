import 'package:flutter/material.dart';
import 'package:android_game_2025/main.dart';
//TODO: import all games?
import 'package:android_game_2025/tictactoe.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key});

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
              const Leaderboard(), // insert leaderboard
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //TODO: return to the correct game, use context? variable?
                        builder: (context) => const TicTacToePage(),
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
  const Leaderboard({super.key});

  @override
  //TODO: convert players to objects?  e.g. player.name; player.score;
  Widget build(BuildContext context) {
    final int p1points = 10;
    final int p2points = 3;
    final String p1 = "player 1";
    final String p2 = "player 2";

    //static for now
    final List<String> players = [
      "$p1:   $p1points points",
      "$p2:   $p2points points",
    ];
    // display leaderboard as column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: players.map(
            (player) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            player,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ).toList(),
    );
  }
}
