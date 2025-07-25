import 'dart:math';
import 'package:flutter/material.dart';

import '../templates/game_screen_template.dart';
import '../templates/player.dart';
import '../templates/game_definition.dart';

class TicTacToe extends StatefulWidget {
  final List<Player> players;
  static final GameDefinition gameDef = GameDefinition(
    name: 'TicTacToe',
    minPlayers: 2,
    maxPlayers: 2,
    gameBuilder: (players, gameDef) => TicTacToe(players: players),
  );

  const TicTacToe({
    super.key,
    required this.players,
  });

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late List<List<String>> board;
  int currentPlayerIndex = 0;
  List<Player> get players => widget.players;
  String get currentSymbol => currentPlayerIndex == 0 ? 'X' : 'O';
  Player get currentPlayer => players[currentPlayerIndex];
  String? winner;

  @override
  void initState() {
    super.initState();
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayerIndex = Random().nextInt(players.length);
  }

  void _handleTap(int i, int j) {
    bool ended = false;

    if (board[i][j] != '' || winner != null) {
        return;
    }
    setState(() {
      board[i][j] = currentSymbol;
      if (_checkWin(currentSymbol)) {
        currentPlayer.score++;
        winner = currentPlayer.name;
        ended = true;
      } else if (_isDraw()) {
        winner = 'Draw';
        ended = true;
      } else {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      }

      if (ended) {
        _resetGame();
        navigateToGameOverScreen(
          context,
          TicTacToe.gameDef,
          widget.players,
        );
      }
    });
  }

  bool _checkWin(String symbol) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((c) => c == symbol) ||
          [0, 1, 2].every((j) => board[j][i] == symbol)) {
        return true;
      }
    }
    return (board[0][0] == symbol && board[1][1] == symbol && board[2][2] == symbol) ||
        (board[0][2] == symbol && board[1][1] == symbol && board[2][0] == symbol);
  }

  bool _isDraw() =>
      board.expand((row) => row).every((cell) => cell.isNotEmpty);

  Widget _buildBoard() {
    return LayoutBuilder(
        builder: (context, constraints) {
          // Determine the max size that the board can be (based on smallest dimension)
          double restartButtonHeight = 60;
          double margin = 4;
          double borderWidth = 3;
          double boardSize = constraints.maxHeight - restartButtonHeight;
          boardSize = boardSize > constraints.maxWidth ? constraints.maxWidth : boardSize;

          double cellSize = (boardSize - (margin * 2) * 3) / 3;

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) =>
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (j) {
                            return GestureDetector(
                              onTap: () => _handleTap(i, j),
                              child: Container(
                                width: cellSize,
                                height: cellSize,
                                margin: EdgeInsets.all(margin),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: borderWidth),
                                ),
                                child: Center(
                                  child: Text(
                                    board[i][j],
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: restartButtonHeight,
                child: ElevatedButton(
                  onPressed: _resetGame,
                  child: const Text('Neustart'),
                ),
              ),
            ],
          );
        },
    );
  }


  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayerIndex = 0;
      winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenTemplate(
      players: widget.players,
      currentPlayerNameFunction: () => currentPlayer.name,
      gameDefinition: TicTacToe.gameDef,
      board: _buildBoard(),
    );
  }
}
