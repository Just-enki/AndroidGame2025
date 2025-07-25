/// A data class representing a player in the game.
///
/// This class stores player-specific information such as their name
/// and current score. It is used throughout the app to manage game logic,
/// display player information in the UI, and track results.
///
/// Instances of this class are passed to game widgets and updated
/// as players take turns or win rounds.
class Player {
  // The name of the player, displayed in the UI and used to identify turns.
  String name;

  // The current score of the player, usually increased after a win.
  int score;

  /// Creates a new Player instance with a given [name].
  ///
  /// If no score is provided, it defaults to 0.
  Player({required this.name, this.score = 0});

  /// Increases the player's score by 1.
  ///
  /// This method is typically called when the player wins a game round.
  /// The updated score is reflected in the UI (e.g. scoreboard or
  /// Game Over screen).
  void incrementScore() {
    score++;
  }

  /// Returns a string representation of the player and their score.
  ///
  /// Used for debugging, logging, or simple display of the player's stats.
  /// Example output: "Alice: 2 points"
  @override
  String toString() => '$name: $score Punkte';
}
