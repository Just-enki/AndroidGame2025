import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  String? winner;

  void _handleTap(int row, int col) {
    if (board[row][col] != '' || winner != null) return;

    setState(() {
      board[row][col] = currentPlayer;
      if (_checkWin(currentPlayer)) {
        winner = currentPlayer;
      } else if (_isDraw()) {
        winner = 'Draw';
      } else {
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      }
    });
  }

  bool _checkWin(String player) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((cell) => cell == player) ||
          [0, 1, 2].every((j) => board[j][i] == player)) {
        return true;
        //TODO: if win Redirect to game_over
      }
    }
    return (board[0][0] == player && board[1][1] == player && board[2][2] == player) ||
        (board[0][2] == player && board[1][1] == player && board[2][0] == player);
  }

  bool _isDraw() { //TODO: Redirect to game_over
    for (var row in board) {
      if (row.contains('')) return false;
    }
    return true;
  }

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
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
