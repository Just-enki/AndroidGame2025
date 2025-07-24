import 'package:flutter/material.dart';

import '../../helper/game_definition.dart';
import 'tictactoe_logic.dart';
import 'tictactoe_board.dart';
import '../../helper/player.dart';
import '../../helper/utils.dart';
import '../../templates/game_screen_template.dart';

class TicTacToe extends StatefulWidget {
  final List<Player> players;
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

class _TicTacToeState extends State<TicTacToe> {
  late List<List<String>> board;
  late int currentPlayerIndex;

  Player get currentPlayer => widget.players[currentPlayerIndex];

  String get currentSymbol => currentPlayerIndex == 0 ? 'X' : 'O';

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayerIndex =
        getRandomStartPlayerIndexFromListOfPlayer(widget.players);
  }

  void _onGameEnd() {
    _resetGame();
    navigateToGameOverScreen(
      context,
      TicTacToe.gameDef,
      widget.players,
    );
  }

  void _handleTap(int row, int col) {
    if (board[row][col].isNotEmpty) return;

    setState(() {
      board[row][col] = currentSymbol;

      if (checkWinner(board, currentSymbol)) {
        widget.players[currentPlayerIndex].score++;
        _onGameEnd();
      } else if (isBoardFull(board)) {
        _onGameEnd();
      } else {
        currentPlayerIndex =
            getNextPlayerIndexFromListOfPlayer(
                currentPlayerIndex, widget.players);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenTemplate(
      players: widget.players,
      currentPlayerNameFunction: () =>
      "${widget.players[currentPlayerIndex].name} ($currentSymbol)",
      gameDefinition: TicTacToe.gameDef,
      board: TicTacToeBoard(
        board: board,
        onCellTap: _handleTap,
      ),
    );
  }
}
