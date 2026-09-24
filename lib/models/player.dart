class Player {
  final int? id;
  final String name;
  final int numGamesPlayed;
  final int numWins;
  final int totalMelds;

  const Player({
    this.id,
    required this.name,
    this.numGamesPlayed = 0,
    this.numWins = 0,
    this.totalMelds = 0,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map["id"] as int?,
      name: map["name"] as String,
      numGamesPlayed: map["numGamesPlayed"] as int? ?? 0,
      numWins: map["numWins"] as int? ?? 0,
      totalMelds: map["totalMelds"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "name": name,
      "numGamesPlayed": numGamesPlayed,
      "numWins": numWins,
      "totalMelds": totalMelds,
    };
  }

  Player copyWith({
    int? id,
    String? name,
    int? numGamesPlayed,
    int? numWins,
    int? totalMelds,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      numGamesPlayed: numGamesPlayed ?? this.numGamesPlayed,
      numWins: numWins ?? this.numWins,
      totalMelds: totalMelds ?? this.totalMelds,
    );
  }
}
