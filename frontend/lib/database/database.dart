import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'playlists.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE playlists(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlistId TEXT,
        mood TEXT,
        userId TEXT
      )
    ''');
  }

  Future<int> insertPlaylist(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print("Inserting playlist into db");
    return await db.insert('playlists', row);
  }

  Future<List<Map<String, dynamic>>> queryAllPlaylists() async {
    Database db = await instance.database;
    return await db.query('playlists');
  }


  static Future<List<Map<String, dynamic>>> getPlaylistsByUserId(String? userId) async {
    Database db = await instance.database;
    return await db.query(
      'playlists',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

// You can add more methods to handle other operations, like deleting or updating records.
}

final DatabaseHelper instance = DatabaseHelper();
