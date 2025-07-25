import 'package:flutter/material.dart';

/// A row of tappable buttons positioned above the Connect Four board.
/// Each button corresponds to a column and allows the player to drop
/// a disc into the selected column.
///
/// This widget does not render the game board itself, but provides
/// the interaction mechanism for making moves in the game.
class ConnectFourButtons extends StatelessWidget {
  // The total number of columns in the game board.
  final int columnCount;

  // The size (width and height) of each tappable button cell.
  final double cellSize;

  // The margin around each button for visual spacing.
  final double cellMargin;

  // Callback function triggered when a button is tapped.
  // It receives the column index that was selected.
  final void Function(int col) onColumnSelected;

  const ConnectFourButtons({
    required this.columnCount,
    required this.cellSize,
    required this.cellMargin,
    required this.onColumnSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // A horizontal row of buttons, one for each column.
    // Players tap these buttons to place their disc in a column.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(columnCount, (col) {
        // Each button is wrapped in a GestureDetector to capture taps.
        return GestureDetector(
          onTap: () => onColumnSelected(col), // Notifies parent when tapped
          child: Container(
            width: cellSize,
            height: cellSize,
            margin: EdgeInsets.all(cellMargin),
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Background color of the button
              border: Border.all(color: Colors.black), // Black border
            ),
            // Icon shown in the center of the button to indicate a "drop"
            // action
            child: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
