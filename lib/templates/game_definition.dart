import 'package:flutter/widgets.dart';
import 'player.dart';

class GameDefinition {
  final String name;
  final int minPlayers, maxPlayers;

  final Widget Function (List<Player> players, GameDefinition gameDef, VoidCallback onExitConfirmed)
      gameBuilder;

  const GameDefinition({
    required this.name,
    required this.minPlayers,
    required this.maxPlayers,
    required this.gameBuilder,
  });
}
