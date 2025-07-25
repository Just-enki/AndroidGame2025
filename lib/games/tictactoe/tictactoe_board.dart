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
        // Layout constants
        double restartButtonHeight = 60; // Fixed height for the restart button
        double margin = 4; // Margin around each cell
        double borderWidth = 3; // Thickness of cell borders

        // Use the smaller of width or height to create a square game board.
        // In landscape mode, subtract the button height to avoid overflow.
        final double shortestSide = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight - restartButtonHeight - 16;

        // The layout is a vertical column: [game grid] + [restart button]
        return Column(
          children: [
            // The game grid occupies all remaining vertical space
            Expanded(
              child: Center(
                child: SizedBox(
                  width: shortestSide,
                  height: shortestSide,

                  // Build a 3x3 grid using nested Columns and Rows
                  child: Column(
                    children: List.generate(3, (row) {
                      return Expanded(
                        child: Row(
                          children: List.generate(3, (col) {
                            return Expanded(
                              child: AspectRatio(
                                aspectRatio: 1, // ensures square shape
                                child: TicTacToeCell(
                                  value: board[row][col], // X, O, or ''
                                  margin: margin, // cell spacing
                                  borderWidth: borderWidth, // border style
                                  onTap: () =>
                                      onCellTap(row, col), // interaction
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            // A button fixed at the bottom to reset the game state
            SizedBox(
              width: double.infinity,
              height: restartButtonHeight,
              child: ElevatedButton(
                onPressed: onRestart,
                child: const Text('Neustart'),
              ),
            ),
          ],
        );
      },
    );
  }
}
