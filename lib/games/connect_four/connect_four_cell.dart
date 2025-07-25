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
    // The cell is rendered as a circular Container with a fixed size and
    // border.
    // The color is determined by the game state and passed in externally.
    return Container(
      // Adds spacing around each cell to visually separate them
      margin: const EdgeInsets.all(2),

      // Defines the shape and color of the cell
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Ensures the cell appears round
        color: circleColor, // Fill color representing a player or empty slot
        border: Border.all(
          color: Colors.black26, // Light border to distinguish between cells
        ),
      ),

      // Fixed size for each cell; should match the layout in the board
      width: 40,
      height: 40,
    );
  }
}
