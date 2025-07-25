import 'package:flutter/material.dart';

/// A visual representation of a single cell in the Tic Tac Toe board.
///
/// This widget is responsible for displaying either an empty cell,
/// an 'X', or an 'O'. It also handles user interaction (tap gesture),
/// which signals the game logic to perform a move if the cell is empty.
class TicTacToeCell extends StatelessWidget {
  // The current value of the cell: '', 'X', or 'O'.
  final String value;

  // The visual size (width and height) of the square cell.
  final double cellSize;

  // The spacing around the cell to separate it from its neighbors.
  final double margin;

  // The width of the black border around the cell.
  final double borderWidth;

  // The callback function to trigger when the cell is tapped.
  // This is used to notify the game logic to attempt a move.
  final VoidCallback onTap;

  const TicTacToeCell({
    required this.value,
    required this.cellSize,
    required this.margin,
    required this.borderWidth,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Registers a tap gesture and calls the onTap callback.
      // This allows the parent widget to handle user interaction.
      onTap: onTap,

      // Container used to define the visual appearance of the cell
      child: Container(
        width: cellSize,
        // Set fixed width
        height: cellSize,
        // Set fixed height (same as width for a square)
        margin: EdgeInsets.all(margin),
        // Add spacing around the cell

        // Visual border and background for the cell
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: borderWidth,
          ),
        ),

        // Centers the symbol ('X' or 'O') inside the cell
        child: Center(
          child: Text(
            value, // Displays the player's mark or an empty string
            style: const TextStyle(
              fontSize: 32, // Large font for clear visibility
            ),
          ),
        ),
      ),
    );
  }
}
