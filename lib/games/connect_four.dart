import 'dart:math';
import 'package:flutter/material.dart';

import '../templates/game_screen_template.dart';
import '../templates/player.dart';
import '../templates/game_definition.dart';

class ConnectFour extends StatefulWidget {
  final List<Player> players;
  static final GameDefinition gameDef = GameDefinition(
    name: 'ConnectFour',
    minPlayers: 2,
    maxPlayers: 2,
    gameBuilder: (players, gameDef, onExitConfirmed) => ConnectFour(players: players, onExit: onExitConfirmed),
  );
  final VoidCallback onExit;

  const ConnectFour({
    super.key,
    required this.players,
    required this.onExit,
  });

  @override
  State<ConnectFour> createState() => _ConnectFourState();
}

class _ConnectFourState extends State<ConnectFour> {
  static const int rows = 6;
  static const int columns = 7;
  late List<List<Color?>> board;
  int currentPlayerIndex = 0;
  Player? winner;

  List<Player> get players => widget.players;
  Player get currentPlayer => players[currentPlayerIndex];
  Color get currentColor => currentPlayerIndex == 0 ? Colors.red : Colors.yellow;

  @override
  void initState() {
    super.initState();
    board = List.generate(rows, (_) => List.filled(columns, null));
    currentPlayerIndex = Random().nextInt(players.length);
  }

  void _resetGame() {
    setState(() {
      board = List.generate(rows, (_) => List.filled(columns, null));
      currentPlayerIndex = 0;
      winner = null;
    });
  }

  void _endGame() {
    _resetGame();
    navigateToGameOverScreen(
      context,
      ConnectFour.gameDef,
      widget.players,
    );
  }

  void _insertChip(int column) {
    for (int row = rows - 1; row >= 0; row--) {
      if (board[row][column] == null) {
        setState(() {
          board[row][column] = currentColor;
          if (_checkWin(row, column, currentColor)) {
            currentPlayer.score++;
            winner = currentPlayer;
            _endGame();
          } else {
            currentPlayerIndex = (currentPlayerIndex + 1) % 2;
          }
        });
        return;
      }
    }
  }

  bool _checkWin(int row, int col, Color color) {
    return _countInDirection(row, col, 0, 1, color) + _countInDirection(row, col, 0, -1, color) > 2 || // horizontal
        _countInDirection(row, col, 1, 0, color) > 2 || // vertical
        _countInDirection(row, col, 1, 1, color) + _countInDirection(row, col, -1, -1, color) > 2 || // diagonal right
        _countInDirection(row, col, 1, -1, color) + _countInDirection(row, col, -1, 1, color) > 2; // diagonal left
  }

  int _countInDirection(int row, int col, int rowDelta, int colDelta, Color color) {
    int count = 0;
    int r = row + rowDelta;
    int c = col + colDelta;

    while (r >= 0 && r < rows && c >= 0 && c < columns && board[r][c] == color) {
      count++;
      r += rowDelta;
      c += colDelta;
    }

    return count;
  }

  String _getPlayerColorName(Color color) {
     return color == Colors.red ? "Rot" : "Gelb";
  }

  Widget _buildCell(Color? color) {
    Color circleColor = color ?? Colors.grey.shade300;
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
        border: Border.all(color: Colors.black26),
      ),
      width: 40,
      height: 40,
    );
  }

  Widget _buildBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double restartButtonHeight = 60;
        const double cellMargin = 2;

        // Determine the max size that the board can be (based on smallest dimension)
        double availableHeight = constraints.maxHeight - restartButtonHeight;
        double availableWidth = constraints.maxWidth;

        double cellWidth = (availableWidth - columns * cellMargin * 2) / columns;
        double cellHeight = (availableHeight - (rows + 1) * cellMargin * 2) / (rows + 1);
        double cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

        return Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top clickable row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(columns, (col) {
                        return GestureDetector(
                          onTap: () => _insertChip(col),
                          child: Container(
                            width: cellSize,
                            height: cellSize,
                            margin: const EdgeInsets.all(cellMargin),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              border: Border.all(color: Colors.black),
                            ),
                            child: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    // Game grid
                    Column(
                      children: List.generate(rows, (row) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(columns, (col) {
                            return Container(
                              width: cellSize,
                              height: cellSize,
                              margin: const EdgeInsets.all(cellMargin),
                              child: _buildCell(board[row][col]),
                            );
                          }),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: restartButtonHeight,
              width: double.infinity,
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


  @override
  Widget build(BuildContext context) {
    return GameScreenTemplate(
      players: players,
      currentPlayerNameFunction: () =>
      '${currentPlayer.name} (${_getPlayerColorName(currentColor)})',
      onExitConfirmed: widget.onExit,
      board: _buildBoard(),
    );
  }
}
