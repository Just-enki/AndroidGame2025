import 'package:flutter/material.dart';

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

  // Size of each cell (width and height will be equal).
  final double cellSize;

  // Margin space around each cell (used for visual spacing between them).
  final double cellMargin;

  const ConnectFourBoard({
    required this.board,
    required this.rowCount,
    required this.columnCount,
    required this.cellSize,
    required this.cellMargin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // This widget builds the grid row by row.
    // Each row is a horizontal `Row` widget containing multiple cells.
    return Column(
      children: List.generate(rowCount, (row) {
        // Each row consists of a Row widget with one ConnectFourCell
        // per column.
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(columnCount, (col) {
            // Each cell is wrapped in a Container to provide size and margin.
            // The symbol stored at board[row][col] determines the color.
            return Container(
              width: cellSize,
              height: cellSize,
              margin: EdgeInsets.all(cellMargin),
              child: ConnectFourCell(
                // Converts the symbol ('🔴', '🟡', or '') to a
                // corresponding color
                circleColor: convertSymbolToColor(board[row][col]),
              ),
            );
          }),
        );
      }),
    );
  }
}
