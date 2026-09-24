import 'package:bela_blok/models/player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _dbName = "bela_blok.db";
  static const int _dbVersion = 1;

  static const String tablePlayers = "players";

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

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
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
}
