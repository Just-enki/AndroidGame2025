import 'package:android_game_2025/game_template.dart';
import 'package:android_game_2025/tictactoe.dart';
import 'package:android_game_2025/game_start_template.dart';
import 'package:flutter/material.dart';
import 'package:android_game_2025/game_over.dart';
import 'package:android_game_2025/player.dart';

void main() => runApp(const MyApp());

class ButtonList extends StatelessWidget {
  const ButtonList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = ["GameSetupTemplate", "GameOver", "Item 3", "Item 4", "Item 5"];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        return Padding(padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (index == 0) { //OR if item == "item 1"
                // Navigate to TicTacToePage for "Item 1"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameSetupTemplate(title: 'TicTacToe', minPlayers: 2, maxPlayers: 2)),
                );
              }
              if (index == 1) { //OR if item == "item 1"
                // Navigate to GameOver for "Item 2"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameOver(players: players)),
                );
              }/*
              // triggers no matter what??
              if (index != 0 || index != 1){
                // All other items go to GameTemplate
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameTemplate()),
                );
              }*/
            },
            child: Text(item),
          ),
        );
      },
    );
  }
}
//dummy player list
final List<Player> players = [
  Player(name: 'player_one', score: 420),
  Player(name: 'player_two', score: 69),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Game Selection';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: const Center(
          child: ButtonList(
            key: Key('buttonList'),
          ),
        ),
      )
    );
  }
}