import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _dbName = "bela_blok.db";
  static const int _dbVersion = 1;

  static const String tablePlayers = "players";
  static const String tableGames = "games";

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
        points1 INTEGER NOT NULL DEFAULT 0,
        points2 INTEGER NOT NULL DEFAULT 0,
        target INTEGER NOT NULL DEFAULT 1001,
        updatedAt TEXT NOT NULL
      )
    """);
  }

  Future<void> deleteAllData() async {
    final db = await database;

    await db.delete(tablePlayers);
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

  Future<int> insertPlayer(String name) async {
    final db = await database;

    final player = Player(name: name);

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
      g.id, g.points1, g.points2, g.target, g.updatedAt,
      p1.id as p1Id, p1.name as p1Name, p1.numGamesPlayed as p1NumGamesPlayed, p1.numWins as p1NumWins, p1.totalMelds as p1TotalMelds,
      p2.id as p2Id, p2.name as p2Name, p2.numGamesPlayed as p2NumGamesPlayed, p2.numWins as p2NumWins, p2.totalMelds as p2TotalMelds,
      p3.id as p3Id, p3.name as p3Name, p3.numGamesPlayed as p3NumGamesPlayed, p3.numWins as p3NumWins, p3.totalMelds as p3TotalMelds,
      p4.id as p4Id, p4.name as p4Name, p4.numGamesPlayed as p4NumGamesPlayed, p4.numWins as p4NumWins, p4.totalMelds as p4TotalMelds

    FROM games g
    JOIN players p1 ON g.player1id = p1.id
    JOIN players p2 ON g.player2id = p2.id
    JOIN players p3 ON g.player3id = p3.id
    JOIN players p4 ON g.player4id = p4.id

    ORDER BY g.updatedAt ASC
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

  Future<int> insertGame(
    Player player1,
    Player player2,
    Player player3,
    Player player4,
    int? target,
  ) async {
    final db = await database;

    final now = DateTime.now().toIso8601String();

    final game = Game(
      player1: player1,
      player2: player2,
      player3: player3,
      player4: player4,
      target: target ?? 1001,
      updatedAt: now,
    );

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
}
