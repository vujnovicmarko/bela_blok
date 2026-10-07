class Player {
  final int? id;
  final String name;
  final int numGamesPlayed;
  final int numWins;

  const Player({
    this.id,
    required this.name,
    this.numGamesPlayed = 0,
    this.numWins = 0,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map["id"] as int?,
      name: map["name"] as String,
      numGamesPlayed: map["numGamesPlayed"] as int? ?? 0,
      numWins: map["numWins"] as int? ?? 0,
    );
  }

  String get winPercentage {
    if (numGamesPlayed == 0) return '0.00%';
    return '${((numWins / numGamesPlayed) * 100).toStringAsFixed(2)}%';
  }

  Map<String, dynamic> toMap() {
    return {if (id != null) "id": id, "name": name};
  }

  Player copyWith({int? id, String? name, int? numGamesPlayed, int? numWins}) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      numGamesPlayed: numGamesPlayed ?? this.numGamesPlayed,
      numWins: numWins ?? this.numWins,
    );
  }
}
