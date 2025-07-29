import 'package:flutter/material.dart';

// Import individual game definitions
import 'games/connect_four/connect_four.dart';
import 'games/tictactoe/tictactoe.dart';
import 'games/memory/memory.dart';

import 'templates/game_setup_template.dart';
import 'helper/game_definition.dart';

/// The main entry point of the Flutter app.
///
/// This launches the [MainPage], which allows users to select a game.
void main() => runApp(const MainPage());

/// A stateless widget that builds a scrollable list of available games.
///
/// Each game is represented by a button. When a button is tapped,
/// the user is navigated to the corresponding game setup screen.
///
/// This widget is used as the core content of the home screen.
class ButtonList extends StatelessWidget {
  const ButtonList({super.key});

  @override
  Widget build(BuildContext context) {
    // List of available games, defined statically
    final games = <GameDefinition>[
      TicTacToe.gameDef,
      ConnectFour.gameDef,
      Memory.gameDef
      // Add more games here in the future...
    ];

    // ListView.builder is used to dynamically create buttons for each game
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        GameDefinition game = games[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            // When pressed, navigate to the setup screen for the selected game
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      GameSetupTemplate(
                        gameDef: game, // Pass selected game definition to setup
                      ),
                ),
              );
            },
            // Display the name of the game on the button
            child: Text(game.name),
          ),
        );
      },
    );
  }
}

/// The main screen of the app where the user can select a game to play.
///
/// This widget initializes the app theme and embeds [ButtonList]
/// as the central content. It uses [MaterialApp] to configure
/// navigation and styling for the entire app.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Spielauswahl'; // Title of the app shown in AppBar

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        // Top bar with static title
        appBar: AppBar(title: const Text(appTitle)),

        // Central body with the list of available game buttons
        body: const Center(
          child: ButtonList(),
        ),
      ),
    );
  }
}
