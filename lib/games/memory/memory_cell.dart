import 'package:flutter/material.dart';

/// A single cell in the Memory board.
class MemoryCell extends StatelessWidget {
  final String value;
  final String imageAsset;
  final bool isRevealed;
  final VoidCallback onTap;
  final int i;
  final int j;
  final List<List<String>> board;
  final List<List<bool>> revealed;
  final double cellSize;
  final double borderWidth;

  const MemoryCell({
    required this.value,
    required this.imageAsset,
    required this.isRevealed,
    required this.onTap,
    required this.i,
    required this.j,
    required this.board,
    required this.revealed,
    required this.cellSize,
    required this.borderWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double margin = 4;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellSize,
        height: cellSize,
        margin: const EdgeInsets.all(margin),
        decoration: BoxDecoration(
          color: isRevealed ? Colors.white : Colors.blue,
          border: Border.all(color: Colors.black, width: borderWidth),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isRevealed
              ? Image.asset(
            imageAsset,
            fit: BoxFit.contain,
            width: cellSize * 0.8,
            height: cellSize * 0.8,
          )
              : const Icon(Icons.question_mark, color: Colors.white),
        ),
      ),
    );
  }
}

