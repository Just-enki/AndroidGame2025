import 'package:android_game_2025/game_screen_template.dart';
import 'package:flutter/material.dart';
import 'game_definition.dart';

class TicTacToePage extends StatefulWidget {
  final List<String> players;
  static final GameDefinition gameDef = GameDefinition(
    name: 'TicTacToe',
    minPlayers: 2,
    maxPlayers: 2,
    gameBuilder: (players, gameDef, onExitConfirmed) => TicTacToePage(players: players, onExit: onExitConfirmed),
  );
  final VoidCallback onExit;

  const TicTacToePage({
    super.key,
    required this.players,
    required this.onExit,
  });

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  late List<List<String>> board;
  late String currentPlayer;
  String? winner;

  @override
  void initState() {
    super.initState();
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = widget.players.first;
  }

  void _handleTap(int i, int j) {
    bool ended = false;

    if (board[i][j] != '' || winner != null) {
        return;
    }
    setState(() {
      board[i][j] = currentPlayer;
      if (_checkWin(currentPlayer)) {
        winner = currentPlayer;
        ended = true;
      } else if (_isDraw()) {
        winner = 'Draw';
        ended = true;
      } else {
        final idx = widget.players.indexOf(currentPlayer);
        currentPlayer = widget.players[(idx + 1) % widget.players.length];
      }

      if (ended) {
        navigateToGameOverScreen(
          context,
          TicTacToePage.gameDef,
          widget.players,
          null,
        );
      }
    });
  }

  bool _checkWin(String p) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((c) => c == p) ||
          [0, 1, 2].every((j) => board[j][i] == p)) {
        return true;
      }
    }
    return (board[0][0] == p && board[1][1] == p && board[2][2] == p) ||
        (board[0][2] == p && board[1][1] == p && board[2][0] == p);
  }

  bool _isDraw() =>
      board.expand((row) => row).every((cell) => cell.isNotEmpty);

  Widget _buildBoard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (winner != null) ...[
          Text(
            winner == 'Draw' ? 'Unentschieden!' : 'Spieler $winner gewinnt!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
        ],
        ...List.generate(3, (i) =>
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (j) {
              return GestureDetector(
                onTap: () => _handleTap(i, j),
                child: Container(
                  width: 80, height: 80, margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal, width: 2),
                  ),
                  child: Center(
                    child: Text(board[i][j], style: const TextStyle(fontSize: 36)),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _reset, child: const Text('Neustart')),
      ],
    );
  }

  void _reset() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = widget.players.first;
      winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenTemplate(
      players: widget.players,
      onExitConfirmed: widget.onExit,
      board: _buildBoard(),
    );
  }
}
