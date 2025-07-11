import 'package:android_game_2025/game_start_template.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class ButtonList extends StatelessWidget {
  const ButtonList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        return Padding(padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameSetupTemplate(title: 'TicTacToe', minPlayers: 2, maxPlayers: 2)),
              );
            },
            child: Text(item),
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