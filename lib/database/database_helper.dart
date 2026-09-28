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
    await db.execute("""
      CREATE TABLE $tablePlayers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        numGamesPlayed INTEGER NOT NULL DEFAULT 0,
        numWins INTEGER NOT NULL DEFAULT 0
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
        callingTeam INTEGER NOT NULL,
        team1CardPoints INTEGER NOT NULL,
        team2CardPoints INTEGER NOT NULL,
        team1Melds TEXT NOT NULL,
        team2Melds TEXT NOT NULL,
        stigljaTeam INTEGER NOT NULL DEFAULT 0,
        team1Points INTEGER NOT NULL,
        team2Points INTEGER NOT NULL
      )
    """);
  }

  Future<void> deleteAllData() async {
    final db = await database;

    await db.delete(tablePlayers);
    await db.delete(tableGames);
    await db.delete(tableRounds);
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

    return await db.insert(tablePlayers, player.toMap());
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
        p1.id as p1Id, p1.name as p1Name, p1.numGamesPlayed as p1NumGamesPlayed, p1.numWins as p1NumWins,
        p2.id as p2Id, p2.name as p2Name, p2.numGamesPlayed as p2NumGamesPlayed, p2.numWins as p2NumWins,
        p3.id as p3Id, p3.name as p3Name, p3.numGamesPlayed as p3NumGamesPlayed, p3.numWins as p3NumWins,
        p4.id as p4Id, p4.name as p4Name, p4.numGamesPlayed as p4NumGamesPlayed, p4.numWins as p4NumWins

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

    return await db.insert(tableGames, game.toMap());
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

    final List<Map<String, dynamic>> maps = await db.query(
      tableRounds,
      where: "gameId = ?",
      whereArgs: [game.id],
    );

    return List.generate(maps.length, (index) {
      return Round.fromMap(maps[index], game, index + 1);
    });
  }

  Future<int> insertRound(Round round) async {
    final db = await database;

    int roundId = 0;

    await db.transaction((tnx) async {
      roundId = await tnx.insert(tableRounds, round.toMap());

      final updatedGame = round.game.copyWith(
        team1Points: round.game.team1Points + round.team1Points,
        team2Points: round.game.team2Points + round.team2Points,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await tnx.update(
        tableGames,
        updatedGame.toMap(),
        where: "id = ?",
        whereArgs: [updatedGame.id],
      );
    });

    return roundId;
  }

  Future<int> updateRound(Round round) async {
    if (round.id == null) return 0;

    final db = await database;

    int updatedRound = 0;

    await db.transaction((tnx) async {
      final oldRound = await tnx.query(
        tableRounds,
        where: "id = ?",
        whereArgs: [round.id],
      );

      if (oldRound.isEmpty) return 0;

      final oldTeam1Points = oldRound.first["team1Points"] as int;
      final oldTeam2Points = oldRound.first["team2Points"] as int;

      updatedRound = await tnx.update(
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

      await tnx.update(
        tableGames,
        updatedGame.toMap(),
        where: "id = ?",
        whereArgs: [updatedGame.id],
      );
    });

    return updatedRound;
  }

  Future<int> deleteRound(Round round) async {
    final db = await database;

    int roundId = 0;

    await db.transaction((tnx) async {
      roundId = await tnx.delete(
        tableRounds,
        where: "id = ?",
        whereArgs: [round.id],
      );

      final updatedGame = round.game.copyWith(
        team1Points: round.game.team1Points - round.team1Points,
        team2Points: round.game.team2Points - round.team2Points,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await tnx.update(
        tableGames,
        updatedGame.toMap(),
        where: "id = ?",
        whereArgs: [updatedGame.id],
      );
    });

    return roundId;
  }
}
