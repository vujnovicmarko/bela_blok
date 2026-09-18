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
    await db.execute("""
      CREATE TABLE $tablePlayers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        numGamesPlayed INTEGER NOT NULL DEFAULT 0,
        numWins INTEGER NOT NULL DEFAULT 0
      )
    """);
  }

  Future<int> insertPlayer(String name) async {
    final db = await database;

    return await db.insert(tablePlayers, {
      'name': name,
      'numGamesPlayed': 0,
      'numWins': 0,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<List<Map<String, dynamic>>> getPlayers() async {
    final db = await database;

    return await db.query(tablePlayers, orderBy: 'name ASC');
  }

  Future<int> updatePlayer(int id, String name, int games, int wins) async {
    final db = await database;

    return await db.update(
      tablePlayers,
      {'name': name, 'numGamesPlayed': games, 'numWins': wins},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePlayer(int id) async {
    final db = await database;

    return await db.delete(tablePlayers, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> doesPlayerExist(String name) async {
    final db = await database;

    final result = await db.query(
      tablePlayers,
      where: "LOWER(name) = ?",
      whereArgs: [name.trim().toLowerCase()],
    );

    return result.isNotEmpty;
  }

  Future<void> deleteAllData() async {
    final db = await database;

    await db.delete(tablePlayers);
    // TODO: dodat brisanje ostalih tablica
  }
}
