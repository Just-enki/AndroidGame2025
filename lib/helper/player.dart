class Player {
  String name;
  int score;

  Player({required this.name, this.score = 0});

  void incrementScore() {
    score++;
  }

  @override
  String toString() => '$name: $score Punkte';
}