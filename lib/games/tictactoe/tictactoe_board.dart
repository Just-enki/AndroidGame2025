import 'package:flutter/material.dart';
import 'tictactoe_cell.dart';

/// Widget that renders the Tic Tac Toe board.
class TicTacToeBoard extends StatelessWidget {
  final List<List<String>> board;
  final void Function(int row, int col) onCellTap;

  const TicTacToeBoard(
      {required this.board, required this.onCellTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          children: List.generate(3, (col) {
            return Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: TicTacToeCell(
                  value: board[row][col],
                  onTap: () => onCellTap(row, col),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
