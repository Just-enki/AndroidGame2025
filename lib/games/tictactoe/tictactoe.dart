import 'package:flutter/material.dart';

import 'tictactoe_logic.dart';
import 'tictactoe_board.dart';

import '../../helper/game_definition.dart';
import '../../helper/player.dart';
import '../../helper/utils.dart';
import '../../templates/game_screen_template.dart';

/// The main widget representing the Tic Tac Toe game screen.
///
/// This widget wraps the game board, handles player interaction,
/// and integrates with the overall app structure using `GameScreenTemplate`.
class TicTacToe extends StatefulWidget {
  // List of participating players (must be 2)
  final List<Player> players;

  // Static metadata defining this game, used for navigation and setup screens
  static final GameDefinition gameDef = GameDefinition(
    name: 'TicTacToe',
    minPlayers: 2,
    maxPlayers: 2,
    gameBuilder: (players, gameDef) => TicTacToe(players: players),
  );

  const TicTacToe({required this.players, super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

/// Internal state class responsible for managing game state and UI updates.
class _TicTacToeState extends State<TicTacToe> {
  // 3x3 board represented as a 2D list of strings ('X', 'O', or '')
  late List<List<String>> board;

  // Index of the currently active player
  late int currentPlayerIndex;

  // Retrieves the current player from the list
  Player get currentPlayer => widget.players[currentPlayerIndex];

  // Determines the current player's symbol (Player 0: 'X', Player 1: 'O')
  String get currentSymbol => currentPlayerIndex == 0 ? 'X' : 'O';

  @override
  void initState() {
    super.initState();
    // Initializes or resets the board and picks a random starting player
    _resetGame();
  }

  /// Resets the game state by clearing the board and selecting a
  /// starting player.
  void _resetGame() {
    setState(() {
      // Create a 3x3 grid with empty strings
      board = List.generate(3, (_) => List.filled(3, ''));
      // Randomly pick which player goes first
      currentPlayerIndex =
          getRandomStartPlayerIndexFromListOfPlayer(widget.players);
    });
  }

  /// Called when the game ends either in a win or a draw.
  /// Resets the board and navigates to the game over screen.
  void _onGameEnd() {
    _resetGame();
    navigateToGameOverScreen(
      context,
      TicTacToe.gameDef,
      widget.players,
    );
  }

  /// Handles user interaction when a cell is tapped.
  ///
  /// If the selected cell is empty, the current player's symbol is placed,
  /// and the board is checked for a win or draw. If the game continues,
  /// the turn passes to the next player.
  void _handleTap(int row, int col) {
    // Ignore taps on already occupied cells
    if (board[row][col].isNotEmpty) return;

    setState(() {
      // Mark the cell with the current player's symbol
      board[row][col] = currentSymbol;

      // Check for a win
      if (checkWinner(board, currentSymbol)) {
        widget.players[currentPlayerIndex].score++;
        _onGameEnd();
      }
      // Check for a draw (all cells filled, no winner)
      else if (isTwoDimensionalArrayFull(board)) {
        _onGameEnd();
      }
      // Continue the game by switching to the next player
      else {
        currentPlayerIndex =
            getNextPlayerIndexFromListOfPlayer(
                currentPlayerIndex, widget.players);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wraps the game content in a reusable screen template.
    // Displays player info and renders the game board with tap support.
    return GameScreenTemplate(
      players: widget.players,
      currentPlayerNameFunction: () =>
      "${widget.players[currentPlayerIndex].name} ($currentSymbol)",
      gameDefinition: TicTacToe.gameDef,
      board: TicTacToeBoard(
        board: board,
        onCellTap: _handleTap, // Called when a cell is tapped
        onRestart: _resetGame, // Allows manual restart from UI
      ),
    );
  }
}
