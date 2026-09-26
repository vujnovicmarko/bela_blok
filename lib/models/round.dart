import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/player.dart';

class Round {
  final int? id;
  final Game game;
  final int? roundNumber;
  final Player caller;
  final int team1Points;
  final int team2Points;
  final int stigljaTeam;

  const Round({
    this.id,
    required this.game,
    this.roundNumber,
    required this.caller,
    this.team1Points = 0,
    this.team2Points = 0,
    this.stigljaTeam = 0,
  });

  factory Round.fromMap(Map<String, dynamic> map, Game game, int? roundNumber) {
    return Round(
      id: map["id"] as int?,
      game: game,
      roundNumber: roundNumber,
      caller: Player(
        id: map["callerId"] as int?,
        name: map["callerName"] as String,
        numGamesPlayed: map["callerNumGamesPlayed"] as int? ?? 0,
        numWins: map["callerNumWins"] as int? ?? 0,
        totalMelds: map["callerTotalMelds"] as int? ?? 0,
      ),
      team1Points: map["team1Points"] as int? ?? 0,
      team2Points: map["team2Points"] as int? ?? 0,
      stigljaTeam: map["stigljaTeam"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "gameId": game.id,
      "callerId": caller.id,
      "team1Points": team1Points,
      "team2Points": team2Points,
      "stigljaTeam": stigljaTeam,
    };
  }

  Round copyWith({
    int? id,
    Game? game,
    int? roundNumber,
    Player? caller,
    int? team1Points,
    int? team2Points,
    int? stigljaTeam,
  }) {
    return Round(
      id: id ?? this.id,
      game: game ?? this.game,
      roundNumber: roundNumber ?? this.roundNumber,
      caller: caller ?? this.caller,
      team1Points: team1Points ?? this.team1Points,
      team2Points: team2Points ?? this.team2Points,
      stigljaTeam: stigljaTeam ?? this.stigljaTeam,
    );
  }
}
