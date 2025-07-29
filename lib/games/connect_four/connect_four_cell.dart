import 'package:flutter/material.dart';

/// A single circular cell representing one slot in the Connect Four grid.
///
/// This widget is purely visual and displays a filled circle of a given color
/// to represent the current state of a cell (e.g., red, yellow, or empty).
/// It is used within the grid to construct the full game board visually.
class ConnectFourCell extends StatelessWidget {
  // The fill color of the circle.
  // Typically represents a player (e.g. red or yellow), or an empty slot.
  final Color circleColor;

  const ConnectFourCell({
    required this.circleColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Forces a 1:1 ratio to maintain a perfect square

      // The visual container for the cell
      child: Container(
        margin: const EdgeInsets.all(2), // Adds spacing between cells

        // Decoration defines the round shape, color, and border of the cell
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Makes the container a circle
          color: circleColor, // Fills the cell with the correct color
          border: Border.all(
            color: Colors.black26, // Light border for subtle separation
          ),
        ),
      ),
    );
  }
}
