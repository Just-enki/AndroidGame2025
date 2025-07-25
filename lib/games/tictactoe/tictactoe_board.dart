import 'package:flutter/material.dart';

import 'tictactoe_cell.dart';

/// A stateless widget responsible for rendering the Tic Tac Toe game board UI.
///
/// This widget builds a 3x3 grid of `TicTacToeCell` widgets based on the
/// current board state. It also includes a "Restart" button to allow players
/// to reset the game manually.
///
/// Interaction:
/// - When a player taps on a cell, `onCellTap` is triggered with its
/// coordinates.
/// - When the restart button is pressed, `onRestart` resets the board state.
class TicTacToeBoard extends StatelessWidget {
  // A 3x3 matrix representing the current game state.
  // Each cell contains '', 'X', or 'O'.
  final List<List<String>> board;

  // Callback triggered when a cell is tapped.
  // Receives the (row, col) index of the tapped cell.
  final void Function(int row, int col) onCellTap;

  // Callback triggered when the restart button is pressed.
  final void Function() onRestart;

  const TicTacToeBoard({
    required this.board,
    required this.onCellTap,
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dimensions and spacing for board layout
        double restartButtonHeight = 60; // Reserved space for restart button
        double margin = 4; // Margin between each cell
        double borderWidth = 3; // Border thickness for cells

        // Calculate maximum available square space for the board
        double boardSize = constraints.maxHeight - restartButtonHeight;
        boardSize = boardSize > constraints.maxWidth
            ? constraints.maxWidth
            : boardSize;

        // Calculate size of each square cell based on available space and
        // margins
        double cellSize = (boardSize - (margin * 2) * 3) / 3;

        // The overall layout is a vertical column: [Grid | Restart Button]
        return Column(
          children: [
            // The main 3x3 game grid
            Expanded(
              child: Center(
                child: Column(
                  children: List.generate(3, (row) {
                    // Each row is rendered as a Row widget with 3 cells
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (col) {
                        return Expanded(
                          // Ensures the cell is a square by enforcing a 1:1
                          // aspect ratio
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: TicTacToeCell(
                              // Symbol to be rendered in the cell (X, O, or
                              // empty)
                              value: board[row][col],
                              cellSize: cellSize,
                              margin: margin,
                              borderWidth: borderWidth,
                              // When tapped, notify the parent with cell
                              // position
                              onTap: () => onCellTap(row, col),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),

            // Restart button aligned at the bottom of the screen
            SizedBox(
              width: double.infinity,
              height: restartButtonHeight,
              child: ElevatedButton(
                onPressed: onRestart, // Resets the game when tapped
                child: const Text('Neustart'),
              ),
            ),
          ],
        );
      },
    );
  }
}
