import 'package:flutter/material.dart';

import 'connect_four_buttons.dart';
import 'connect_four_cell.dart';
import 'connect_four_logic.dart';

/// A stateless widget that visually represents the Connect Four game board
/// using a grid of individual cells.
///
/// This widget is responsible for rendering the current state of the game board
/// by mapping the 2D `board` array (symbols like '🔴', '🟡', or '') to colored
/// cells.
/// It does not handle any input logic – user interaction is handled separately
/// via column buttons.
class ConnectFourBoard extends StatelessWidget {
  // 2D array representing the board state; each cell contains a symbol ('🔴',
  // '🟡', or '').
  final List<List<String>> board;

  // Total number of rows in the game grid.
  final int rowCount;

  // Total number of columns in the game grid.
  final int columnCount;

  final void Function (int) onColumnSelected;

  // Callback triggered when the restart button is pressed.
  final void Function() onRestart;

  const ConnectFourBoard({
    required this.board,
    required this.rowCount,
    required this.columnCount,
    required this.onColumnSelected,
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double restartButtonHeight = 60; // Fixed height for the
    // restart button
    const double cellMargin = 2; // Margin between each cell for spacing

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the shortest screen side (width or height).
        // Ensures that the board remains square and fits well in
        // both orientations.
        final double shortestSide = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight - restartButtonHeight - 16;

        return Column(
          children: [
            // The main board area, including the column buttons and cell grid
            Expanded(
              child: Center(
                child: SizedBox(
                  width: shortestSide,
                  height: shortestSide,

                  // Board is structured vertically: [buttons] + [grid]
                  child: Column(
                    children: [
                      // Row of tappable buttons for each column
                      // (top of the board)
                      ConnectFourButtons(
                        columnCount: columnCount,
                        cellMargin: cellMargin,
                        onColumnSelected: onColumnSelected,
                      ),

                      const SizedBox(height: 12),

                      // Grid of cells representing the current game state
                      Expanded(
                        child: Column(
                          children: List.generate(rowCount, (row) {
                            return Expanded(
                              child: Row(
                                children: List.generate(columnCount, (col) {
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(cellMargin),

                                      // Render each cell based on its symbol
                                      // ('🔴', '🟡', or '')
                                      child: ConnectFourCell(
                                        circleColor: convertSymbolToColor(
                                          board[row][col],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Restart button fixed at the bottom of the screen
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
