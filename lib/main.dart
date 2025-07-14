import 'package:android_game_2025/game_setup_template.dart';
import 'package:android_game_2025/tictactoe.dart';
import 'package:android_game_2025/game_definition.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class ButtonList extends StatelessWidget {
  const ButtonList({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <GameDefinition>[
      TicTacToePage.gameDef,
      // add more games here...
    ];
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        GameDefinition game = games[index];
        return Padding(padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameSetupTemplate(
                    gameDef: game,
                  ),
                ),
              );
            },
            child: Text(game.name),
          ),
        );
      },
    );
  }
}

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