import 'package:flutter/material.dart';

import 'connect_four_logic.dart';
import 'connect_four_board.dart';
import 'connect_four_buttons.dart';

import '../../helper/game_definition.dart';
import '../../helper/player.dart';
import '../../helper/utils.dart';
import '../../templates/game_screen_template.dart';

/// The `ConnectFour` widget serves as the main entry point for the Connect Four
/// game screen. It initializes game settings, manages player state, and renders
/// the game board and controls.
class ConnectFour extends StatefulWidget {
  final List<Player> players;

  /// Game definition metadata for Connect Four,
  /// including the name and the valid player range.
  static final GameDefinition gameDef = GameDefinition(
    name: 'Vier gewinnt',
    minPlayers: 2,
    maxPlayers: 2,
    gameBuilder: (players, gameDef) => ConnectFour(players: players),
  );

  /// Constructor for the ConnectFour widget.
  /// Requires a list of exactly two players.
  const ConnectFour({required this.players, super.key});

  @override
  State<ConnectFour> createState() => _ConnectFourState();
}

/// Internal state class for `ConnectFour`.
/// Handles game state management, board updates,
/// turn handling and win detection.
class _ConnectFourState extends State<ConnectFour> {
  static const int rows = 6;
  static const int columns = 7;

  late List<List<String>> board; // 2D board array to store player moves
  late int currentPlayerIndex; // Index of the current active player

  // Getter to retrieve the list of players
  List<Player> get players => widget.players;

  // Getter for the current player
  Player get currentPlayer => players[currentPlayerIndex];

  // Getter for the current player color (red for player 0, yellow for player 1)
  Color get currentColor =>
      currentPlayerIndex == 0 ? Colors.red : Colors.yellow;

  // Converts the player's color to a text symbol (e.g., "🔴" or "🟡")
  String get currentSymbol => convertColorToSymbol(currentColor);

  @override
  void initState() {
    super.initState();
    // Initialize the board and set a random player to start
    _resetGame();
  }

  /// Initializes the board to empty cells and randomly picks
  /// the starting player.
  void _resetGame() {
    setState(() {
      board = List.generate(rows, (_) => List.filled(columns, ''));
      currentPlayerIndex = getRandomStartPlayerIndexFromListOfPlayer(players);
    });
  }

  /// Resets the board and navigates to the game over screen,
  /// passing the players and game definition.
  void _endGame() {
    _resetGame();

    // Navigates to game over screen using shared utility function
    navigateToGameOverScreen(
      context,
      ConnectFour.gameDef,
      widget.players,
    );
  }

  /// Handles a player's move when a column is selected.
  /// Determines available row, checks for a win or draw,
  /// updates the board and changes player turn.
  void _handleColumnSelected(int col) {
    int row = getAvailableRow(board, col);
    if (row == -1) return; // Column is full, do nothing

    setState(() {
      final symbol = currentSymbol;
      board[row][col] = symbol;

      // Check if the current move wins the game
      if (checkConnectFourWinner(board, symbol)) {
        currentPlayer.score++;
        _endGame();
      } else if (isTwoDimensionalArrayFull(board)) {
        // Game is a draw
        _endGame();
      } else {
        // Proceed to next player's turn
        currentPlayerIndex =
            getNextPlayerIndexFromListOfPlayer(currentPlayerIndex, players);
      }
    });
  }

  /// Builds the Connect Four board and the interaction UI.
  /// This includes column selection buttons, the grid, and the restart button.
  Widget _buildBoard() {
    return LayoutBuilder(
        builder: (context, constraints) {
          // Constants for layout
          const double restartButtonHeight = 60;
          const double cellMargin = 2;

          // Calculate available space for the game board
          double availableHeight = constraints.maxHeight - restartButtonHeight;
          double availableWidth = constraints.maxWidth;

          // Determine the size of each cell to make board fit on screen
          double cellWidth = (availableWidth - columns * cellMargin * 2) /
              columns;
          double cellHeight =
              (availableHeight - (rows + 1) * cellMargin * 2) / (rows + 1);
          double cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

          return Column(
            children: [
              // The top part contains the column selector buttons
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// Row of tappable buttons for each column.
                      /// Players tap to drop a disc in a column.
                      ConnectFourButtons(
                        columnCount: columns,
                        cellSize: cellSize,
                        cellMargin: cellMargin,
                        onColumnSelected: _handleColumnSelected,
                      ),

                      const SizedBox(height: 12),

                      /// The main grid of the Connect Four board,
                      /// showing the current state with colored circles.
                      Expanded(
                        child: ConnectFourBoard(
                          board: board,
                          rowCount: rows,
                          columnCount: columns,
                          cellSize: cellSize,
                          cellMargin: cellMargin,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Restart button at the bottom of the screen.
              /// Allows players to start a new round.
              SizedBox(
                height: restartButtonHeight,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _resetGame,
                  child: const Text('Neustart'),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    /// Uses a shared game template to wrap the board with
    /// a header displaying player information and turn indication.
    return GameScreenTemplate(
      players: players,
      currentPlayerNameFunction: () =>
      '${currentPlayer.name} (${convertColorToSymbol(currentColor)})',
      gameDefinition: ConnectFour.gameDef,
      board: _buildBoard(),
    );
  }
}
