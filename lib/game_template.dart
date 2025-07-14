import 'package:flutter/material.dart';



class GameTemplate extends StatelessWidget {
  const GameTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Game Selection';
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(title: const Text(appTitle)),
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
            ),
        ),
    )
    );
  }
}