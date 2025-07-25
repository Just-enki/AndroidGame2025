import 'package:flutter/material.dart';

/// A visual representation of a single cell in the Tic Tac Toe board.
///
/// This widget is responsible for displaying either an empty cell,
/// an 'X', or an 'O'. It also handles user interaction (tap gesture),
/// which signals the game logic to perform a move if the cell is empty.
class TicTacToeCell extends StatelessWidget {
  // The current value of the cell: '', 'X', or 'O'.
  final String value;

  // The spacing around the cell to separate it from its neighbors.
  final double margin;

  // The width of the black border around the cell.
  final double borderWidth;

  // The callback function to trigger when the cell is tapped.
  // This is used to notify the game logic to attempt a move.
  final VoidCallback onTap;

  const TicTacToeCell({
    required this.value,
    required this.margin,
    required this.borderWidth,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      // Container renders the border and text symbol
      child: Container(
        margin: EdgeInsets.all(margin),

        // Square cell with border and centered text
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: borderWidth,
          ),
        ),

        // Center the symbol inside the cell
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
