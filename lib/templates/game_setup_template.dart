import 'package:flutter/material.dart';

import 'game_definition.dart';
import '../main.dart';
import 'player.dart';

void navigateBackToGameSetupScreen(BuildContext context, GameDefinition gameDef) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => GameSetupTemplate(
        gameDef: gameDef,
      ),
    ),
  );
}

class GameSetupTemplate extends StatefulWidget {
  final GameDefinition gameDef;

  const GameSetupTemplate({
    super.key,
    required this.gameDef,
  });

  @override
  State<GameSetupTemplate> createState() => _GameSetupTemplateState();
}

class _GameSetupTemplateState extends State<GameSetupTemplate> {
  final List<TextEditingController> _controllers = [];
  final List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.gameDef.minPlayers; i++) {
      final controller = TextEditingController(text: 'Spieler ${i + 1}');
      _controllers.add(controller);
      _players.add(Player(name: controller.text));
      controller.addListener(() {
        _players[i].name = controller.text;
      });
    }
  }

    void _goToMainPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainPage(),
      ),
    );
  }

  void _addPlayer() {
    if (_players.length < widget.gameDef.maxPlayers) {
      setState(() {
        final index = _players.length;
        final controller = TextEditingController(text: 'Spieler ${index + 1}');
        _controllers.add(controller);
        _players.add(Player(name: controller.text));
        controller.addListener(() {
          _players[index].name = controller.text;
        });
      });
    }
  }


  void _removePlayer(int index) {
    if (_players.length > widget.gameDef.minPlayers) {
      setState(() {
        _controllers[index].dispose();
        _controllers.removeAt(index);
        _players.removeAt(index);
      });
    } else {
      _showMessage("At least ${widget.gameDef.minPlayers} players are required.");
    }
  }


  void _startGame() {
    final playerNames = _controllers
        .map((controller) => controller.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();


    if (playerNames.toSet().length < playerNames.length) {
      _showMessage("Spielernamen müssen eindeutig sein.");
      return;
    }

    if (playerNames.length < widget.gameDef.minPlayers) {
      _showMessage("Mindestens ${widget.gameDef.minPlayers} Spieler erforderlich.");
      return;
    }

    if (playerNames.length > widget.gameDef.maxPlayers) {
      _showMessage("Maximal ${widget.gameDef.maxPlayers} Spieler erlaubt.");
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => widget.gameDef.gameBuilder(_players, widget.gameDef),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameDef.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goToMainPage(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Spieler:',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                if (_controllers.length < widget.gameDef.maxPlayers)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addPlayer,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Spieler ${index + 1}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _removePlayer(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _startGame,
                child: const Text(
                  "Start Game",
                  style: TextStyle(fontSize: 18),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
