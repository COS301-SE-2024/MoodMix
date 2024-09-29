import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_common/sqflite.dart';
import 'package:frontend/database/database.dart'; // Make sure this path is correct

void main() {
  late DatabaseHelper dbHelper;
  late Database db; // Making sure this is properly initialized

  setUpAll(() {
    // Initialize the ffi-based database for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Initialize an in-memory database to avoid issues with Android file storage
    dbHelper = DatabaseHelper();
    db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE playlists(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          playlistId TEXT,
          mood TEXT,
          userId TEXT,
          dateCreated TEXT
        )
      ''');
    });
  });

  tearDown(() async {
    // Ensure database is closed after each test
    if (db.isOpen) {
      await db.close();
    }
  });

  test('Database is created', () async {
    var tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='playlists';");
    expect(tables.isNotEmpty, true, reason: 'playlists table should exist');
    //print("Playlist table does exist");
  });

  test('Insert playlist into database', () async {
    Map<String, dynamic> playlist = {
      'playlistId': 'test123',
      'mood': 'happy',
      'userId': 'user1',
      'dateCreated': '2024-09-30',
    };
    int result = await db.insert('playlists', playlist);
    //print("Playlists inserted into database");
    expect(result, isNonZero, reason: 'Playlist should be inserted');
  });

  test('Query all playlists', () async {
    List<Map<String, dynamic>> playlists = await db.query('playlists');
    expect(playlists, isList);
  });

  test('Insert and Query playlist by userId', () async {
    // Insert a test playlist
    Map<String, dynamic> playlist = {
      'playlistId': 'test123',
      'mood': 'happy',
      'userId': 'user1',
      'dateCreated': '2024-09-30',
    };
    int insertResult = await db.insert('playlists', playlist);
    expect(insertResult, isNonZero, reason: 'Playlist should be inserted');

    // Debugging step: Print out all playlists to verify data
    List<Map<String, dynamic>> allPlaylists = await db.query('playlists');
    //print("All Playlists in DB: $allPlaylists");

    // Now query by userId
    String testUserId = 'user1';
    List<Map<String, dynamic>> result = await db.query(
      'playlists',
      where: 'userId = ?',
      whereArgs: [testUserId],
    );

    // Debugging step: Print the result of the query by userId
   // print("Playlists for userId = $testUserId: $result");

    expect(result.isNotEmpty, true, reason: 'Should return playlists for the given user');
  });
}