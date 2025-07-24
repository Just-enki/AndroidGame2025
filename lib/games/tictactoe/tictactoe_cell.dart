import 'package:flutter/material.dart';

/// A single cell in the Tic Tac Toe board.
class TicTacToeCell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const TicTacToeCell({required this.value, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
