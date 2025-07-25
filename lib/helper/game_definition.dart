import 'package:flutter/widgets.dart';

import 'player.dart';

/// A data model that defines the structure and requirements of a game
/// within the app framework.
///
/// This class is used to store general information about a game type
/// (e.g. Tic Tac Toe, Connect Four) and provides a way to instantiate the
/// actual game widget
/// with the proper number of players and metadata.
///
/// GameDefinition is typically used in setup screens, game launchers,
/// or when passing metadata between screens (e.g. to Game Over screens).
class GameDefinition {
  // The name of the game, shown in the UI and used for identification.
  final String name;

  // The minimum and maximum number of players required to play this game.
  final int minPlayers, maxPlayers;

  // A factory-like function that returns the widget used to render and run the
  // game.
  // It takes the list of participating players and this GameDefinition instance
  // as input and returns the actual game screen widget
  // (e.g. TicTacToe, ConnectFour).
  final Widget Function(List<
      Player> players, GameDefinition gameDef) gameBuilder;

  /// Constructs a new GameDefinition.
  ///
  /// Parameters:
  /// - [name]: The display name of the game.
  /// - [minPlayers]: The minimum number of players required.
  /// - [maxPlayers]: The maximum number of players allowed.
  /// - [gameBuilder]: A function that creates the corresponding game widget.
  ///
  /// This class enables dynamic configuration of games and decouples game setup
  /// from individual game screen implementations.
  const GameDefinition({
    required this.name,
    required this.minPlayers,
    required this.maxPlayers,
    required this.gameBuilder,
  });
}
