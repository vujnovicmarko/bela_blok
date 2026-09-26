import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/player.dart';
import 'package:bela_blok/models/round.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _dbName = "bela_blok.db";
  static const int _dbVersion = 1;

  static const String tablePlayers = "players";
  static const String tableGames = "games";
  static const String tableRounds = "rounds";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute("PRAGMA foreign_keys = ON;");
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // TODO: dodat ostale tablice
    await db.execute("""
      CREATE TABLE $tablePlayers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        numGamesPlayed INTEGER NOT NULL DEFAULT 0,
        numWins INTEGER NOT NULL DEFAULT 0,
        totalMelds INTEGER NOT NULL DEFAULT 0
      )
    """);

    await db.execute("""
      CREATE TABLE $tableGames (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player1Id INTEGER NOT NULL REFERENCES $tablePlayers(id) ON DELETE CASCADE,
        player2Id INTEGER NOT NULL REFERENCES $tablePlayers(id) ON DELETE CASCADE,
        player3Id INTEGER NOT NULL REFERENCES $tablePlayers(id) ON DELETE CASCADE,
        player4Id INTEGER NOT NULL REFERENCES $tablePlayers(id) ON DELETE CASCADE,
        team1Points INTEGER NOT NULL DEFAULT 0,
        team2Points INTEGER NOT NULL DEFAULT 0,
        target INTEGER NOT NULL DEFAULT 1001,
        updatedAt TEXT NOT NULL
      )
    """);

    await db.execute("""
      CREATE TABLE $tableRounds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameId INTEGER NOT NULL REFERENCES $tableGames(id) ON DELETE CASCADE,
        callerId INTEGER NOT NULL REFERENCES $tablePlayers(id),
        team1Points INTEGER NOT NULL DEFAULT 0,
        team2Points INTEGER NOT NULL DEFAULT 0,
        stigljaTeam INTEGER NOT NULL DEFAULT 0
      )
    """);
  }

  Future<void> deleteAllData() async {
    final db = await database;

    await db.delete(tablePlayers);
    await db.delete(tableGames);
    await db.delete(tableRounds);
    // TODO: dodat brisanje ostalih tablica
  }

  // NOTE: Player Table funcitons

  Future<List<Player>> getPlayers() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      tablePlayers,
      orderBy: "name ASC",
    );

    return maps.map((map) => Player.fromMap(map)).toList();
  }

  Future<bool> doesPlayerExist(String name) async {
    final db = await database;

    final result = await db.query(
      tablePlayers,
      where: "LOWER(TRIM(name)) = ?",
      whereArgs: [name.trim().toLowerCase()],
    );

    return result.isNotEmpty;
  }

  Future<int> insertPlayer(Player player) async {
    final db = await database;

    return await db.insert(
      tablePlayers,
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> updatePlayer(Player player) async {
    if (player.id == null) return 0;

    final db = await database;

    return await db.update(
      tablePlayers,
      player.toMap(),
      where: "id = ?",
      whereArgs: [player.id],
    );
  }

  Future<int> deletePlayer(Player player) async {
    final db = await database;

    return await db.delete(
      tablePlayers,
      where: "id = ?",
      whereArgs: [player.id],
    );
  }

  // NOTE: Game Table funcitons

  Future<List<Game>> getGames() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        g.id, g.team1Points, g.team2Points, g.target, g.updatedAt,
        p1.id as p1Id, p1.name as p1Name, p1.numGamesPlayed as p1NumGamesPlayed, p1.numWins as p1NumWins, p1.totalMelds as p1TotalMelds,
        p2.id as p2Id, p2.name as p2Name, p2.numGamesPlayed as p2NumGamesPlayed, p2.numWins as p2NumWins, p2.totalMelds as p2TotalMelds,
        p3.id as p3Id, p3.name as p3Name, p3.numGamesPlayed as p3NumGamesPlayed, p3.numWins as p3NumWins, p3.totalMelds as p3TotalMelds,
        p4.id as p4Id, p4.name as p4Name, p4.numGamesPlayed as p4NumGamesPlayed, p4.numWins as p4NumWins, p4.totalMelds as p4TotalMelds

      FROM $tableGames g
      JOIN $tablePlayers p1 ON g.player1id = p1.id
      JOIN $tablePlayers p2 ON g.player2id = p2.id
      JOIN $tablePlayers p3 ON g.player3id = p3.id
      JOIN $tablePlayers p4 ON g.player4id = p4.id

      ORDER BY g.updatedAt DESC
    """);

    return maps.map((map) => Game.fromMap(map)).toList();
  }

  Future<List<Game>> getActiveGames() async {
    final games = await getGames();

    return games.where((game) => !game.isFinished).toList();
  }

  Future<List<Game>> getFinishedGames() async {
    final games = await getGames();

    return games.where((game) => game.isFinished).toList();
  }

  Future<int> insertGame(Game game) async {
    final db = await database;

    return await db.insert(
      tableGames,
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> updateGame(Game game) async {
    if (game.id == null) return 0;

    final db = await database;

    return await db.update(
      tableGames,
      game.toMap(),
      where: "id = ?",
      whereArgs: [game.id],
    );
  }

  Future<int> deleteGame(Game game) async {
    final db = await database;

    return await db.delete(tableGames, where: "id = ?", whereArgs: [game.id]);
  }

  // NOTE: Rounds Table funcitons

  Future<List<Round>> getRoundsForGame(Game game) async {
    if (game.id == null) return [];

    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      """
      SELECT
        r.id, r.gameId, r.callerId, r.team1Points, r.team2Points, r.stigljaTeam,
        c.name as callerName, c.numGamesPlayed as callerNumGamesPlayed,
        c.numWins as callerNumWins, c.totalMelds as callerTotalMelds

      FROM $tableRounds r
      JOIN $tablePlayers c ON r.callerId = c.id

      WHERE r.gameId = ?

      ORDER BY r.id ASC
    """,
      [game.id],
    );

    return List.generate(maps.length, (index) {
      return Round.fromMap(maps[index], game, index + 1);
    });
  }

  Future<int> insertRound(Round round) async {
    final db = await database;

    final roundId = await db.insert(
      tableRounds,
      round.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    final updatedGame = round.game.copyWith(
      team1Points: round.game.team1Points + round.team1Points,
      team2Points: round.game.team2Points + round.team2Points,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await updateGame(updatedGame);

    return roundId;
  }

  Future<int> updateRound(Round round) async {
    if (round.id == null) return 0;

    final db = await database;

    final oldRound = await db.query(
      tableRounds,
      where: "id = ?",
      whereArgs: [round.id],
    );

    if (oldRound.isEmpty) return 0;

    final oldTeam1Points = oldRound.first["team1Points"] as int;
    final oldTeam2Points = oldRound.first["team2Points"] as int;

    final updatedRound = await db.update(
      tableRounds,
      round.toMap(),
      where: "id = ?",
      whereArgs: [round.id],
    );

    final diffTeam1 = round.team1Points - oldTeam1Points;
    final diffTeam2 = round.team2Points - oldTeam2Points;

    final updatedGame = round.game.copyWith(
      team1Points: round.game.team1Points + diffTeam1,
      team2Points: round.game.team2Points + diffTeam2,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await updateGame(updatedGame);

    return updatedRound;
  }

  Future<int> deleteRound(Round round) async {
    final db = await database;

    final roundId = await db.delete(
      tableRounds,
      where: "id = ?",
      whereArgs: [round.id],
    );

    final updatedGame = round.game.copyWith(
      team1Points: round.game.team1Points - round.team1Points,
      team2Points: round.game.team2Points - round.team2Points,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await updateGame(updatedGame);

    return roundId;
  }
}
