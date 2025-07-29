import 'package:flutter/material.dart';

/// Determines the first available (empty) row in a given column where a disc
/// can be dropped.
///
/// The method scans the specified column from bottom to top, returning the
/// index of the first
/// empty row (`''`). This simulates the gravity effect in Connect Four, where
/// discs fall
/// to the lowest available space in a column.
///
/// If no empty rows are found (i.e., the column is full), the function returns
/// -1.
///
/// Parameters:
/// - `board`: A 2D list representing the game grid (rows x columns).
/// - `col`: The index of the column to check.
///
/// Returns:
/// - The index of the first available row, or -1 if the column is full.
int getAvailableRow(List<List<String>> board, int col) {
  for (int row = board.length - 1; row >= 0; row--) {
    if (board[row][col] == '') return row;
  }
  return -1;
}

/// Checks whether the current player (defined by their `symbol`) has won the
/// game.
///
/// A win occurs when the player has four of their symbols in a row
/// horizontally,
/// vertically, or diagonally (both directions).
///
/// The board is scanned in four directions:
/// 1. Horizontal rows (left to right)
/// 2. Vertical columns (top to bottom)
/// 3. Diagonal down-right (`\` direction)
/// 4. Diagonal up-right (`/` direction)
///
/// Parameters:
/// - `board`: A 2D list representing the current game grid.
/// - `symbol`: The player's symbol to search for (e.g., '🔴' or '🟡').
///
/// Returns:
/// - `true` if four connected symbols are found in any direction.
/// - `false` otherwise.
bool checkConnectFourWinner(List<List<String>> board, String symbol) {
  int rows = board.length;
  int cols = board[0].length;

  // Check horizontal rows (left to right)
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols - 3; col++) {
      if (List.generate(4, (i) => board[row][col + i]).every((cell) =>
      cell == symbol)) {
        return true;
      }
    }
  }

  // Check vertical columns (top to bottom)
  for (int col = 0; col < cols; col++) {
    for (int row = 0; row < rows - 3; row++) {
      if (List.generate(4, (i) => board[row + i][col]).every((cell) =>
      cell == symbol)) {
        return true;
      }
    }
  }

  // Check diagonal (top-left to bottom-right, "\")
  for (int row = 0; row < rows - 3; row++) {
    for (int col = 0; col < cols - 3; col++) {
      if (List.generate(4, (i) => board[row + i][col + i]).every((
          cell) => cell == symbol)) {
        return true;
      }
    }
  }

  // Check diagonal (bottom-left to top-right, "/")
  for (int row = 3; row < rows; row++) {
    for (int col = 0; col < cols - 3; col++) {
      if (List.generate(4, (i) => board[row - i][col + i]).every((
          cell) => cell == symbol)) {
        return true;
      }
    }
  }

  return false; // No win found in any direction
}

/// Converts a player's symbol to a visual color for UI display purposes.
///
/// This is used to render the correct colored circle in each cell based on
/// the internal board state (which stores symbols).
///
/// Parameters:
/// - `symbol`: A string representing the player's disc ('🔴', '🟡', or '').
///
/// Returns:
/// - A `Color` corresponding to the symbol: red, yellow, or a light grey for
/// empty.
Color convertSymbolToColor(String symbol) {
  return symbol == '🔴'
      ? Colors.red
      : symbol == '🟡'
      ? Colors.yellow
      : Colors.grey.shade300; // default for empty
}

/// Converts a `Color` (used in the UI) into its corresponding board symbol.
///
/// This allows logic that tracks turns and game state to work with both
/// visual and symbolic representations of player moves.
///
/// Parameters:
/// - `color`: A `Color` object representing a disc color.
///
/// Returns:
/// - A symbol string: '🔴', '🟡', or '⚫' (fallback).
String convertColorToSymbol(Color color) {
  return color == Colors.red
      ? '🔴'
      : color == Colors.yellow
      ? '🟡'
      : '⚫'; // fallback symbol for undefined/empty
}
