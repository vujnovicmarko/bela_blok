import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/meld.dart';

class Round {
  final int? id;
  final Game game;
  final int? roundNumber;
  final int callingTeam;
  final int team1CardPoints;
  final int team2CardPoints;
  final List<Meld> team1Melds;
  final List<Meld> team2Melds;
  final int stigljaTeam;
  final int team1Points;
  final int team2Points;

  Round({
    this.id,
    required this.game,
    this.roundNumber,
    required this.callingTeam,
    required this.team1CardPoints,
    required this.team2CardPoints,
    this.team1Melds = const [],
    this.team2Melds = const [],
    this.stigljaTeam = 0,
    int? team1Points,
    int? team2Points,
  }) : team1Points =
           team1Points ??
           _calculateTeamPoints(
             callingTeam: callingTeam,
             team1CardPoints: team1CardPoints,
             team2CardPoints: team2CardPoints,
             team1Melds: team1Melds,
             team2Melds: team2Melds,
             stigljaTeam: stigljaTeam,
           )["team1"]!,
       team2Points =
           team2Points ??
           _calculateTeamPoints(
             callingTeam: callingTeam,
             team1CardPoints: team1CardPoints,
             team2CardPoints: team2CardPoints,
             team1Melds: team1Melds,
             team2Melds: team2Melds,
             stigljaTeam: stigljaTeam,
           )["team2"]!;

  static Map<String, int> _calculateTeamPoints({
    required int callingTeam,
    required int team1CardPoints,
    required int team2CardPoints,
    required List<Meld> team1Melds,
    required List<Meld> team2Melds,
    required int stigljaTeam,
  }) {
    int sumTeam1Melds = team1Melds.fold(0, (sum, meld) => sum + meld.value);
    int sumTeam2Melds = team2Melds.fold(0, (sum, meld) => sum + meld.value);
    int totalMelds = sumTeam1Melds + sumTeam2Melds;

    if (stigljaTeam == 1) {
      return {"team1": 252 + totalMelds, "team2": 0};
    } else if (stigljaTeam == 2) {
      return {"team1": 0, "team2": 252 + totalMelds};
    }

    int rawTeam1Points = team1CardPoints + sumTeam1Melds;
    int rawTeam2Points = team2CardPoints + sumTeam2Melds;
    int grandTotal = 162 + totalMelds;

    double passThreshold = grandTotal / 2.0;

    bool team1Fell = (callingTeam == 1) && (rawTeam1Points <= passThreshold);
    bool team2Fell = (callingTeam == 2) && (rawTeam2Points <= passThreshold);

    if (team1Fell) {
      return {"team1": 0, "team2": grandTotal};
    } else if (team2Fell) {
      return {"team1": grandTotal, "team2": 0};
    }

    return {"team1": rawTeam1Points, "team2": rawTeam2Points};
  }

  factory Round.fromMap(Map<String, dynamic> map, Game game, int? roundNumber) {
    List<Meld> parseMelds(String? meldStr) {
      if (meldStr == null || meldStr.trim().isEmpty) return [];
      return meldStr
          .split(",")
          .map((v) => Meld.fromValue(int.parse(v)))
          .toList();
    }

    return Round(
      id: map["id"] as int?,
      game: game,
      roundNumber: roundNumber,
      callingTeam: map["callingTeam"] as int,
      team1CardPoints: map["team1CardPoints"] as int,
      team2CardPoints: map["team2CardPoints"] as int,
      team1Melds: parseMelds(map["team1Melds"] as String?),
      team2Melds: parseMelds(map["team2Melds"] as String?),
      stigljaTeam: map["stigljaTeam"] as int? ?? 0,
      team1Points: map["team1Points"] as int,
      team2Points: map["team2Points"] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "gameId": game.id,
      "callingTeam": callingTeam,
      "team1CardPoints": team1CardPoints,
      "team2CardPoints": team2CardPoints,
      "team1Melds": team1Melds.map((meld) => meld.value).join(","),
      "team2Melds": team2Melds.map((meld) => meld.value).join(","),
      "stigljaTeam": stigljaTeam,
      "team1Points": team1Points,
      "team2Points": team2Points,
    };
  }

  Round copyWith({
    int? id,
    Game? game,
    int? roundNumber,
    int? callingTeam,
    int? team1CardPoints,
    int? team2CardPoints,
    List<Meld>? team1Melds,
    List<Meld>? team2Melds,
    int? stigljaTeam,
    int? team1Points,
    int? team2Points,
  }) {
    return Round(
      id: id ?? this.id,
      game: game ?? this.game,
      roundNumber: roundNumber ?? this.roundNumber,
      callingTeam: callingTeam ?? this.callingTeam,
      team1CardPoints: team1CardPoints ?? this.team1CardPoints,
      team2CardPoints: team2CardPoints ?? this.team2CardPoints,
      team1Melds: team1Melds ?? this.team1Melds,
      team2Melds: team2Melds ?? this.team2Melds,
      stigljaTeam: stigljaTeam ?? this.stigljaTeam,
      team1Points: team1Points ?? this.team1Points,
      team2Points: team2Points ?? this.team2Points,
    );
  }
}
