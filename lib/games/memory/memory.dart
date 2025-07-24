import 'package:flutter/material.dart';

import '../../helper/utils.dart';
import '../../templates/game_screen_template.dart';
import '../../helper/player.dart';
import '../../helper/game_definition.dart';


class Memory extends StatefulWidget {
  final List<Player> players;
  static final GameDefinition gameDef = GameDefinition(
    name: 'Memory',
    minPlayers: 1,
    maxPlayers: 3,
    gameBuilder: (players, gameDef) => Memory(players: players),
  );


  const Memory({
    super.key,
    required this.players,
  });

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
    final shuffledPairs = List.from(imagePairs)
      ..shuffle();

    // 4x4 board and fills with img
    board = List.generate(4, (i) =>
        List.generate(4, (j) => shuffledPairs[i * 4 + j])
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
    navigateToGameOverScreen(
      context,
      Memory.gameDef,
      widget.players,
    );
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
        inProgress = true;

        // check if match
        if (board[row][col] == board[firstSelectedRow!][firstSelectedCol!]) {
          playerScores[currentPlayerIndex]++;
          matchedPairs++;

          // check gameover
          if (matchedPairs == 8) {
            _determineWinner();
            _endGame();
          }

          firstSelectedRow = null;
          firstSelectedCol = null;
          inProgress = false;
        } else {
          // no match, hide after delay
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              revealed[row][col] = false;
              revealed[firstSelectedRow!][firstSelectedCol!] = false;
              firstSelectedRow = null;
              firstSelectedCol = null;

              currentPlayerIndex = getNextPlayerIndexFromListOfPlayer(
                  currentPlayerIndex, players);

              inProgress = false;
            });
          });
        }
      }
    });
  }

  void _determineWinner() {
    List<int> winners = getWinnersFromScores(playerScores);

    for (var j = 0; j < winners.length; j++) {
      players[winners[j]].incrementScore();
    }
  }


  Widget _buildBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonHeight = 60;
        double margin = 4;
        double borderWidth = 2;
        double boardSize = constraints.maxHeight - buttonHeight;
        boardSize =
        boardSize > constraints.maxWidth ? constraints.maxWidth : boardSize;

        double cellSize = (boardSize - (margin * 2) * 4) / 4;

        return Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(4, (i) =>
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(4, (j) {
                          return GestureDetector(
                            onTap: () => _handleTap(i, j),
                            child: Container(
                              width: cellSize,
                              height: cellSize,
                              margin: EdgeInsets.all(margin),
                              decoration: BoxDecoration(
                                color: revealed[i][j] ? Colors.white : Colors
                                    .blue,
                                border: Border.all(
                                    color: Colors.black, width: borderWidth),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: revealed[i][j]
                                    ? Image.asset(
                                  board[i][j],
                                  fit: BoxFit.contain,
                                  width: cellSize * 0.8,
                                  height: cellSize * 0.8,
                                )
                                    : const Icon(
                                    Icons.question_mark, color: Colors.white),
                              ),
                            ),
                          );
                        }),
                      )),
                ),
              ),
            ),
            if (winner != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Winner: $winner!',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: _resetGame,
                child: const Text('Restart'),
              ),
            ),
          ],
        );
      },
    );
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
      currentPlayerNameFunction: () => '${currentPlayer
          .name} Paare: ${playerScores[currentPlayerIndex]}',
      gameDefinition: Memory.gameDef,
      board: _buildBoard(),
    );
  }
}