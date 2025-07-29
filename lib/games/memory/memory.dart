import 'package:flutter/material.dart';

import '../../helper/utils.dart';
import '../../templates/game_screen_template.dart';
import '../../helper/player.dart';
import '../../helper/game_definition.dart';
import 'memory_logic.dart';
import 'memory_board.dart';

/// Stateful widget representing the Memory game screen
class Memory extends StatefulWidget {
  final List<Player> players;

  /// Static game definition used for registration and navigation
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
  // Game state variables
  late List<List<String>> board; // 4x4 board with image paths
  late List<List<bool>> revealed; // whether each cell is revealed
  int? firstSelectedRow; // first card row index
  int? firstSelectedCol; // first card col index
  int currentPlayerIndex = 0; // index of the current player
  late List<int> playerScores; // scores for each player

  bool inProgress = false; // whether two cards are being processed
  int matchedPairs = 0; // number of matched pairs found

  List<Player> get players => widget.players;
  Player get currentPlayer => players[currentPlayerIndex];

  String? winner; // name of the winner (if any)

  /// List of 8 unique image pairs for the game
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

  /// Initializes or resets the game board and state
  void _initializeGame() {
    final shuffledPairs = List.from(imagePairs)..shuffle();

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

  /// Ends the game and navigates to game over screen
  void _endGame() {
    _resetGame();
    navigateToGameOverScreen(context, Memory.gameDef, widget.players);
  }

  /// Handles logic for when the second card is tapped
  void _handleSecondTap(row, col) {
    inProgress = true;

    if (checkForMatch(board, row, col, firstSelectedRow, firstSelectedCol) == true) {
      // Match found
      matchedPairs = incrementScore(
        playerScores,
        currentPlayerIndex,
        matchedPairs,
      );

      // Update game state and check if game is over
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

      // Reset selection
      firstSelectedRow = null;
      firstSelectedCol = null;
      inProgress = false;
    } else {
      // No match: hide cards after short delay and switch turn
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

  /// Handles a single card tap
  void _handleTap(int row, int col) {
    // Ignore taps if card already revealed, in progress, or game is over
    if (revealed[row][col] || inProgress || winner != null) return;

    setState(() {
      revealed[row][col] = true;

      // First card selected
      if (firstSelectedRow == null) {
        firstSelectedRow = row;
        firstSelectedCol = col;
      }
      // Second card selected
      else {
        _handleSecondTap(row, col);
      }
    });
  }

  /// Resets the game board and state
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
