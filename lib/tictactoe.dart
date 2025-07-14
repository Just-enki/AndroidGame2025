import 'dart:io';

import 'package:android_game_2025/game_start_template.dart';
import 'package:flutter/material.dart';
import 'package:android_game_2025/game_over.dart';
import 'package:android_game_2025/player.dart';

class TicTacToePage extends StatefulWidget {
  final List<Player> players;

  const TicTacToePage({super.key, required this.players});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  int currentPlayerIndex = 0; // 0 = Player X, 1 = Player O
  String? winner;

  List<Player> get players => widget.players;

  String get currentSymbol => currentPlayerIndex == 0 ? 'X' : 'O';
  Player get currentPlayer => players[currentPlayerIndex];

  void _handleTap(int row, int col) {
    if (board[row][col] != '' || winner != null) return;

    setState(() {
      board[row][col] = currentSymbol;

      if (_checkWin(currentSymbol)) {
        winner = currentPlayer.name;
        currentPlayer.score++;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameOver(players: players),
          ),
        );
      } else if (_isDraw()) {
        winner = 'Draw';
        // Optionally: Navigate or show a dialog for draw.
      } else {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      }
    });
  }

  bool _checkWin(String symbol) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((cell) => cell == symbol) ||
          [0, 1, 2].every((j) => board[j][i] == symbol)) {
        return true;
      }
    }
    return (board[0][0] == symbol && board[1][1] == symbol && board[2][2] == symbol) ||
        (board[0][2] == symbol && board[1][1] == symbol && board[2][0] == symbol);
  }

  bool _isDraw() {
    for (var row in board) {
      if (row.contains('')) return false;
    }
    return true;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (winner != null)
            Text(
              winner == 'Draw' ? 'It\'s a Draw!' : 'Player $winner Wins!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 20),
          _buildBoard(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (j) {
            return GestureDetector(
              onTap: () => _handleTap(i, j),
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 2),
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
        );
      }),
    );
  }
}
