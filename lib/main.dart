import 'package:flutter/material.dart';

import 'games/connect_four/connect_four.dart';
import 'games/tictactoe/tictactoe.dart';
import 'games/memory/memory.dart';
import 'templates/game_setup_template.dart';
import 'helper/game_definition.dart';


void main() => runApp(const MainPage());

class ButtonList extends StatelessWidget {
  const ButtonList({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <GameDefinition>[
      TicTacToe.gameDef,
      ConnectFour.gameDef,
      Memory.gameDef
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
                  builder: (_) =>
                      GameSetupTemplate(
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

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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