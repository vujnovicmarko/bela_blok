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
        name TEXT UNIQUE NOT NULL
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

    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        p.*,
        COUNT(DISTINCT g_all.id) as numGamesPlayed,
        COUNT(DISTINCT g_won.id) as numWins
      FROM $tablePlayers p
      LEFT JOIN $tableGames g_all ON
        ((g_all.team1Points >= g_all.target OR g_all.team2Points >= g_all.target) AND g_all.team1Points <> g_all.team2Points)
        AND (g_all.player1id = p.id OR g_all.player2id = p.id OR g_all.player3id = p.id OR g_all.player4id = p.id)
      LEFT JOIN $tableGames g_won ON
        ((g_won.team1Points >= g_won.target OR g_won.team2Points >= g_won.target) AND g_won.team1Points <> g_won.team2Points)
        AND (
          (g_won.team1Points > g_won.team2Points AND (g_won.player1id = p.id OR g_won.player3id = p.id))
          OR
          (g_won.team2Points > g_won.team1Points AND (g_won.player2id = p.id OR g_won.player4id = p.id))
        )
      GROUP BY p.id
      ORDER BY p.name ASC
    """);

    return maps.map((m) => Player.fromMap(m)).toList();
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
        p1.id as p1Id, p1.name as p1Name,
        p2.id as p2Id, p2.name as p2Name,
        p3.id as p3Id, p3.name as p3Name,
        p4.id as p4Id, p4.name as p4Name

      FROM $tableGames g
      JOIN $tablePlayers p1 ON g.player1id = p1.id
      JOIN $tablePlayers p2 ON g.player2id = p2.id
      JOIN $tablePlayers p3 ON g.player3id = p3.id
      JOIN $tablePlayers p4 ON g.player4id = p4.id

      ORDER BY g.updatedAt DESC
    """);

    return maps.map((map) => Game.fromMap(map)).toList();
  }

  Future<Game?> getGame(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      """
      SELECT
        g.id, g.team1Points, g.team2Points, g.target, g.updatedAt,
        p1.id as p1Id, p1.name as p1Name,
        p2.id as p2Id, p2.name as p2Name,
        p3.id as p3Id, p3.name as p3Name,
        p4.id as p4Id, p4.name as p4Name

      FROM $tableGames g
      JOIN $tablePlayers p1 ON g.player1id = p1.id
      JOIN $tablePlayers p2 ON g.player2id = p2.id
      JOIN $tablePlayers p3 ON g.player3id = p3.id
      JOIN $tablePlayers p4 ON g.player4id = p4.id
      WHERE g.id = ?

      ORDER BY g.updatedAt DESC
    """,
      [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Game.fromMap(maps.first);
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

      final totals = await tnx.rawQuery(
        """
        SELECT SUM(team1Points) AS team1TotalPoints, SUM(team2Points) AS team2TotalPoints

        FROM $tableRounds
        WHERE gameId = ?
        """,
        [round.game.id],
      );

      final int team1TotalPoints =
          (totals.first["team1TotalPoints"] as int?) ?? 0;
      final int team2TotalPoints =
          (totals.first["team2TotalPoints"] as int?) ?? 0;

      final updatedGame = round.game.copyWith(
        team1Points: team1TotalPoints,
        team2Points: team2TotalPoints,
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

    int updatedRows = 0;

    await db.transaction((tnx) async {
      updatedRows = await tnx.update(
        tableRounds,
        round.toMap(),
        where: "id = ?",
        whereArgs: [round.id],
      );

      if (updatedRows == 0) return;

      final totals = await tnx.rawQuery(
        """
        SELECT SUM(team1Points) AS team1TotalPoints, SUM(team2Points) AS team2TotalPoints

        FROM $tableRounds
        WHERE gameId = ?
        """,
        [round.game.id],
      );

      final int team1TotalPoints =
          (totals.first["team1TotalPoints"] as int?) ?? 0;
      final int team2TotalPoints =
          (totals.first["team2TotalPoints"] as int?) ?? 0;

      final updatedGame = round.game.copyWith(
        team1Points: team1TotalPoints,
        team2Points: team2TotalPoints,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await tnx.update(
        tableGames,
        updatedGame.toMap(),
        where: "id = ?",
        whereArgs: [updatedGame.id],
      );
    });

    return updatedRows;
  }

  Future<int> deleteRound(Round round) async {
    final db = await database;

    int deletedRows = 0;

    await db.transaction((tnx) async {
      deletedRows = await tnx.delete(
        tableRounds,
        where: "id = ?",
        whereArgs: [round.id],
      );

      if (deletedRows == 0) return;

      final totals = await tnx.rawQuery(
        """
        SELECT SUM(team1Points) AS team1TotalPoints, SUM(team2Points) AS team2TotalPoints

        FROM $tableRounds
        WHERE gameId = ?
        """,
        [round.game.id],
      );

      final int team1TotalPoints =
          (totals.first["team1TotalPoints"] as int?) ?? 0;
      final int team2TotalPoints =
          (totals.first["team2TotalPoints"] as int?) ?? 0;

      final updatedGame = round.game.copyWith(
        team1Points: team1TotalPoints,
        team2Points: team2TotalPoints,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await tnx.update(
        tableGames,
        updatedGame.toMap(),
        where: "id = ?",
        whereArgs: [updatedGame.id],
      );
    });

    return deletedRows;
  }
}
