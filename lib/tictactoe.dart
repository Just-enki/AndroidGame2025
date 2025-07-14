import 'package:android_game_2025/game_screen_template.dart';
import 'package:android_game_2025/player.dart';
import 'package:flutter/material.dart';
import 'game_definition.dart';

class TicTacToe extends StatefulWidget {
  final List<Player> players;
  static final GameDefinition gameDef = GameDefinition(
    name: 'TicTacToe',
    minPlayers: 2,
    maxPlayers: 2,
    gameBuilder: (players, gameDef, onExitConfirmed) => TicTacToe(players: players, onExit: onExitConfirmed),
  );
  final VoidCallback onExit;

  const TicTacToe({
    super.key,
    required this.players,
    required this.onExit,
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
        ElevatedButton(onPressed: _resetGame, child: const Text('Neustart')),
      ],
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
      onExitConfirmed: widget.onExit,
      board: _buildBoard(),
    );
  }
}
