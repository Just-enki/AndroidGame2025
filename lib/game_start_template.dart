import 'package:flutter/material.dart';
import 'package:android_game_2025/tictactoe.dart';

class GameSetupTemplate extends StatefulWidget {
  final String title;
  final int minPlayers;
  final int maxPlayers;

  const GameSetupTemplate({
    super.key,
    required this.title,
    required this.minPlayers,
    required this.maxPlayers,
  });

  @override
  State<GameSetupTemplate> createState() => _GameSetupTemplateState();
}

class _GameSetupTemplateState extends State<GameSetupTemplate> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.minPlayers; i++) {
      _controllers.add(TextEditingController());
    }
  }


  void _addPlayer() {
    if (_controllers.length < widget.maxPlayers) {
      setState(() {
        _controllers.add(TextEditingController(text: 'Spieler ${_controllers.length + 1}'));
      });
    }
  }

  void _removePlayer(int index) {
    if (_controllers.length > widget.minPlayers) {
      setState(() {
        _controllers[index].dispose();
        _controllers.removeAt(index);
      });
    } else {
      _showMessage("At least ${widget.minPlayers} players are required.");
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

    if (playerNames.length < widget.minPlayers) {
      _showMessage("Mindestens ${widget.minPlayers} Spieler erforderlich.");
      return;
    }

    if (playerNames.length > widget.maxPlayers) {
      _showMessage("Maximal ${widget.maxPlayers} Spieler erlaubt.");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TicTacToePage()),
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
        title: Text(widget.title),
        leading: BackButton(),
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
                if (_controllers.length < widget.maxPlayers)
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
