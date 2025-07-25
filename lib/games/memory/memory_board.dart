import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'memory_cell.dart';

/// Widget that renders the Memory board.
class MemoryBoard extends StatelessWidget {
  final List<List<String>> board;
  final List<List<bool>> revealed;
  final void Function(int row, int col) onCellTap;
  final VoidCallback onReset;
  final String? winner;

  const MemoryBoard({
    required this.board,
    required this.revealed,
    required this.onCellTap,
    required this.onReset,
    this.winner,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 60;
    const double margin = 4;
    const double borderWidth = 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        double boardSize = constraints.maxHeight - buttonHeight;
        boardSize = boardSize > constraints.maxWidth ? constraints.maxWidth : boardSize;

        double cellSize = (boardSize - (margin * 2) * 4) / 4;

        return Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(4, (i) =>
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(4, (j) =>
                            MemoryCell(
                              value: board[i][j],
                              imageAsset: board[i][j],
                              isRevealed: revealed[i][j],
                              onTap: () => onCellTap(i, j),
                              i: i,
                              j: j,
                              board: board,
                              revealed: revealed,
                              cellSize: cellSize,
                              borderWidth: borderWidth
                            )
                        ),
                      ),
                  ),
                ),
              ),
            ),
            if (winner != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Winner: $winner!',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: onReset,
                child: const Text('Restart'),
              ),
            ),
          ],
        );
      },
    );
  }
}
