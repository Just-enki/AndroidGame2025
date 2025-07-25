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

  // The margin around each button for visual spacing.
  final double cellMargin;

  // Callback function triggered when a button is tapped.
  // It receives the column index that was selected.
  final void Function(int col) onColumnSelected;

  const ConnectFourButtons({
    required this.columnCount,
    required this.cellMargin,
    required this.onColumnSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // Create one expandable tappable area per column
      children: List.generate(columnCount, (col) {
        return Expanded(
          // Ensures the button is square-shaped
          child: AspectRatio(
            aspectRatio: 1,

            // Adds uniform padding around the button area
            child: Padding(
              padding: EdgeInsets.all(cellMargin),

              // GestureDetector wraps the button to handle tap events
              child: GestureDetector(
                onTap: () => onColumnSelected(col),
                // Call callback with column index

                // Visual appearance of the button
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent, // Button background color
                    border: Border.all(color: Colors.black), // Black outline
                  ),

                  // The icon indicates a "drop" action (e.g. drop disc)
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
