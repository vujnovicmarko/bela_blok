import 'package:bela_blok/models/player.dart';

class Game {
  final int? id;
  final Player player1;
  final Player player2;
  final Player player3;
  final Player player4;
  final int team1Points;
  final int team2Points;
  final int target;
  final String updatedAt;

  const Game({
    this.id,
    required this.player1,
    required this.player2,
    required this.player3,
    required this.player4,
    this.team1Points = 0,
    this.team2Points = 0,
    this.target = 1001,
    required this.updatedAt,
  });

  bool get isFinished {
    return (team1Points >= target || team2Points >= target) &&
        team1Points != team2Points;
  }

  int? get winningTeam {
    if (isFinished) {
      if (team1Points > team2Points) {
        return 1;
      } else {
        return 2;
      }
    }

    return null;
  }

  // NOTE: map mora biti spoj tablice partije sa 4 igraca
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map["id"] as int?,
      player1: Player(
        id: map["p1Id"] as int?,
        name: map["p1Name"] as String,
        numGamesPlayed: map["p1NumGamesPlayed"] as int? ?? 0,
        numWins: map["p1NumWins"] as int? ?? 0,
      ),
      player2: Player(
        id: map["p2Id"] as int?,
        name: map["p2Name"] as String,
        numGamesPlayed: map["p2NumGamesPlayed"] as int? ?? 0,
        numWins: map["p2NumWins"] as int? ?? 0,
      ),
      player3: Player(
        id: map["p3Id"] as int?,
        name: map["p3Name"] as String,
        numGamesPlayed: map["p3NumGamesPlayed"] as int? ?? 0,
        numWins: map["p3NumWins"] as int? ?? 0,
      ),
      player4: Player(
        id: map["p4Id"] as int?,
        name: map["p4Name"] as String,
        numGamesPlayed: map["p4NumGamesPlayed"] as int? ?? 0,
        numWins: map["p4NumWins"] as int? ?? 0,
      ),
      team1Points: map["team1Points"] as int? ?? 0,
      team2Points: map["team2Points"] as int? ?? 0,
      target: map["target"] as int? ?? 1001,
      updatedAt: map["updatedAt"] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "player1Id": player1.id,
      "player2Id": player2.id,
      "player3Id": player3.id,
      "player4Id": player4.id,
      "team1Points": team1Points,
      "team2Points": team2Points,
      "target": target,
      "updatedAt": updatedAt,
    };
  }

  Game copyWith({
    int? id,
    Player? player1,
    Player? player2,
    Player? player3,
    Player? player4,
    int? team1Points,
    int? team2Points,
    int? target,
    String? updatedAt,
  }) {
    return Game(
      id: id ?? this.id,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      player3: player3 ?? this.player3,
      player4: player4 ?? this.player4,
      team1Points: team1Points ?? this.team1Points,
      team2Points: team2Points ?? this.team2Points,
      target: target ?? this.target,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
