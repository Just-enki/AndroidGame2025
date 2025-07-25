import 'package:flutter/material.dart';

import '../../helper/utils.dart';
import '../../templates/game_screen_template.dart';
import '../../helper/player.dart';
import '../../helper/game_definition.dart';
import 'memory_logic.dart';
import 'memory_board.dart';

class Memory extends StatefulWidget {
  final List<Player> players;
  static final GameDefinition gameDef = GameDefinition(
    name: 'Memory',
    minPlayers: 1,
    maxPlayers: 3,
    gameBuilder: (players, gameDef) => Memory(players: players),
  );

  const Memory({super.key, required this.players});

  @override
  State<Memory> createState() => _MemoryState();
}

class _MemoryState extends State<Memory> {
  late List<List<String>> board;
  late List<List<bool>> revealed;
  int? firstSelectedRow;
  int? firstSelectedCol;
  int currentPlayerIndex = 0;
  late List<int> playerScores;

  bool inProgress = false;
  int matchedPairs = 0;

  List<Player> get players => widget.players;

  Player get currentPlayer => players[currentPlayerIndex];
  String? winner;

  final List<String> imagePairs = [
    'assets/data_memory/images/black.png',
    'assets/data_memory/images/black.png',
    'assets/data_memory/images/green.png',
    'assets/data_memory/images/green.png',
    'assets/data_memory/images/mcd.png',
    'assets/data_memory/images/mcd.png',
    'assets/data_memory/images/orange.png',
    'assets/data_memory/images/orange.png',
    'assets/data_memory/images/pink.png',
    'assets/data_memory/images/pink.png',
    'assets/data_memory/images/purple.png',
    'assets/data_memory/images/purple.png',
    'assets/data_memory/images/red.png',
    'assets/data_memory/images/red.png',
    'assets/data_memory/images/uwu.png',
    'assets/data_memory/images/uwu.png',
  ];

  @override
  void initState() {
    super.initState();
    playerScores = List.generate(widget.players.length, (index) => 0);
    currentPlayerIndex = getRandomStartPlayerIndexFromListOfPlayer(players);

    _initializeGame();
  }

  void _initializeGame() {
    // shuffle
    final shuffledPairs = List.from(imagePairs)..shuffle();

    // 4x4 board and fills with img
    board = List.generate(
      4,
      (i) => List.generate(4, (j) => shuffledPairs[i * 4 + j]),
    );

    revealed = List.generate(4, (_) => List.filled(4, false));
    firstSelectedRow = null;
    firstSelectedCol = null;
    matchedPairs = 0;
    winner = null;
    inProgress = false;
  }

  void _endGame() {
    _resetGame();
    navigateToGameOverScreen(context, Memory.gameDef, widget.players);
  }

  void _handleSecondTap(row, col) {
    inProgress = true;
    if (checkForMatch(board, row, col, firstSelectedRow, firstSelectedCol) == true) {
      matchedPairs = incrementScore(
        playerScores,
        currentPlayerIndex,
        matchedPairs,
      );
      bool allCardsRevealed = handleMatch(
        board,
        row,
        col,
        firstSelectedRow,
        firstSelectedCol,
        matchedPairs,
        players,
        playerScores,
        currentPlayerIndex,
      );

      if (allCardsRevealed == true) {
        _endGame();
      }

      firstSelectedRow = null;
      firstSelectedCol = null;
      inProgress = false;
    }
    else {
      /// no match, hide cards after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          revealed[row][col] = false;
          revealed[firstSelectedRow!][firstSelectedCol!] = false;
          firstSelectedRow = null;
          firstSelectedCol = null;
          currentPlayerIndex = getNextPlayerIndexFromListOfPlayer(
            currentPlayerIndex,
            players,
          );
          inProgress = false;
        });
      });
    }
  }

  void _handleTap(int row, int col) {
    // Ignore if card is revealed, move in progress or winner
    if (revealed[row][col] || inProgress || winner != null) {
      return;
    }

    setState(() {
      revealed[row][col] = true;

      // first card selected
      if (firstSelectedRow == null) {
        firstSelectedRow = row;
        firstSelectedCol = col;
      }
      // second card selected
      else {
        _handleSecondTap(row, col);
      }
    });
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenTemplate(
      players: widget.players,
      currentPlayerNameFunction: () =>
          '${currentPlayer.name} Paare: ${playerScores[currentPlayerIndex]}',
      gameDefinition: Memory.gameDef,
      board: MemoryBoard(
        board: board,
        revealed: revealed,
        onCellTap: _handleTap,
        onReset: _resetGame,
        winner: winner,
      ),
    );
  }
}
